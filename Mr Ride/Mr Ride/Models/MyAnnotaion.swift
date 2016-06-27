//
//  MyAnnotaion.swift
//  Mr Ride
//
//  Created by Sarah on 6/23/16.
//  Copyright © 2016 AppWorks School Sarah Lee. All rights reserved.
//

import Foundation
import MapKit

class MyAnnotaion: MKPointAnnotation{

    var type: String?
    var address: String?
    var category: String?
    
    init(type: String, address: String, category: String){
        self.type = type
        self.address = address
        self.category = category
    }
    
}