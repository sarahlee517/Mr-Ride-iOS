//
//  TrackingViewController.swift
//  Mr Ride
//
//  Created by Sarah on 5/24/16.
//  Copyright © 2016 AppWorks School Sarah Lee. All rights reserved.
//

import UIKit
import CoreData
import MapKit
import Charts

protocol DismissDelegate: class{
    func showHomaPages()
}


class TrackingViewController: UIViewController{
    
    @IBOutlet weak var calBurnedLabel: UILabel!
    @IBOutlet weak var mapView: UIView!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var gradient: UIView!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var buttonRingView: UIView!
    @IBOutlet weak var recordTimeLabel: UILabel!
    @IBAction func recordButtonDidClicked(sender: AnyObject) {
        showFinish()
        stopwatch()
    }
    
    weak var delegate: DismissDelegate?
    
    let ride = [RideData]()
    let calorieCalculator = CalorieCalculator()
    let gradientLayer = CAGradientLayer()
    var timer = NSTimer()
    var hours = 0
    var minutes = 0
    var seconds = 0
    var fractions = 0
    var calTime = 0.0
    var totalFraction = 0
    var date = ""
    var distance = 0.0
    var location = [CLLocation]()
    
    let moc = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    //MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupRecordButton()
        setupRecordLabel()
        setupGradientView()
        mapViewController.myLocations.removeAll()
        mapViewController.showUserLocation()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        timer.invalidate()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        TrackingManager.sharedManager.createTrackingScreenView("view_in_record_creating")
    }
    
    private var mapViewController: MapViewController!
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let mapView = segue.destinationViewController as? MapViewController where segue.identifier == "EmbedSegueFromTrackingPage"{
            self.mapViewController = mapView
            mapViewController.trackingViewController = self
        }
    }
    
    

}



//MARK: - Stopwatch
extension TrackingViewController{
    
    func stopwatch(){
        
        if !timer.valid{
            
            
            timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
            mapViewController.myLocations.removeAll()
            mapViewController.currentLocation = mapViewController.locationManager.location
        }else{
            
            timer.invalidate()
        }
    }
    
    @objc func updateTime(timer: NSTimer){
        
        fractions += 1
        totalFraction += 1
        
        if fractions == 100{
            calTime += 1
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
        
        updateTimerLabels()
        updateKcalLabel()
        mapViewController.startUpdateUI()
        
    }
}



//MARK: - Setup UI
extension TrackingViewController{
    
    func setupNavigationBar(){
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(self.clickedCancel))
        
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        self.navigationController?.navigationBar.barTintColor = UIColor.mrLightblueColor()
        self.navigationController?.navigationBar.translucent = false
        
        setupDate()
    }
    
    func showFinish(){
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Finish", style: UIBarButtonItemStyle.Done, target: self, action: #selector(self.clickedFinish))
    }
    
    func clickedCancel(){
        
        TrackingManager.sharedManager.createTrackingEvent("record_creating", action: "select_cancel_in_record_creating")
        
        self.delegate?.showHomaPages()
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func clickedFinish(){

        TrackingManager.sharedManager.createTrackingEvent("record_creating", action: "select_finish_in_record_creating")
        
        saveRide()
        
        do {
            try self.moc.save()
        }catch{
            fatalError("Failure to save context: \(error)")
        }
        
        let statisticViewController = self.storyboard!.instantiateViewControllerWithIdentifier("StatisticViewController") as! StatisticViewController
        statisticViewController.navigationController?.modalPresentationStyle = .OverCurrentContext
        statisticViewController.delegate = delegate
        

        statisticViewController.setupNavigationBar(Mode.closeMode)
        
        statisticViewController.distance = distance
        statisticViewController.totalTime = totalFraction
        statisticViewController.location = location
        
        mapViewController.locationManager.stopUpdatingLocation()
        
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
    
    func updateTimerLabels(){
        let strHours = String(format: "%02d", hours)
        let strMinutes = String(format: "%02d", minutes)
        let strSeconds = String(format: "%02d", seconds)
        let strFraction = String(format: "%02d", fractions)
        
        recordTimeLabel.text = "\(strHours):\(strMinutes):\(strSeconds).\(strFraction)"
    }
    
    func updateKcalLabel(){
        let averageSpeed = (mapViewController.distance/1000) / (calTime/3600)
        
        let kCalBurned = calorieCalculator.kiloCalorieBurned(.Bike, speed: averageSpeed, weight: 50.0, time: calTime/3600)
        if (kCalBurned >= 0.01){
            calBurnedLabel.text = String(format: "%.2f kcal", kCalBurned)
        }
    }
    
    func setupGradientView(){
        
        gradientLayer.frame = self.view.bounds
        
        let color1 = UIColor.mrBlack60Color().CGColor as CGColorRef
        let color2 = UIColor.mrBlack40Color().CGColor as CGColorRef
        
        gradientLayer.colors = [color1, color2]
        gradientLayer.locations = [0.0, 0.5]
        self.gradient.layer.addSublayer(gradientLayer)
    }
    
    func setupDate(){
        
        let currentDate = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "ja_JP")
        dateFormatter.dateFormat = "yyyy/MM/dd"
        date = dateFormatter.stringFromDate(currentDate)
        self.navigationItem.title = date
        
    }
    
}


//MARK: - Core Data
extension TrackingViewController{
    func saveRide(){
        
        let saveRide = NSEntityDescription.insertNewObjectForEntityForName("RideHistory", inManagedObjectContext: moc) as! RideHistory
        
//        //fake date for testing tableView section
//        let myDateString = "2016-06-04"
//        fakeDate(saveRide, myDateString: myDateString)

        
        saveRide.date = NSDate()
        saveRide.distance = mapViewController.distance
        saveRide.totalTime = totalFraction
        saveRide.weight = 50.0
        
        let locations = mapViewController.myLocations
        var savedLocations = [Locations]()
        for location in locations{
            let savedLocation = NSEntityDescription.insertNewObjectForEntityForName("Locations", inManagedObjectContext: self.moc) as! Locations
            savedLocation.timestamp = location.timestamp
            savedLocation.latitude = location.coordinate.latitude
            savedLocation.longtitude = location.coordinate.longitude
            savedLocations.append(savedLocation)
        }
        
        saveRide.locations = NSOrderedSet(array: savedLocations)
    }
    
    //For Debugging TableView Section
    func fakeDate(saveRide: RideHistory, myDateString: String){
        let mydateFormatter = NSDateFormatter()
        mydateFormatter.calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierISO8601)
        mydateFormatter.dateFormat = "yyyy-MM-dd"
        mydateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        if let dateToBeSaved = mydateFormatter.dateFromString(myDateString) {
            saveRide.date = dateToBeSaved
        }
    }
    
    
}







