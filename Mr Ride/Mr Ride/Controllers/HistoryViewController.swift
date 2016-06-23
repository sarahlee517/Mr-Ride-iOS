//
//  HistoryViewController.swift
//  Mr Ride
//
//  Created by Sarah on 5/23/16.
//  Copyright © 2016 AppWorks School Sarah Lee. All rights reserved.
//

import UIKit
import CoreData
import MapKit
import MMDrawerController
import Charts




class HistoryViewController: UIViewController {
    let gradientLayer = CAGradientLayer()
    
    @IBOutlet weak var lineChart: LineChartView!
    @IBOutlet weak var gradientView: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    let moc = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    let ride = [RideData]()
    var myCoordinate = [MyLocation]()

    var distanceForChart = [Double]()
    var dateForChart = [String]()
    
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        RideManager.sharedManager.getDataFromCoreData()
        
        tableView.dataSource = self
        tableView.delegate = self
        lineChart.delegate = self
        
        
        let nib = UINib(nibName: "HistoryTableViewCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "HistoryTableViewCell")
        
        let headerNib = UINib(nibName: "HistoryTableHeader", bundle: nil)
        tableView.registerNib(headerNib, forHeaderFooterViewReuseIdentifier: "HistoryTableHeader")
        
        setupNavigationBar()
        setupGradientView()
        setupTableView()
        
        do {
            try self.fetchedResultsController.performFetch()
        } catch {
            let fetchError = error as NSError
            print("\(fetchError), \(fetchError.userInfo)")
        }
        fetchDataForChart()
    }
    
    //
    // MARK: - FetchedResultsController
    lazy var fetchedResultsController: NSFetchedResultsController = {
        
        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest(entityName: "RideHistory")
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        
        
        // Initialize Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: self.moc,
            sectionNameKeyPath: "getMonth",
            cacheName: nil
        )
        
        // Configure Fetched Results Controller
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    

}

// MARK: Fetched Results Controller Delegate Methods
extension HistoryViewController: NSFetchedResultsControllerDelegate{

    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch (type) {
        case .Insert:
            if let indexPath = newIndexPath {
                tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }
        default: break
        }
    }
    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        switch type {
        case .Insert:
            tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
        default: break
        }
    }
}


//MARK: - Implement TableView
extension HistoryViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if let sections = fetchedResultsController.sections where sections.count > 0 {
            return sections[section].numberOfObjects
        }else{
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = UINib(nibName: "HistoryTableViewCell", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! HistoryTableViewCell
        
        cell.selectionStyle = .None
        configureCell(cell, atIndexPath: indexPath)
        return cell
    }
    
    func configureCell(cell: HistoryTableViewCell, atIndexPath indexPath: NSIndexPath) {
        let records = fetchedResultsController.objectAtIndexPath(indexPath) as! RideHistory
        
        if let distance = records.distance?.doubleValue,
            let totalTime = records.totalTime?.intValue,
            let date = records.date{
            
            setupDataLabel(cell, date: date)
            setupTimeLabel(cell, totalTime: Int(totalTime))
            setupDistanceLabel(cell, distance: distance)
        }
    }
    
    
    func setupDistanceLabel(cell: HistoryTableViewCell, distance: Double){
        let distanceKm = distance / 1000
        cell.distanceLabel.text = String(format: "%.2f km", distanceKm)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let statisticViewController = self.storyboard!.instantiateViewControllerWithIdentifier("StatisticViewController") as! StatisticViewController
        
        let records = fetchedResultsController.objectAtIndexPath(indexPath) as! RideHistory
        
        if let distance = records.distance?.doubleValue,
            let totalTime = records.totalTime?.intValue,
            let date = records.date {
                statisticViewController.distance = distance
                statisticViewController.totalTime = Int(totalTime)
                statisticViewController.location = getLocations(date)
        }
        
        statisticViewController.setupNavigationBar(.backMode)
        
        self.navigationController?.pushViewController(statisticViewController, animated: true)
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if let sections = fetchedResultsController.sections {
            return sections.count
        }
        
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return CGFloat(60)
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let currSection = fetchedResultsController.sections?[section]
        let title = currSection!.name
        
        // Dequeue with the reuse identifier
        let cell = self.tableView.dequeueReusableHeaderFooterViewWithIdentifier("HistoryTableHeader")
        let header = cell as! HistoryTableHeader
        
        header.monthLabel.text = title
        header.backgrandView.backgroundColor = UIColor.clearColor()
        
        return cell
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRectMake(0, 0, tableView.frame.size.width, 10))
        footerView.backgroundColor = UIColor.clearColor()
        
        return footerView
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10.0
    }
}


//MARK: - Chart View
extension HistoryViewController: ChartViewDelegate{
    
    func fetchDataForChart(){
        for section in 0..<tableView.numberOfSections {
            for row in 0..<tableView.numberOfRowsInSection(section) {
                let indexPath = NSIndexPath(forRow: row, inSection: section)
                
                let records = fetchedResultsController.objectAtIndexPath(indexPath) as! RideHistory
                
                guard
                    let date = records.date,
                    let distance = records.distance?.doubleValue
                    
                    else {
                        print("\(self.dynamicType) Fetch Data For Charts failed.")
                        continue
                }
                
                dateForChart.append(dateString(date))
                distanceForChart.append(distance)
            }
        }
        dateForChart = dateForChart.reverse()
        distanceForChart = distanceForChart.reverse()
        RideManager.sharedManager.dateForChart = dateForChart
        RideManager.sharedManager.distanceForChart = distanceForChart
        setChart(dateForChart, values: distanceForChart)
    }
    

