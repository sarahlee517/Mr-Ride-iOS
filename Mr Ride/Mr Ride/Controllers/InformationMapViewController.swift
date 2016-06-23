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

class InformationMapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    @IBOutlet weak var areaLabel: UIView!

    @IBOutlet weak var arrowImage: UIImageView!
    @IBOutlet weak var ButtonTitleLabel: UILabel!
    @IBOutlet weak var AddressLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var minsLabel: UIView!
    @IBOutlet weak var detailMapView: MKMapView!
    
    @IBAction func pickerButton(sender: AnyObject) {
    }
    @IBOutlet weak var dashboard: UIView!
    
    let locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupMap()
        PublicToiletManager.sharedManager.getPublicToilet(){ data in

            self.addAnnotations(data)
        }
  
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        self.detailMapView.showsUserLocation = true
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        
        let newRegion = MKCoordinateRegion(center: detailMapView.userLocation.coordinate, span: MKCoordinateSpanMake(0.005, 0.005))
        detailMapView.setRegion(newRegion, animated: true)
        
    }
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        
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
    
    func setupMap(){
        detailMapView.layer.cornerRadius = 10
    }
    
    func addAnnotations(data: [PublicToiletModel]){
        if data.count > 0{
            var annotations = [MKPointAnnotation]()
            
            for toilet in data{                
                let annotation = MKPointAnnotation()
                annotation.title = toilet.name
                annotation.coordinate = toilet.coordinate
                annotations.append(annotation)
            }
            
            detailMapView.addAnnotations(annotations)
        }else { print("no data") }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
