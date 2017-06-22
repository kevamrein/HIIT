//
//  CoreDataConstants.swift
//  HITT
//
//  Created by Kevin Amrein on 6/12/17.
//  Copyright © 2017 Kevin Amrein. All rights reserved.
//

import Foundation
import CoreData

class CoreDataConstants {
    static var managedObjectContext: NSManagedObjectContext!
    static var workoutToSave: Workouts? = nil
    static let burnoutTimeFormatter = DateFormatter()
    
    static let KILOGRAM: Int16 = 0
    static let POUND: Int16 = 1
    
    static let KILOGRAM_LABEL: String = "kg"
    static let POUND_LABEL: String = "lbs"
    
    static let DEFAULT_COUNTDOWN_TIMER: Int16 = 10
    static var settings: Settings? = nil
    
    static var maxWeightObject: MaxWeight? = nil
    
    static let isMetric: Bool = Locale.current.usesMetricSystem
    
    static let unitMass: UnitMass = Locale.current.usesMetricSystem ? UnitMass.kilograms : UnitMass.pounds
    
    static func getUnitMass(_ intValue: Int16) -> UnitMass {
        var returnUnit: UnitMass
        
        switch intValue {
        case KILOGRAM:
            returnUnit = UnitMass.kilograms
        case POUND:
            returnUnit = UnitMass.pounds
        default:
            returnUnit = UnitMass.pounds
        }
        
        return returnUnit
    }
    
    static func getUnitNumber(_ unit: UnitMass) -> Int16 {
        var returnUnit: Int16
        
        switch unit {
        case UnitMass.kilograms:
            returnUnit = KILOGRAM
        case UnitMass.pounds:
            returnUnit = POUND
        default:
            returnUnit = POUND
        }
        
        return returnUnit
    }
    
}