    func setChart(dataPoints: [String], values: [Double]) {
        
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        
        let chartDataSet = LineChartDataSet(yVals: dataEntries, label: "Units Sold")
        let chartData = LineChartData(xVals: dataPoints, dataSet: chartDataSet)
        lineChart.data = chartData
        
        
        //fill gradient for the curve
        let gradientColors = [UIColor.mrBrightSkyBlueColor().CGColor, UIColor.mrTurquoiseBlueColor().CGColor]
        let colorLocations:[CGFloat] = [0.0, 0.3]
        let gradient = CGGradientCreateWithColors(CGColorSpaceCreateDeviceRGB(), gradientColors, colorLocations) // Gradient Object
        chartDataSet.fill = ChartFill.fillWithLinearGradient(gradient!, angle: 90.0)
        chartDataSet.drawFilledEnabled = true
        chartDataSet.lineWidth = 0.0
        
        chartDataSet.drawCirclesEnabled = false //remove the point circle
        
        chartDataSet.mode = .CubicBezier  //make the line to be curve
        chartData.setDrawValues(false)      //remove value label on each point
        
        //make chartview not scalable and remove the interaction line
        lineChart.setScaleEnabled(false)
        lineChart.userInteractionEnabled = false
        
        //set display attribute
        lineChart.xAxis.drawAxisLineEnabled = false
        lineChart.xAxis.drawGridLinesEnabled = false
        
        lineChart.xAxis.labelPosition = .Bottom
        lineChart.xAxis.labelTextColor = UIColor.whiteColor()
        
        lineChart.leftAxis.drawAxisLineEnabled = false
        lineChart.rightAxis.drawAxisLineEnabled = false
        lineChart.leftAxis.drawLabelsEnabled = false
        lineChart.rightAxis.drawLabelsEnabled = false
        
        //ony display leftAxis gridline
        lineChart.rightAxis.drawGridLinesEnabled = false
        lineChart.leftAxis.gridColor = UIColor.whiteColor()
        
        
        lineChart.legend.enabled = false  // remove legend icon
        lineChart.descriptionText = ""   // clear description
        
    }
    
    func dateString(date: NSDate) -> String{
        
        let recordDate = date
        let dateFormatter = NSDateFormatter()
        
        dateFormatter.dateFormat = "MM/dd"
        
        let title = dateFormatter.stringFromDate(recordDate)
        return title
    }


}







//MARK: - Setup UI
extension HistoryViewController{
    
    func setupTableView(){
        tableView.backgroundColor = UIColor.clearColor()
        tableView.separatorColor = UIColor.clearColor()
    }
    
    func setupGradientView(){
        gradientLayer.frame = self.view.bounds
        
        let color1 = UIColor.mrLightblueColor().CGColor as CGColorRef
        let color2 = UIColor.mrPineGreen50Color().CGColor as CGColorRef
        
        gradientLayer.colors = [color1, color2]
        gradientLayer.locations = [0.0, 0.5]
        self.gradientView.layer.addSublayer(gradientLayer)
    }
    
    func setupNavigationBar(){
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon-menu.png"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(self.doneSlide))
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.topItem?.title = "History"
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = true
    }
    
    func doneSlide(){
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.homePageContainer.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
        
    }
    
    func setupTimeLabel(cell:HistoryTableViewCell, totalTime: Int){
        let seconds = (totalTime / 100) % 60
        let minutes = (totalTime / 6000) % 60
        let hours = totalTime / 360000
        
        let strHours = String(format: "%02d", hours)
        let strMinutes = String(format: "%02d", minutes)
        let strSeconds = String(format: "%02d", seconds)
        
        cell.totalTimeLabel.text = "\(strHours):\(strMinutes):\(strSeconds)"
        
    }
    
    func setupDataLabel(cell: HistoryTableViewCell, date: NSDate){
        let recordDate = date
        let calendar = NSCalendar(identifier: NSCalendarIdentifierGregorian)
        let components = calendar?.components([.Month, .Day], fromDate: recordDate)
        
        let dayText = components?.day
        let dateText = String(format: "%02dth", dayText!)
        
        let font:UIFont? = UIFont.mrRobotoMonoLightFon(24)
        let fontSuper:UIFont? = UIFont.mrRobotoMonoLightFon(12)
        let attString:NSMutableAttributedString = NSMutableAttributedString(
            string: dateText,
            attributes: [NSFontAttributeName:font!]
        )
        attString.setAttributes(
            [NSFontAttributeName:fontSuper!,NSBaselineOffsetAttributeName:0],
            range: NSRange(location:2,length:2))
        cell.dateLabel.attributedText = attString
    }
    
    func getLocations(date: NSDate)->[CLLocation]{
        
        let request = NSFetchRequest(entityName: "RideHistory")
        request.predicate = NSPredicate(format: "date = %@", date)
        var newLocations = [CLLocation]()
        do {
            let results = try moc.executeFetchRequest(request) as! [RideHistory]
            
            for result in results {
                
                if let locations = result.locations?.array as? [Locations]{
                    
                    for locaton in locations{
                        if let  _longtitude = locaton.longtitude?.doubleValue,
                            _latitude = locaton.latitude?.doubleValue{
                            
                            let newLocation = CLLocation(latitude: _latitude, longitude: _longtitude)
                            newLocations.append(newLocation)
                            
                        }
                    }
                }
            }
        }catch{
            fatalError("Failed to fetch data: \(error)")
        }
        return newLocations
    }
    
    
}
