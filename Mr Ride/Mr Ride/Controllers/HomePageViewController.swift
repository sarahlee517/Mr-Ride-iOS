//
//  HomePageViewController.swift
//  Mr Ride
//
//  Created by Sarah on 5/23/16.
//  Copyright © 2016 AppWorks School Sarah Lee. All rights reserved.
//

import UIKit
import MMDrawerController

struct Common {
    
    static let screenWidth = UIScreen.mainScreen().bounds.maxX
}


class HomePageViewController: UIViewController {

    @IBAction func sideBarButtonDidClicked(sender: AnyObject) {
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.homePageContainer?.toggleDrawerSide(.Left, animated: true, completion: nil)
        
    }
    @IBAction func letsRideButtonDidClicked(sender: AnyObject) {
        

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mm_drawerController.showsShadow = false
        
        setupNavigationBar()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
