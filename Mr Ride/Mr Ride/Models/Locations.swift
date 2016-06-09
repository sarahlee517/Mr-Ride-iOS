//
//  Locations.swift
//  Mr Ride
//
//  Created by Sarah on 6/2/16.
//  Copyright © 2016 AppWorks School Sarah Lee. All rights reserved.
//

import Foundation
import CoreData


class Locations: NSManagedObject {

// Insert code here to add functionality to your managed object subclass

}

extension Locations {
    
    @NSManaged var latitude: NSNumber?
    @NSManaged var longtitude: NSNumber?
    @NSManaged var timestamp: NSDate?
    @NSManaged var ride: RideHistory?
    
}

