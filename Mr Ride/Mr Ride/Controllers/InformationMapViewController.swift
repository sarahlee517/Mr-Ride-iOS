//
//  InformationMapViewController.swift
//  Mr Ride
//
//  Created by Sarah on 6/20/16.
//  Copyright © 2016 AppWorks School Sarah Lee. All rights reserved.
//

import UIKit
import MMDrawerController
import MapKit


class InformationMapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate{
    @IBOutlet weak var areaLabel: UIView!
    @IBOutlet weak var arrowImage: UIImageView!
    @IBOutlet weak var ButtonTitleLabel: UILabel!
    @IBOutlet weak var AddressLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var minsLabel: UIView!
    @IBOutlet weak var detailMapView: MKMapView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var dashboard: UIView!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var pickerViewToolBar: UIView!
    
    @IBAction func pickerButton(sender: AnyObject) {
        TrackingManager.sharedManager.createTrackingScreenView("view_in_look_for_picker")
        
        ButtonTitleLabel.userInteractionEnabled = false
        pickerView.hidden = false
        pickerViewToolBar.hidden = false
    }
    
    @IBAction func pickerCancelButton(sender: AnyObject) {
        TrackingManager.sharedManager.createTrackingEvent("look_for_picker", action: "select_cancel_in_look_for_picker")
        
        self.pickerView.hidden = true
        self.pickerViewToolBar.hidden = true
    }
    
    @IBAction func pickerViewDoneButton(sender: AnyObject) {
        TrackingManager.sharedManager.createTrackingEvent("look_for_picker", action: "select_done_in_look_for_picker")
        
        self.pickerView.hidden = true
        self.pickerViewToolBar.hidden = true
    }
    
    let locationManager = CLLocationManager()
    let pickerData = ["Toilet", "Ubike Station"]
    
}



//MARK: - Lifecycle
extension InformationMapViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupViews()
        setupUserLocation()
        PublicToiletManager.sharedManager.getPublicToilet(){ data in
            self.addToiletAnnotations(data)
            self.setupUserLocation()
        }
        
        //location manager delegate
        self.detailMapView.delegate = self
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        self.detailMapView.showsUserLocation = true
        
        //picker view delegate
        self.pickerView.dataSource = self
        self.pickerView.delegate = self
        setupPickerView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        TrackingManager.sharedManager.createTrackingScreenView("view_in_toilet_map")
    }
    
}



