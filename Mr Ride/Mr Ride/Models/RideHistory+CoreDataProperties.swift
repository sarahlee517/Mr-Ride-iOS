//
//  RideHistory+CoreDataProperties.swift
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

extension RideHistory {

    @NSManaged var date: NSDate?
    @NSManaged var distance: NSNumber?
    @NSManaged var tatalTime: NSNumber?
    @NSManaged var weight: NSNumber?
    @NSManaged var locations: NSSet?

}
