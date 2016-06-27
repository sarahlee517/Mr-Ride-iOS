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
    var buttonDidClicked = false
    weak var trackingViewController: TrackingViewController?
    weak var statisticViewController: StatisticViewController?
    var currentLocation: CLLocation?
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myLocations.removeAll()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.activityType = .AutomotiveNavigation
        locationManager.distanceFilter = 5.0
        
        mapView.delegate = self
        setupMapView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        locationManager.requestWhenInUseAuthorization()
    }
}



//MARK: - Location Manager
extension MapViewController{
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        
        myLocations.append(locations[0] as CLLocation)
        
        let newRegion = MKCoordinateRegion(center: mapView.userLocation.coordinate, span: MKCoordinateSpanMake(0.005, 0.005))
        mapView.setRegion(newRegion, animated: true)
        
    }
    
    func showUserLocation(){
        mapView.showsUserLocation = true
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError){
        print("Errors: " + error.localizedDescription)
    }
}


// MARK: - Setup UI
extension MapViewController{
    func startUpdateUI(){
        
        if let location = currentLocation{
            distance += locationManager.location!.distanceFromLocation(location)
            speed = locationManager.location!.speed * 3.6
            
            trackingViewController!.distanceLabel.text = String(format: "%.1f m", distance)
            if speed < 0 { speed = 0 }
            trackingViewController!.speedLabel.text = String(format: "%.1f km / h", speed)
            
            trackingViewController!.distance = distance
        }
        
        currentLocation = locationManager.location
        
        drawPolyLine(myLocations)
        trackingViewController!.location = myLocations
        
    }
    
    func setupMapView(){
        mapView.layer.cornerRadius = 10
    }
}


//MARK: - Draw Polyline
extension MapViewController{
    func drawPolyLine(location:[CLLocation]){
        
        if (location.count > 1){
            
            let sourceIndex = location.count - 1
            let destinationIndex = location.count - 2
            
            let source = location[sourceIndex].coordinate
            let destination = location[destinationIndex].coordinate
            var route = [source, destination]
            
            let polyline = MKPolyline(coordinates: &route, count: route.count)
            mapView.addOverlay(polyline)
        }
    }
    
    
    func setPolyLineRegion(locations: [CLLocation]){
        locationManager.stopUpdatingLocation()
        var coords = [CLLocationCoordinate2D]()
        
        for location in locations{
            coords.append(location.coordinate)
        }
        
        let polyline = MKPolyline(coordinates: &coords, count: coords.count)
        
        var regionRect = polyline.boundingMapRect
        
        let wPadding = regionRect.size.width * 0.25
        let hPadding = regionRect.size.height * 0.25
        
        //Add padding to the region
        regionRect.size.width += wPadding
        regionRect.size.height += hPadding
        
        //Center the region on the line
        regionRect.origin.x -= wPadding / 2
        regionRect.origin.y -= hPadding / 2
        
        mapView.addOverlay(polyline)
        mapView.setVisibleMapRect(regionRect, animated: true)
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        renderer.strokeColor = UIColor.mrBubblegumColor()
        renderer.lineWidth = 5
        return renderer
    }
}