//MARK: - Custom Annotations
extension InformationMapViewController{
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            return nil
        }
        
        var imageName = "icon-station"
        
        if let myAnnotation = annotation as? MyAnnotaion{
            switch myAnnotation.type! {
            case "toilet":
                imageName = "icon-toilet"
            default:
                imageName = "icon-station"
            }
        }
        
        let customAnnitationView = customAnnotationView(imageName)
        
        return customAnnitationView
    }
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        
        if view.annotation is MKUserLocation {
            view.backgroundColor = UIColor.clearColor()
            return
        }
        
        dashboard.hidden = false
        
        view.backgroundColor = UIColor.mrLightblueColor()
        
        if let annotation = view.annotation as? MyAnnotaion{
            switch annotation.type! {
            case "toilet":
                TrackingManager.sharedManager.createTrackingScreenView("view_in_toilet_map")
                titleLabel.text = annotation.title
                AddressLabel.text = annotation.address
                categoryLabel.text = annotation.category
            default:
                TrackingManager.sharedManager.createTrackingScreenView("view_in_ubike_station_map")
                titleLabel.text = annotation.title
                AddressLabel.text = annotation.address
                categoryLabel.text = annotation.category
            }
            
        }
    }
    
    func mapView(mapView: MKMapView, didDeselectAnnotationView view: MKAnnotationView) {
        
        if view.annotation is MKUserLocation {
            view.backgroundColor = UIColor.clearColor()
            return
        }
        
        view.backgroundColor = UIColor.whiteColor()
        dashboard.hidden = true
    }
    
    func addToiletAnnotations(data: [PublicToiletModel]){
        
        detailMapView.removeAnnotations(detailMapView.annotations)
        var annotations = [MyAnnotaion]()
        
        for toilet in data{
            
            let annotation = MyAnnotaion(type: "toilet",
                                         address: toilet.address,
                                         category: toilet.Category)
            annotation.title = toilet.name
            annotation.coordinate = toilet.coordinate
            annotations.append(annotation)
        }
        
        detailMapView.addAnnotations(annotations)
        
    }
    
    func addStationAnnotations(data: [YouBikeModel]){
        
        detailMapView.removeAnnotations(detailMapView.annotations)
        var annotations = [MyAnnotaion]()
        
        for station in data{
            
            let numberOfRemainingBikesString = String(format: "%d bike(s) left", station.numberOfRemainingBikes)
            
            let annotation = MyAnnotaion(type: "station",
                                         address: station.address,
                                         category: station.district)
            annotation.title = station.name
            annotation.subtitle = String(station.numberOfRemainingBikes)
            annotation.coordinate = station.coordinate
            annotation.subtitle = numberOfRemainingBikesString
            annotations.append(annotation)
        }
        
        detailMapView.addAnnotations(annotations)
        
    }
    
    func customAnnotationView(imageName: String) -> MKAnnotationView{
        
        let annotationView = MKAnnotationView()
        annotationView.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        annotationView.layer.cornerRadius = annotationView.frame.width / 2
        annotationView.backgroundColor = UIColor.whiteColor()
        annotationView.layer.shadowColor = UIColor.blackColor().CGColor
        annotationView.layer.shadowOffset = CGSize(width: 0, height: 2)
        annotationView.layer.shadowOpacity = 0.5
        annotationView.canShowCallout = true
        
        let toiletView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        toiletView.center = CGPointMake(annotationView.frame.width / 2, annotationView.frame.height / 2 )
        toiletView.backgroundColor = UIColor(patternImage: UIImage(named: imageName)!)
        annotationView.addSubview(toiletView)
        
        return annotationView
    }

}




//MARK: - PickerView
extension InformationMapViewController: UIPickerViewDataSource, UIPickerViewDelegate{
    
    //implement UIPickerViewDataSource
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    //setup pickerview
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch row {
        case 0:
            ButtonTitleLabel.text = pickerData[row]
            PublicToiletManager.sharedManager.getPublicToilet(){ data in
                self.addToiletAnnotations(data)
                self.setupUserLocation()
            }
        default:
            ButtonTitleLabel.text = pickerData[row]
            YouBikeManager.sharedManager.getStation(){ data in
                self.addStationAnnotations(data)
                self.setupUserLocation()
            }
        }
    }
    
}



//MARK: - Setup UI
extension InformationMapViewController{
    
    func setupUserLocation(){
        
        if let userLocation = self.locationManager.location?.coordinate{
            let newRegion = MKCoordinateRegion(center: userLocation, span: MKCoordinateSpanMake(0.005, 0.005))
            self.detailMapView.setRegion(newRegion, animated: true)
        }
        else{
            let newRegion = MKCoordinateRegion(center: detailMapView.userLocation.coordinate, span: MKCoordinateSpanMake(0.005, 0.005))
            self.detailMapView.setRegion(newRegion, animated: true)
        }
        
    }
    
    func setupNavigationBar(){
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon-menu.png"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(self.doneSlide))
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.topItem?.title = "Map"
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = true
    }
    
    func doneSlide(){
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.homePageContainer.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
        
    }
    
    func setupViews(){
        detailMapView.layer.cornerRadius = 10
        
        categoryLabel.layer.cornerRadius = 2
        categoryLabel.layer.borderWidth = 0.5
        categoryLabel.layer.borderColor = UIColor.whiteColor().CGColor
        
        dashboard.layer.cornerRadius = 10
        
        dashboard.hidden = true
    }
    
    func setupPickerView(){
        self.pickerView.hidden = true
        self.pickerViewToolBar.hidden = true
        self.pickerView.backgroundColor = UIColor.whiteColor()
        self.pickerViewToolBar.layer.borderWidth = 1
        pickerViewToolBar.layer.borderColor = UIColor.mrBlack15Color().CGColor
    }
}

