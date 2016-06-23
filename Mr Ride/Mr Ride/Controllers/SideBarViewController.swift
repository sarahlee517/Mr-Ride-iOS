//
//  SideBarViewController.swift
//
//
//  Created by Sarah on 5/23/16.
//
//

import UIKit
import MMDrawerController


class SideBarViewController: UITableViewController {
    
    private var selectedRow: NSIndexPath = NSIndexPath(forRow: 1, inSection: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    func setTableView(){
        
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.backgroundColor = UIColor.mrDarkSlateBlueColor()
        
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        switch indexPath.row {
        case 0: return 100.0
        default: return 50.0
        }
        
    }
    
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let identifier = "cell"
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath)
        
        cell.selectionStyle = .None
        cell.backgroundColor = UIColor.clearColor()
        cell.imageView!.image = UIImage(named: "circle.png")
        cell.imageView!.hidden = true
        cell.textLabel?.textColor = UIColor.mrWhite50Color()
        cell.textLabel?.font = UIFont.mrSFUITextMediumFont(24)
        
        switch indexPath.row {
        case 0: break
            
        case 1: cell.textLabel?.text = "Home"
            
        case 2: cell.textLabel?.text = "History"
            
        default: cell.textLabel?.text = "Map"
            
        }
        
        if selectedRow != indexPath{
            cell.imageView?.hidden = true
            cell.textLabel?.textColor = UIColor.mrWhite50Color()
            
        }else if selectedRow.row != 0{
            cell.imageView?.hidden = false
            cell.textLabel?.textColor = UIColor.whiteColor()
            
        }
        
        return cell
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        selectedRow = indexPath
        
        switch(indexPath.row){
            
        case 0:
            break
            
        case 1:
            
            let homePageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("HomePageViewController") as! HomePageViewController
            
            let homePageViewNavController = UINavigationController(rootViewController: homePageViewController)
            
            let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            
            appDelegate.homePageContainer.centerViewController = homePageViewNavController
            appDelegate.homePageContainer.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
            
            
        case 2:
            
            let historyViewController = self.storyboard?.instantiateViewControllerWithIdentifier("HistoryViewController") as! HistoryViewController
            
            let historyViewNavController = UINavigationController(rootViewController: historyViewController)
            
            let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            
            appDelegate.homePageContainer.centerViewController = historyViewNavController
            appDelegate.homePageContainer.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
            
        default:
            let informationMapViewController = self.storyboard?.instantiateViewControllerWithIdentifier("InformationMapViewController") as! InformationMapViewController
            
            let informationMapNavController = UINavigationController(rootViewController: informationMapViewController)
            
            let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            
            appDelegate.homePageContainer.centerViewController = informationMapNavController
            appDelegate.homePageContainer.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
        }
        
        tableView.reloadData()
    }
    
    
}
