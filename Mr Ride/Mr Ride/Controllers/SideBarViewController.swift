//
//  SideBarViewController.swift
//  
//
//  Created by Sarah on 5/23/16.
//
//

import UIKit

class SideBarViewController: UIViewController,UITableViewDelegate {

    private var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
//        setTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setTableView(){
//        tableView = UITableView(frame: CGRectMake(100, 0, Common.screenWidth * 0.7, view.frame.height), style: UITableViewStyle.Plain)
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
//        view.addSubview(tableView)
//        self.tableView.tableFooterView = UIView()
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
    
    func setupNavigation(){
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
