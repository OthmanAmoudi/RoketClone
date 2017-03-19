//
//  HealthKitManagerClass.swift
//  RoketClone
//
//  Created by Othman Mashaab on 19/03/2017.
//  Copyright © 2017 Othman Mashaab. All rights reserved.
//


import Foundation
import HealthKit

class HealthKitManager {
    let executeQuery = HKHealthStore()
    
    init()
    {
        checkAuthorization()
    }
    
    func checkAuthorization() -> Bool
    {
        // Default to assuming that we're authorized
        var isEnabled = true
        
        // Do we have access to HealthKit on this device?
        if HKHealthStore.isHealthDataAvailable()
        {
            // We have to request each data type explicitly
            let steps = NSSet(object: HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!)
            
            // Now we can request authorization for step count data
            executeQuery.requestAuthorization(toShare: nil, read: steps as? Set<HKObjectType>) { (success, error) -> Void in
                isEnabled = success
            }
        }
        else
        {
            isEnabled = false
        }
        
        return isEnabled
    }
    
    func retrieveStepCount(completion: @escaping (_ stepRetrieved: Double) -> Void) {
        
        //   Define the Step Quantity Type
        let stepsCount = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)
        
        //   Get the start of the day
        let date = NSDate()
        let cal = Calendar(identifier: Calendar.Identifier.gregorian)
        let newDate = cal.startOfDay(for: date as Date)
        
        //  Set the Predicates & Interval
        let predicate = HKQuery.predicateForSamples(withStart: newDate as Date, end: NSDate() as Date, options: .strictStartDate)
        let interval: NSDateComponents = NSDateComponents()
        interval.day = 1
        
        //  Perform the Query
        let query = HKStatisticsCollectionQuery(quantityType: stepsCount!, quantitySamplePredicate: predicate, options: [.cumulativeSum], anchorDate: newDate as Date, intervalComponents:interval as DateComponents)
        
        query.initialResultsHandler = { query, results, error in
            
            if error != nil {
                
                //  Something went Wrong
                return
            }
            
            
        }
        
        executeQuery.execute(query)
        
        
        
    }

}
