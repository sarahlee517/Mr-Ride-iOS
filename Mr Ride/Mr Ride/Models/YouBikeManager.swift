//
//  YouBikeManager.swift
//  Mr Ride
//
//  Created by Sarah on 6/27/16.
//  Copyright © 2016 AppWorks School Sarah Lee. All rights reserved.
//

import CoreLocation
import SwiftyJSON
import Alamofire

class YouBikeManager{

    static let sharedManager = YouBikeManager()
    
    func getStation(completion: ([YouBikeModel]) -> Void){

        let URL = "http://data.taipei/youbike"
        
        Alamofire.request(.GET, URL, encoding: .JSON).validate().responseJSON{
            response in
            
            guard let data = response.data else {
                print("fetch public toilet failed : \n \(response.data.debugDescription)")
                return
            }
            
            let json = JSON(data: data)
            
            
            var stations: [YouBikeModel] = []
            
            for (_,data) in json["retVal"]{
                do{
                    let youbike = try YouBikeManagerHelper().parse(json: data)
                    stations.append(youbike)
                }
                catch{
                    print(error)
                }
                
            }
//            
//            print(stations)
            dispatch_async(dispatch_get_main_queue()) {
                completion(stations)
            }
            
        }
        
        
        
    }

}
