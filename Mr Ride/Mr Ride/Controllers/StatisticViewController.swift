//
//  StatisticViewController.swift
//  Mr Ride
//
//  Created by Sarah on 5/25/16.
//  Copyright © 2016 AppWorks School Sarah Lee. All rights reserved.
//

import UIKit
enum Mode{
    case closeMode
    case backMode
}

class StatisticViewController: UIViewController {


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
