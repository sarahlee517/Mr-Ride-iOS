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

class InformationMapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate{
    @IBOutlet weak var areaLabel: UIView!

    @IBOutlet weak var arrowImage: UIImageView!
    @IBOutlet weak var ButtonTitleLabel: UILabel!
    @IBOutlet weak var AddressLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var minsLabel: UIView!
    @IBOutlet weak var detailMapView: MKMapView!
    
    @IBOutlet weak var categoryLabel: UILabel!
    @IBAction func pickerButton(sender: AnyObject) {
        ButtonTitleLabel.userInteractionEnabled = false
        pickerView.hidden = false
        pickerViewToolBar.hidden = false
    }
    @IBOutlet weak var dashboard: UIView!
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var pickerViewToolBar: UIView!
    @IBAction func pickerCancelButton(sender: AnyObject) {
        
        self.pickerView.hidden = true
        self.pickerViewToolBar.hidden = true
        
    }

    @IBAction func pickerViewDoneButton(sender: AnyObject) {
        
        self.pickerView.hidden = true
        self.pickerViewToolBar.hidden = true
        
    }
    let locationManager = CLLocationManager()
    
    let pickerData = ["Toilet", "Ubike Station"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupViews()
        PublicToiletManager.sharedManager.getPublicToilet(){ data in

            self.addToiletAnnotations(data)
        }
  
        self.detailMapView.delegate = self
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        self.detailMapView.showsUserLocation = true
        
        //picker view
        self.pickerView.dataSource = self
        self.pickerView.delegate = self
        self.pickerView.hidden = true
        self.pickerViewToolBar.hidden = true
        self.pickerView.backgroundColor = UIColor.whiteColor()
        self.pickerViewToolBar.layer.borderWidth = 1
        pickerViewToolBar.layer.borderColor = UIColor.mrBlack15Color().CGColor
        

    
    }
    
    // implement pickerview delegate 
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count;
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch row {
        case 0:
            ButtonTitleLabel.text = pickerData[row]
            PublicToiletManager.sharedManager.getPublicToilet(){ data in
                self.addToiletAnnotations(data)
            }
        default:
            ButtonTitleLabel.text = pickerData[row]
            YouBikeManager.sharedManager.getStation(){ data in
                self.addStationAnnotations(data)
            }
        }
    }
    
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
        
        
        let annotationView = MKAnnotationView()
        annotationView.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        annotationView.layer.cornerRadius = annotationView.frame.width / 2
        annotationView.backgroundColor = UIColor.whiteColor()
        annotationView.layer.shadowColor = UIColor.blackColor().CGColor
        annotationView.layer.shadowOffset = CGSize(width: 0, height: 2)
        annotationView.layer.shadowOpacity = 0.5
        
        let toiletView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        toiletView.center = CGPointMake(annotationView.frame.width / 2, annotationView.frame.height / 2 )
        toiletView.backgroundColor = UIColor(patternImage: UIImage(named: imageName)!)
        annotationView.addSubview(toiletView)
        
        return annotationView
    }

    //=======================
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        
        let newRegion = MKCoordinateRegion(center: detailMapView.userLocation.coordinate, span: MKCoordinateSpanMake(0.05, 0.05))
        detailMapView.setRegion(newRegion, animated: true)
        
    }
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        
        dashboard.hidden = false
        
        view.backgroundColor = UIColor.mrLightblueColor()
        
        if let annotation = view.annotation as? MyAnnotaion{
            switch annotation.type! {
            case "toilet":
                titleLabel.text = annotation.title
                AddressLabel.text = annotation.address
                categoryLabel.text = annotation.category
            default:
                titleLabel.text = annotation.title
                AddressLabel.text = annotation.address
                categoryLabel.text = annotation.category
            }

        }
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if view.annotation is MyAnnotaion{
            
        }
    }
    
    func mapView(mapView: MKMapView, didDeselectAnnotationView view: MKAnnotationView) {
        
        view.backgroundColor = UIColor.whiteColor()
        dashboard.hidden = true
    }
    
    
    func addToiletAnnotations(data: [PublicToiletModel]){
        
        detailMapView.removeAnnotations(detailMapView.annotations)
        if data.count > 0{
            var annotations = [MyAnnotaion]()
            
            for toilet in data{
                
                let annotation = MyAnnotaion(type: "toilet",
                    address: toilet.address, category: toilet.Category)
                annotation.title = toilet.name
                annotation.coordinate = toilet.coordinate
                annotations.append(annotation)
            }
            
            detailMapView.addAnnotations(annotations)
        }else { print("no data") }
    }

    
    func addStationAnnotations(data: [YouBikeModel]){
        
        detailMapView.removeAnnotations(detailMapView.annotations)
        print(1)
        if data.count > 0{
            var annotations = [MyAnnotaion]()
            
            for station in data{
                
                let annotation = MyAnnotaion(type: "station",
                    address: station.address, category: station.district)
                annotation.title = station.name
                annotation.subtitle = String(station.numberOfRemainingBikes)
                annotation.coordinate = station.coordinate
                annotations.append(annotation)
            }
            
            detailMapView.addAnnotations(annotations)
        }else { print("no data") }
    }
}



//MARK: - Setup UI
extension InformationMapViewController{
    
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


}

