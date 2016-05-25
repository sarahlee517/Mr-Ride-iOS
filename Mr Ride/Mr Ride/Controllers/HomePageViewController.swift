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
    @IBOutlet weak var letsRideLabel: UILabel!
    @IBOutlet weak var letsRideButton: UIButton!

    @IBAction func sideBarButtonDidClicked(sender: AnyObject) {
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.homePageContainer?.toggleDrawerSide(.Left, animated: true, completion: nil)
        
    }
    
    @IBAction func letsRideButtonDidClicked(sender: AnyObject) {
        let trackingViewController = self.storyboard!.instantiateViewControllerWithIdentifier("TrackingViewController") as! TrackingViewController
        let trackingNavController = UINavigationController.init(rootViewController: trackingViewController)
        
        self.navigationController?.presentViewController(trackingNavController, animated: true, completion: nil)

    }
    
    //MARK: - ViewLife Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mm_drawerController.showsShadow = false
        
        setupNavigationBar()
        setupButton()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK- Setup Items
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
//        letsRideLabel.shadowColor = UIColor.redColor()
//        letsRideLabel.shadowOffset = CGSizeMake(0, -1.0)
        letsRideLabel.text = "Let's Ride"
        letsRideLabel.font = UIFont.mrSFUITextMediumFont(30)
        letsRideLabel.textColor = UIColor.mrLightblueColor()
    }
    
    


}
