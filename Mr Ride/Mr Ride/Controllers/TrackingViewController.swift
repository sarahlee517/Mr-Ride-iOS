//
//  TrackingViewController.swift
//  Mr Ride
//
//  Created by Sarah on 5/24/16.
//  Copyright © 2016 AppWorks School Sarah Lee. All rights reserved.
//

import UIKit
import CoreLocation
import HealthKit
import MapKit

class TrackingViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var gradient: UIView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var buttonRingView: UIView!
    @IBOutlet weak var recordTimeLabel: UILabel!
    @IBAction func recordButtonDidClicked(sender: AnyObject) {
        stopwatch()
    }
    
    let locationManager = CLLocationManager()
    let gradientLayer = CAGradientLayer()
    var timer = NSTimer()
    var hours = 0
    var minutes = 0
    var seconds = 0
    var fractions = 0
    var myLocations: [CLLocation] = []
    
    //MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupRecordButton()
        setupMapView()
        setupRecordLabel()
        setupGradientView()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        mapView.delegate = self
        mapView.showsUserLocation = true

        
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        
        myLocations.append(locations[0] as CLLocation)

        let newRegion = MKCoordinateRegion(center: mapView.userLocation.coordinate, span: MKCoordinateSpanMake(0.005, 0.005))
        mapView.setRegion(newRegion, animated: true)
        
        if (myLocations.count > 1){
            let sourceIndex = myLocations.count - 1
            let destinationIndex = myLocations.count - 2
            
            let source = myLocations[sourceIndex].coordinate
            let destination = myLocations[destinationIndex].coordinate
            var route = [source, destination]
            let polyline = MKPolyline(coordinates: &route, count: route.count)
            mapView.addOverlay(polyline)
        }
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        renderer.strokeColor = UIColor.blueColor()
        renderer.lineWidth = 3
        return renderer
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError){
        print("Errors: " + error.localizedDescription)
    }
    
}

//MARK: - Stopwatch
extension TrackingViewController{
    
    func stopwatch(){
        
        if !timer.valid{
            timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        }else{
            timer.invalidate()
        }
    }
    
    @objc func updateTime(){
        fractions += 1
        
        if fractions == 100{
            seconds += 1
            fractions = 0
        }
        
        if seconds == 60{
            minutes += 1
            seconds = 0
        }
        
        if minutes == 60{
            hours += 1
            minutes = 0
        }
        
        let strHours = String(format: "%02d", hours)
        let strMinutes = String(format: "%02d", minutes)
        let strSeconds = String(format: "%02d", seconds)
        let strFraction = String(format: "%02d", fractions)
        
        recordTimeLabel.text = "\(strHours):\(strMinutes):\(strSeconds).\(strFraction)"
    }
}


//MARK: - Setup
extension TrackingViewController{

    func setupNavigationBar(){
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(self.clickedCancel))
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Finish", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(self.clickedFinish))
        
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        self.navigationController?.navigationBar.barTintColor = UIColor.mrLightblueColor()
        self.navigationController?.navigationBar.translucent = false
    }
    
    func clickedCancel(){
        
        //navigationController?.popToRootViewControllerAnimated(true)
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func clickedFinish(){
        let statisticViewController = self.storyboard!.instantiateViewControllerWithIdentifier("StatisticViewController") as! StatisticViewController
        statisticViewController.setupNavigationBar(Mode.closeMode)
        self.navigationController?.pushViewController(statisticViewController, animated: true)
    }
    
    
    func setupRecordButton(){
        recordButton.layer.cornerRadius = recordButton.frame.width / 2
        buttonRingView.backgroundColor = UIColor.clearColor()
        buttonRingView.layer.cornerRadius = buttonRingView.frame.width / 2
        buttonRingView.layer.borderWidth = 4
        buttonRingView.layer.borderColor = UIColor.whiteColor().CGColor
        
    }
    
    func setupRecordLabel(){
        recordTimeLabel.text = "00:00:00.00"
        recordTimeLabel.textColor = UIColor.mrWhiteColor()
        recordTimeLabel.font = UIFont.mrRobotoMonoLightFon(30)
        
    }
    
    func setupMapView(){
        mapView.layer.cornerRadius = 10
    }
    
    func setupGradientView(){
        
        gradientLayer.frame = self.view.bounds
        
        let color1 = UIColor.mrBlack60Color().CGColor as CGColorRef
        let color2 = UIColor.mrBlack40Color().CGColor as CGColorRef
        
        gradientLayer.colors = [color1, color2]
        gradientLayer.locations = [0.0, 0.5]
        self.gradient.layer.addSublayer(gradientLayer)
    }

}





