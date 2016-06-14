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

enum Mode{
    case closeMode
    case backMode
}



class StatisticViewController: UIViewController {
    
    @IBOutlet weak var gradient: UIView!
    @IBOutlet weak var recordTimeLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var avgSpeedLabel: UILabel!
    @IBOutlet weak var caloriesLabel: UILabel!
    
    let gradientLayer = CAGradientLayer()
    var date = ""
    let calorieCalculator = CalorieCalculator()
    var totalTime = 0
    var distance = 0.0
    var location = [CLLocation]()
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        RideManager.sharedManager.getDataFromCoreData()
        setupLabel(totalTime: totalTime, distance: distance)
        setupGradientView()
        setupNavigationBar()
        setupMap(location)
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
        
        print("totalTime:\(totalTime), distance:\(distance)")
        
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
        mapViewController.setPolyLineRegion(location)
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



