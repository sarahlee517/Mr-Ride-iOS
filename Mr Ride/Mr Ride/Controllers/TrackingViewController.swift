//
//  TrackingViewController.swift
//  Mr Ride
//
//  Created by Sarah on 5/24/16.
//  Copyright © 2016 AppWorks School Sarah Lee. All rights reserved.
//

import UIKit
//import MapKit

class TrackingViewController: UIViewController {
    @IBAction func recordButtonDidClicked(sender: AnyObject) {


        
        
    }
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var buttonRingView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupRecordButton()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func setupNavigationBar(){
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(self.clickedCancel))
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Finish", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(self.clickedFinish))
        
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        self.navigationController?.navigationBar.barTintColor = UIColor.mrLightblueColor()
        self.navigationController?.navigationBar.translucent = false
        
        
        //        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        //        self.navigationController?.navigationBar.shadowImage = UIImage()
//        self.navigationController?.navigationBar.translucent = true
    }
    
    func clickedCancel(){
        
        //navigationController?.popToRootViewControllerAnimated(true)
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func clickedFinish(){
        let statisticViewController = self.storyboard!.instantiateViewControllerWithIdentifier("StatisticViewController") as! StatisticViewController
        statisticViewController.setupNavigationBar(Mode.closeMode)
        self.navigationController?.pushViewController(statisticViewController, animated: true)
    }
    
    
    func setupRecordButton(){
        recordButton.layer.cornerRadius = recordButton.frame.width / 2
        buttonRingView.backgroundColor = UIColor.clearColor()
        buttonRingView.layer.cornerRadius = buttonRingView.frame.width / 2
        buttonRingView.layer.borderWidth = 4
        buttonRingView.layer.borderColor = UIColor.whiteColor().CGColor
        
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
