//
//  Locations+CoreDataProperties.swift
//  Mr Ride
//
//  Created by Sarah on 6/2/16.
//  Copyright © 2016 AppWorks School Sarah Lee. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Locations {

    @NSManaged var latitude: NSNumber?
    @NSManaged var longtitude: NSNumber?
    @NSManaged var timestamp: NSDate?
    @NSManaged var ride: RideHistory?

}
