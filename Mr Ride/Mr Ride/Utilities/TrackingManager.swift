//
//  GAManager.swift
//  Mr Ride
//
//  Created by Sarah on 6/29/16.
//  Copyright © 2016 AppWorks School Sarah Lee. All rights reserved.
//

import Foundation

class TrackingManager{

    static let sharedManager = TrackingManager()
    
    func addEvent(category: String, action: String){
    
        let tracker = GAI.sharedInstance().defaultTracker
        let eventTracker: NSObject = GAIDictionaryBuilder.createEventWithCategory(
            category,
            action: action,
            label: "",
            value: nil).build()
        tracker.send(eventTracker as! [NSObject : AnyObject])
        
    }
    
    func createScreenView(viewName: String){
        
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: viewName)
        
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])
    }
}