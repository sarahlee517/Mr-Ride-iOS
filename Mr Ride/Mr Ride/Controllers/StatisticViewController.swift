//
//  StatisticViewController.swift
//  Mr Ride
//
//  Created by Sarah on 5/25/16.
//  Copyright © 2016 AppWorks School Sarah Lee. All rights reserved.
//

import UIKit
import CoreData

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
    let moc = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    let calorieCalculator = CalorieCalculator()



    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        getDataFromCoreData()
        setupGradientView()
        setupNavigationBar()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//MARK: - setup
extension StatisticViewController{
    
    func setupLabel(totalTime totalTime: Int, distance: Double){
        
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
    
    func getDataFromCoreData() {
        let request = NSFetchRequest(entityName: "RideHistory")
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        request.fetchLimit = 1
        do {
            let results = try moc.executeFetchRequest(request) as! [RideHistory]
            for result in results {
                
                if let distance = result.distance as? Double,
                    let totalTime = result.tatalTime as? Int{
                    setupLabel(totalTime: totalTime, distance: distance)
                    
                }
                
                
            }
        }catch{
            fatalError("Failed to fetch data: \(error)")
        }
    }
    
    
//    func showData(){
//        
//        let request = NSFetchRequest(entityName: "RideHistory")
//        do {
//            let results = try moc.executeFetchRequest(request) as! [RideHistory]
//            for result in results {
//                print(result.date)
//                print(result.distance)
//                print(result.locations)
//                print(result.tatalTime)
//            }
//        }catch{
//            fatalError("Failed to fetch data: \(error)")
//            
//        }
//    }

}



