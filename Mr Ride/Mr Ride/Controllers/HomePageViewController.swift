//
//  HomePageViewController.swift
//  Mr Ride
//
//  Created by Sarah on 5/23/16.
//  Copyright © 2016 AppWorks School Sarah Lee. All rights reserved.
//

import UIKit
import MMDrawerController
import Charts
import CoreData

struct Common {
    static let screenWidth = UIScreen.mainScreen().bounds.maxX
}


class HomePageViewController: UIViewController, ChartViewDelegate {
    @IBOutlet weak var letsRideLabel: UILabel!
    @IBOutlet weak var letsRideButton: UIButton!
    @IBOutlet weak var lineChartView: LineChartView!
    
    @IBAction func sideBarButtonDidClicked(sender: AnyObject) {
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.homePageContainer?.toggleDrawerSide(.Left, animated: true, completion: nil)
        
        GAManager.sharedManager.addEvent("Home", action: "select_menu_in_home")
        
    }
    
    @IBAction func letsRideButtonDidClicked(sender: AnyObject) {
        hideInformationLabels()
        let trackingViewController = self.storyboard!.instantiateViewControllerWithIdentifier("TrackingViewController") as! TrackingViewController
        let trackingNavController = UINavigationController.init(rootViewController: trackingViewController)
        trackingViewController.delegate = self
        trackingViewController.navigationController?.modalPresentationStyle = .OverCurrentContext
        self.navigationController?.presentViewController(trackingNavController, animated: true, completion: nil)
        
        
        // [Google Analysis]
        GAManager.sharedManager.addEvent("Home", action: "select_ride_in_home")
        
    }
    
    let moc = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var distanceForChart = [Double]()
    var dateForChart = [String]()
}




//MARK: - View Lifecycle
extension HomePageViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mm_drawerController.showsShadow = false
        lineChartView.delegate = self
        setupNavigationBar()
        setupButton()
        getDataFromCoreData()
        setChart(dateForChart, values: distanceForChart)
    
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    
        GAManager.sharedManager.createScreenView("view_in_home")
    }
}



//MARK: - LineChart View
extension HomePageViewController{
    func getDataFromCoreData() {
        
        let request = NSFetchRequest(entityName: "RideHistory")
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        do {
            let results = try moc.executeFetchRequest(request) as! [RideHistory]
            for result in results {
                
                if let distance = result.distance as? Double,
                    let date = result.date{
                    distanceForChart.append(distance)
                    dateForChart.append(dateString(date))
                }
            }
        }catch{
            fatalError("Failed to fetch data: \(error)")
        }
        
        distanceForChart = distanceForChart.reverse()
        dateForChart = dateForChart.reverse()
    }
    
    func dateString(date: NSDate) -> String{
        
        let recordDate = date
        let dateFormatter = NSDateFormatter()
        
        dateFormatter.dateFormat = "MM/dd"
        
        let title = dateFormatter.stringFromDate(recordDate)
        return title
    }
    
    func setChart(dataPoints: [String], values: [Double]) {
        
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = LineChartDataSet(yVals: dataEntries, label: "Units Sold")
        let chartData = LineChartData(xVals: dataPoints, dataSet: chartDataSet)
        lineChartView.data = chartData
        
        
        //fill gradient for the curve
        let gradientColors = [ UIColor.mrRobinsEggBlue0Color().CGColor, UIColor.mrWaterBlueColor().CGColor] // Colors of the gradient
        let colorLocations:[CGFloat] = [0.0, 0.35] // Positioning of the gradient
        let gradient = CGGradientCreateWithColors(CGColorSpaceCreateDeviceRGB(), gradientColors, colorLocations) // Gradient Object
        chartDataSet.fill = ChartFill.fillWithLinearGradient(gradient!, angle: 90.0)
        chartDataSet.drawFilledEnabled = true
        chartDataSet.lineWidth = 0.0
        
        
        chartDataSet.drawCirclesEnabled = false //remove the point circle
        chartDataSet.mode = .CubicBezier //make the line to be curve
        chartData.setDrawValues(false)        //remove value label on each point
        
        //make chartview not scalable and remove the interaction line
        lineChartView.setScaleEnabled(false)
        lineChartView.userInteractionEnabled = false
        
        //set display attribute
        lineChartView.xAxis.drawAxisLineEnabled = false
        lineChartView.xAxis.drawGridLinesEnabled = false
        
        //display no labels
        lineChartView.xAxis.drawLabelsEnabled = false
        
        
        lineChartView.leftAxis.drawAxisLineEnabled = false
        lineChartView.rightAxis.drawAxisLineEnabled = false
        lineChartView.leftAxis.drawLabelsEnabled = false
        lineChartView.rightAxis.drawLabelsEnabled = false
        
        //display no gridlines
        lineChartView.rightAxis.drawGridLinesEnabled = false
        lineChartView.leftAxis.drawGridLinesEnabled = false
        
        
        lineChartView.legend.enabled = false  // remove legend icon (Lower left corner)
        lineChartView.descriptionText = ""   // clear description
        
    }
}



//MARK: - Setup UI
extension HomePageViewController{
    
    func setupNavigationBar(){
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = true
        
        let logo = UIImage(named: "icon-bike.png")?.imageWithRenderingMode(.AlwaysTemplate)
        let imageView = UIImageView(image:logo)
        imageView.tintColor = UIColor.mrWhiteColor()
        self.navigationItem.titleView = imageView
        
    }
    
    func setupButton(){
        letsRideButton.layer.cornerRadius = 30
        letsRideLabel.text = "Let's Ride"
        letsRideLabel.font = UIFont.mrSFUITextMediumFont(30)
        letsRideLabel.textColor = UIColor.mrLightblueColor()
    }
    
    func hideInformationLabels(){
        for subview in view.subviews where subview is UILabel{
            subview.hidden = true
        }
        letsRideButton.hidden = true
    }
}



//MARK: - Implement DismissDelegate Function
extension HomePageViewController: DismissDelegate{
    func showHomaPages(){
        
        distanceForChart.removeAll()
        dateForChart.removeAll()
        getDataFromCoreData()
        setChart(dateForChart, values: distanceForChart)
        for subview in view.subviews where subview is UILabel{
            subview.hidden = false
        }
        letsRideButton.hidden = false
    }
}
