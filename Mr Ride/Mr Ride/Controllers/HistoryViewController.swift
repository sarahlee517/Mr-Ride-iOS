//
//  HistoryViewController.swift
//  Mr Ride
//
//  Created by Sarah on 5/23/16.
//  Copyright © 2016 AppWorks School Sarah Lee. All rights reserved.
//

import UIKit
import CoreData
import MMDrawerController

class HistoryViewController: UIViewController, NSFetchedResultsControllerDelegate, UITableViewDelegate, UITableViewDataSource {
    let gradientLayer = CAGradientLayer()
    
    @IBOutlet weak var chart: UIView!
    @IBOutlet weak var gradientView: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    let moc = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        let nib = UINib(nibName: "HistoryTableViewCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "HistoryTableViewCell")
        
        setupNavigationBar()
        setupGradientView()
        setupTableView()
        
        do {
            try self.fetchedResultsController.performFetch()
        } catch {
            let fetchError = error as NSError
            print("\(fetchError), \(fetchError.userInfo)")
        }
    }
    
    

    
    // MARK: -
    // MARK: FetchedResultsController
    lazy var fetchedResultsController: NSFetchedResultsController = {
        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest(entityName: "RideHistory")

        // Add Sort Descriptors
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        print("fetchRequest:\(fetchRequest)")
        
        // Initialize Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: self.moc,
            sectionNameKeyPath: "date",
            cacheName: nil
        )
        
        // Configure Fetched Results Controller
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
    // MARK: Fetched Results Controller Delegate Methods
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
extension HistoryViewController{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if let sections = fetchedResultsController.sections where sections.count > 0 {
            print(sections[section].numberOfObjects)
            return sections[section].numberOfObjects
        }else{
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = UINib(nibName: "HistoryTableViewCell", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! HistoryTableViewCell
        
        configureCell(cell, atIndexPath: indexPath)
        return cell
    }
    
    func configureCell(cell: HistoryTableViewCell, atIndexPath indexPath: NSIndexPath) {
        
        print("configureCell")
        let records = fetchedResultsController.objectAtIndexPath(indexPath)
        
        if let distance = records.valueForKey("distance") as? Double,
            let totalTime = records.valueForKey("tatalTime") as? Int{

            setupTimeLabel(cell, totalTime: totalTime)
            
            let distanceKm = distance / 1000
            cell.distanceLabel.text = String(format: "%.2f km", distanceKm)
            
        }
    }

    

    
//    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//       
//    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let statisticViewController = self.storyboard!.instantiateViewControllerWithIdentifier("StatisticViewController") as! StatisticViewController
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
    
//    func showProducts() {
//        print(1)
//        let request = NSFetchRequest(entityName: "RideHistory")
//        do {
//            let results = try moc.executeFetchRequest(request) as! [RideHistory]
//            for result in results {
//                print("distance: \(result.distance!), tatalTime: \(result.tatalTime)")
//            }
//        }catch{
//            fatalError("Failed to fetch data: \(error)")
//        }
//    }
}
