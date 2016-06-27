//
//  YouBikeManagerHelper.swift
//  Mr Ride
//
//  Created by Sarah on 6/27/16.
//  Copyright © 2016 AppWorks School Sarah Lee. All rights reserved.
//

import CoreLocation
import SwiftyJSON

class YouBikeManagerHelper{

    struct JSONKey {
        
        static let District = "sarea"
        static let Latitude = "lat"
        static let Longitude = "lng"
        static let Name = "sna"
        static let Address = "ar"
        static let NumberOfRemainingBikes = "sbi"
    }
    
    enum JSONError: ErrorType { case MissingDistrict, MissingLatitude, MissingLongitude, MissingName, MissingAddress, MissingNumberOfRemainingBikes, InvalidNumberOfRemainingBikes }
    
    func parse(json json: JSON) throws -> YouBikeModel {
        
        guard let district = json[JSONKey.District].string else { throw JSONError.MissingDistrict }
        
        let numberFormatter = NSNumberFormatter()
        
        guard let latitudeString = json[JSONKey.Latitude].string else { throw JSONError.MissingLatitude }
        let latitude = numberFormatter.numberFromString(latitudeString) as? Double ?? 0.0
        
        guard let longitudeString = json[JSONKey.Longitude].string else { throw JSONError.MissingLongitude }
        let longitude = numberFormatter.numberFromString(longitudeString) as? Double ?? 0.0
        
        guard let name = json[JSONKey.Name].string else { throw JSONError.MissingName }
        guard let address = json[JSONKey.Address].string else { throw JSONError.MissingAddress }
        

        guard let numberOfRemainingBikesString = json[JSONKey.NumberOfRemainingBikes].string else { throw JSONError.MissingNumberOfRemainingBikes }
        
        guard let numberOfRemainingBikes = numberFormatter.numberFromString(numberOfRemainingBikesString) as? Int else { throw JSONError.InvalidNumberOfRemainingBikes }
        let stationNnumberOfRemainingBikes = numberOfRemainingBikes ?? 0
        
        let station = YouBikeModel(
            district: district,
            name: name,
            address: address,
            numberOfRemainingBikes: stationNnumberOfRemainingBikes,
            coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        )
        
        return station
    }
}
