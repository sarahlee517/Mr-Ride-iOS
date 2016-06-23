//
//  CalorieCalulator.swift
//  Mr Ride
//
//  Created by Sarah on 5/31/16.
//  Copyright © 2016 AppWorks School Sarah Lee. All rights reserved.
//

import Foundation

class CalorieCalculator {
    
    private var kCalPerKm_Hour : Dictionary <Exercise,Double> = [
        .Bike : 0.4
    ]
    
    enum Exercise {
        case Bike
    }
    
    // unit
    // speed : km/h
    // weight: kg
    // time: hr
    // return : kcal
    func kiloCalorieBurned(exerciseType: Exercise, speed: Double, weight: Double, time:Double) -> Double{
        if let kCalUnit = kCalPerKm_Hour[exerciseType]{
            return speed * weight * time * kCalUnit
        }
        else{
            return 0.0
        }
   
    }
}