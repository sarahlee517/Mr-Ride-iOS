//
//  PublicToiletModelHelper.swift
//  Mr Ride
//
//  Created by Sarah on 6/22/16.
//  Copyright © 2016 AppWorks School Sarah Lee. All rights reserved.
//

import SwiftyJSON
import CoreLocation

struct PublicToiletModelHelper{
    struct JSONKey {
        static let Category = "類別"
        static let Longtitude = "經度"
        static let Latitude = "緯度"
        static let Name = "單位名稱"
        static let Address = "地址"
        
    }
    
    
    
    enum JSONError: ErrorType { case MissingDistrict, MissingLongitude,MissingLatitude, MissingName, MissingAddress }
    
    
    
    func parsePublicToilet(json json: JSON) throws -> PublicToiletModel{
        
        guard let category = json[JSONKey.Category].string else { throw JSONError.MissingDistrict }
        
        let numberFormatter = NSNumberFormatter()
        
        guard let latitudeString = json[JSONKey.Latitude].string else { throw JSONError.MissingLatitude }
        let latitude = numberFormatter.numberFromString(latitudeString) as? Double ?? 0.0
        
        guard let longitudeString = json[JSONKey.Longtitude].string else { throw JSONError.MissingLongitude }
        let longitude = numberFormatter.numberFromString(longitudeString) as? Double ?? 0.0
        
        guard let name = json[JSONKey.Name].string else { throw JSONError.MissingName }

        guard let address = json[JSONKey.Address].string else { throw JSONError.MissingAddress }
        
        let publicToilet = PublicToiletModel(
            Category: category,
            coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude),
            name: name,
            address: address
        )
        
        return publicToilet
    }
}

