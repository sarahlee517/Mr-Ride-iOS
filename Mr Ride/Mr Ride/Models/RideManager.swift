//
//  RunDataModel.swift
//  Mr Ride
//
//  Created by Sarah on 6/6/16.
//  Copyright © 2016 AppWorks School Sarah Lee. All rights reserved.
//

import Foundation
import MapKit
import CoreData

class MyLocation: CLLocation{
    let longtitude: Double = 0.0
    let latitude: Double = 0.0
}


struct RideData{
    var totalTime: Int = 0
    var distance: Double = 0.0
    var date = NSDate()
    var myLocations = [MyLocation]()
}




class RideManager{
    
    static let sharedManager = RideManager()
    
//    var myCoordinate = [MyLocation]()
    var historyData = [RideData]()
//    var fetchResultController
    let moc = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    //MARK: Get Data From Core Data
    func getDataFromCoreData() {
        
        let request = NSFetchRequest(entityName: "RideHistory")
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        do {
            let results = try moc.executeFetchRequest(request) as! [RideHistory]
            for result in results {
                
                
//                if let locations = result.locations!.array as? [Locations]{
//                    for locaton in locations{
//                        if let  _longtitude = locaton.longtitude?.doubleValue,
//                            _latitude = locaton.latitude?.doubleValue{
//                            
//                            myCoordinate.append(
//                                MyLocation(
//                                    latitude: _latitude,
//                                    longitude: _longtitude
//                                )
//                            )
//                        }
//                    }
//                }
                
                if let distance = result.distance as? Double,
                    let totalTime = result.tatalTime as? Int,
                    let date = result.date{
                    
                    RideManager.sharedManager.historyData.append(
                        RideData(
                            totalTime: totalTime,
                            distance: distance,
                            date: date,
                            myLocations: [MyLocation]()
                        )
                    )
                }
            }
        }catch{
            fatalError("Failed to fetch data: \(error)")
        }
        print("History Count:\(historyData.count)")
        print(historyData)
    }
}
