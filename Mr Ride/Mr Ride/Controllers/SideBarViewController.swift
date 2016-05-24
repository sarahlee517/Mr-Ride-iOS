//
//  SideBarViewController.swift
//  
//
//  Created by Sarah on 5/23/16.
//
//

import UIKit
import MMDrawerController


class SideBarViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {

    private var tableView: UITableView!

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTableView()
        setupNavigationBar()
    
    }
    
    
    
    func setTableView(){
        tableView = UITableView(frame: CGRectMake(0, 40, Common.screenWidth * 0.7, view.frame.height), style: UITableViewStyle.Plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.backgroundColor = UIColor.clearColor()
        view.addSubview(tableView)
        
        self.tableView.tableFooterView = UIView()
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 50
    }
    

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let identifier = "cell"
        var cell = tableView.dequeueReusableCellWithIdentifier(identifier)
        
        
        if cell == nil {
            cell = UITableViewCell(style: .Value1, reuseIdentifier: identifier)
            cell?.accessoryType = UITableViewCellAccessoryType.None
            cell?.selectionStyle = .None
        }
        if indexPath.row == 0{
            
            cell?.backgroundColor = UIColor.clearColor()
            cell?.imageView!.image = UIImage(named: "circle.png")
//            cell?.imageView!.hidden = true
            cell?.textLabel?.text = "Home"
            cell?.textLabel?.textColor = UIColor.whiteColor()
            cell?.textLabel?.font = UIFont.mrSFUITextMediumFont(24)

        }
        else{
            cell?.backgroundColor = UIColor.clearColor()
            cell?.imageView!.image = UIImage(named: "circle.png")
            cell?.imageView!.hidden = true
            cell?.textLabel?.text = "History"
            cell?.textLabel?.textColor = UIColor.mrWhite50Color()
            cell?.textLabel?.font = UIFont.mrSFUITextMediumFont(24)
        }
        return cell!
    }
    
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {

        
        if let oldIndex = tableView.indexPathForSelectedRow {
            tableView.cellForRowAtIndexPath(oldIndex)?.imageView?.hidden = true
            tableView.cellForRowAtIndexPath(oldIndex)?.textLabel?.textColor = UIColor.mrWhite50Color()
        }
        

        tableView.cellForRowAtIndexPath(indexPath)?.imageView?.hidden = false
        tableView.cellForRowAtIndexPath(indexPath)?.textLabel?.textColor = UIColor.whiteColor()
        
        
        
        
        return indexPath
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
   
        switch(indexPath.row){
            
        case 0:
            
            let homePageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("HomePageViewController") as! HomePageViewController
            
            let homePageViewNavController = UINavigationController(rootViewController: homePageViewController)
            
            let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            
            appDelegate.homePageContainer.centerViewController = homePageViewNavController
            appDelegate.homePageContainer.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
            
            
        default:
            
            let historyViewController = self.storyboard?.instantiateViewControllerWithIdentifier("HistoryViewController") as! HistoryViewController
            
            let historyViewNavController = UINavigationController(rootViewController: historyViewController)
            
            let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            
            appDelegate.homePageContainer.centerViewController = historyViewNavController
            appDelegate.homePageContainer.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
        }
    }
    
    
    func setupNavigationBar(){
        
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = true
        
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
