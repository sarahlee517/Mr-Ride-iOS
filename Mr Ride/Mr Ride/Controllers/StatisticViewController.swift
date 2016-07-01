//
//  StatisticViewController.swift
//  Mr Ride
//
//  Created by Sarah on 5/25/16.
//  Copyright © 2016 AppWorks School Sarah Lee. All rights reserved.
//

import UIKit
import CoreData
import MapKit
import Social

enum Mode{
    case closeMode
    case backMode
}



class StatisticViewController: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var gradient: UIView!
    @IBOutlet weak var recordTimeLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var avgSpeedLabel: UILabel!
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var fbButton: UIButton!
    @IBOutlet weak var fbImage: UIImageView!
    
    weak var delegate: DismissDelegate?
    
    let gradientLayer = CAGradientLayer()
    var date = ""
    let calorieCalculator = CalorieCalculator()
    var totalTime = 0
    var distance = 0.0
    var location = [CLLocation]()
    
    var bkColor = UIColor.clearColor()
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLabel(totalTime: totalTime, distance: distance)
        setupGradientView()
        setupNavigationBar()
        setupButton()
        setupMap(location)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        TrackingManager.sharedManager.createTrackingScreenView("view_in_record_result")
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        view.backgroundColor = bkColor
    }
    
    func setupNavigationBar(selectedMode:Mode){
        
        switch selectedMode {
        case .closeMode:
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Close", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(self.clickedClose))
        case .backMode:
            self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        }
    }
    
    func clickedClose(){
        TrackingManager.sharedManager.createTrackingEvent("record_result", action: "select_close_in_record_result")
        
        self.delegate?.showHomaPages()
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    //
    //MARK: - Segue for MapViewController
    private var mapViewController: MapViewController!
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let mapView = segue.destinationViewController as? MapViewController where segue.identifier == "EmbedSegue"{
            self.mapViewController = mapView
        }
    }
    
}

//MARK: - Setup UI
extension StatisticViewController{
    
    func setupLabel(totalTime totalTime: Int, distance: Double){
        
        print("distance:\(distance), totalTime:\(totalTime)")
        
        let fractions = totalTime % 100
        let seconds = (totalTime / 100) % 60
        let minutes = (totalTime / 6000) % 60
        let hours = totalTime / 360000
        
        let strHours = String(format: "%02d", hours)
        let strMinutes = String(format: "%02d", minutes)
        let strSeconds = String(format: "%02d", seconds)
        let strFraction = String(format: "%02d", fractions)
        
        recordTimeLabel.text = "\(strHours):\(strMinutes):\(strSeconds).\(strFraction)"
        recordTimeLabel.textColor = UIColor.mrWhiteColor()
        recordTimeLabel.font = UIFont.mrRobotoMonoLightFon(30)
        
        distanceLabel.text = String(format: "%.2f m", distance)
        
        let totalTimeDouble = Double(totalTime)
        let averageSpeed = (distance/1000) / (totalTimeDouble/360000)
        avgSpeedLabel.text = String(format: "%.2f km / h", averageSpeed)
        
        let kCalBurned = calorieCalculator.kiloCalorieBurned(.Bike, speed: averageSpeed, weight: 50.0, time: totalTimeDouble/360000)
        caloriesLabel.text = String(format: "%.2f kcal", kCalBurned)
        
        
    }
    
    func setupMap(location: [CLLocation]){
        print("Location: \(location.count)")
        mapViewController.setPolyLineRegion(location)
        
    }
    
    func setupButton(){
        
        fbImage.image?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        fbImage.tintColor = UIColor.whiteColor()
        fbButton.layer.borderWidth = 2.0
        fbButton.layer.borderColor = UIColor.whiteColor().CGColor
        fbButton.layer.cornerRadius = 10.0
        fbButton.layer.masksToBounds = true
        fbButton.titleLabel?.tintColor = UIColor.whiteColor()
        fbImage.userInteractionEnabled = false
    }
    
    func setupGradientView(){
        
        gradientLayer.frame = self.view.bounds
        
        let color1 = UIColor.mrBlack60Color().CGColor as CGColorRef
        let color2 = UIColor.mrBlack40Color().CGColor as CGColorRef
        
        gradientLayer.colors = [color1, color2]
        gradientLayer.locations = [0.0, 0.5]
        self.gradient.layer.addSublayer(gradientLayer)
    }
    
    func setupNavigationBar(){
        
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        self.navigationController?.navigationBar.barTintColor = UIColor.mrLightblueColor()
        self.navigationController?.navigationBar.translucent = false
        
        setupDate()
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


//MARK: - FB Share Button
extension StatisticViewController{

    @IBAction func faShareButton(sender: AnyObject) {
        
        guard let navHeight = self.navigationController?.navigationBar.frame.height else{ return }
        let screenshotSize = CGSize(width: view.bounds.width , height: containerView.frame.origin.y + containerView.frame.height + 10)
        UIGraphicsBeginImageContext(screenshotSize)
        self.view.drawViewHierarchyInRect(CGRectMake(0,-navHeight,view.frame.size.width,view.frame.size.height), afterScreenUpdates: true)
        self.view.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let screenShot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let facebookSharingController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
        facebookSharingController.addImage(screenShot)
        self.presentViewController(facebookSharingController, animated: true, completion: nil)
    }

}



