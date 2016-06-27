//
//  PublicToiletManager.swift
//  Mr Ride
//
//  Created by Sarah on 6/22/16.
//  Copyright © 2016 AppWorks School Sarah Lee. All rights reserved.
//


import Alamofire
import SwiftyJSON

class PublicToiletManager{

    static let sharedManager = PublicToiletManager()
    
    var publicToilets = [PublicToiletModel]()
    
    func getPublicToilet(completion: ([PublicToiletModel]) -> Void ){
        
        let URL = "http://data.taipei/opendata/datalist/apiAccess?scope=resourceAquire&rid=008ed7cf-2340-4bc4-89b0-e258a5573be2"
        
        if publicToilets.count > 0 {
            completion(self.publicToilets)
            return
        }
        
        Alamofire.request(.GET, URL, encoding: .JSON).validate().responseData{
            response in
            
            guard let data = response.data else {
                print("fetch public toilet failed : \n \(response.data.debugDescription)")
                return
            }
            
            let json = JSON(data: data)
            
            
            for (_,data) in json["result"]["results"]{
                do{
                    let publicToilet = try PublicToiletModelHelper().parsePublicToilet(json: data)
                    
                    self.publicToilets.append(publicToilet)
                }
                catch{
                    print(error)
                }
                
            }
            dispatch_async(dispatch_get_main_queue()) {
                completion(self.publicToilets)
            }

        }
        

       
    }
}