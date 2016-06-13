//
//  RideHistory.swift
//  Mr Ride
//
//  Created by Sarah on 6/2/16.
//  Copyright © 2016 AppWorks School Sarah Lee. All rights reserved.
//

import Foundation
import CoreData


class RideHistory: NSManagedObject {

// Insert code here to add functionality to your managed object subclass

}

extension RideHistory {
    
    @NSManaged var date: NSDate?
    @NSManaged var distance: NSNumber?
    @NSManaged var tatalTime: NSNumber?
    @NSManaged var weight: NSNumber?
    @NSManaged var locations: NSOrderedSet?
    
}

extension RideHistory{
    var getMonth:String{
        let recordDate = date
//        let calendar = NSCalendar(identifier: NSCalendarIdentifierGregorian)!
//        let components = calendar.components([.Month, .Day], fromDate: recordDate!)
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMM yyyy"
        
        let title = dateFormatter.stringFromDate(recordDate!)
        
        return title
    }
}
