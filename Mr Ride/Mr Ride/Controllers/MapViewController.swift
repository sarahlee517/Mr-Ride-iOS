//
//  MapViewController.swift
//  Mr Ride
//
//  Created by Sarah on 5/31/16.
//  Copyright © 2016 AppWorks School Sarah Lee. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate{
    @IBOutlet var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    var myLocations: [CLLocation] = []
    var distance = 0.0
    var speed = 0.0
    weak var trackingViewController: TrackingViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myLocations.removeAll()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.activityType = .Fitness
//        locationManager.distanceFilter = 10.0
        
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        
        setupMapView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        locationManager.requestWhenInUseAuthorization()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        
        if let myLastLocation = myLocations.last{
            distance += locations[0].distanceFromLocation(myLastLocation)
            trackingViewController!.distanceLabel.text = String(format: "%.2f m", distance)
            
            speed = locations[0].speed * 3.6
            trackingViewController!.speedLabel.text = String(format: "%.1f km / h", speed)
            
            
            
        }
        
        
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

    
    func setupMapView(){
        mapView.layer.cornerRadius = 10
    }
}
