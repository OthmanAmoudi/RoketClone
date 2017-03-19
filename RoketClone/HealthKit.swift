//
//  HealthKit.swift
//  RoketClone
//
//  Created by Othman Mashaab on 20/03/2017.
//  Copyright © 2017 Othman Mashaab. All rights reserved.
//
import HealthKitUI
import Foundation
import HealthKit
import UIKit
import CoreData

class HealthKit
{
    let storage = HKHealthStore()
    
    init()
    {
        checkAuthorization()
    }
    
    func checkAuthorization() -> Bool {
        // Default to assuming that we're authorized
        var isEnabled = true
        
        // Do we have access to HealthKit on this device?
        if HKHealthStore.isHealthDataAvailable()
        {
            // We have to request each data type explicitly
            let steps = NSSet(object: HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount) ?? <#default value#>)
            
            // Now we can request authorization for step count data
            storage.requestAuthorization(toShare: nil, read: steps as? Set<HKObjectType>) { (success, error) -> Void in
                isEnabled = success
            }
        }
        else
        {
            isEnabled = false
        }
        
        return isEnabled
    }
    
   /* func recentSteps(completion: @escaping (Double, NSError?) -> () ) {
        // The type of data we are requesting (this is redundant and could probably be an enumeration
        let type = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)
        
        // Our search predicate which will fetch data from now until a day ago
        // (Note, 1.day comes from an extension
        // You'll want to change that to your own NSDate
       // let predicate = HKQuery.predicateForSamplesWithStartDate(NSDate() as Date - 1, endDate: NSDate(), options: .None)
        
        // The actual HealthKit Query which will fetch all of the steps and sub them up for us.
      //  let query = HKSampleQuery(sampleType: type, predicate: predicate, limit: 0, sortDescriptors: nil) { query, results, error in
            var steps: Double = 0
            
          if results?.count > 0
            {
                for result in results as [HKQuantitySample]
                {
                    steps += result.quantity.doubleValueForUnit(HKUnit.countUnit())
                }
            }
            
            completion(steps, error)
        }
        
       storage.executeQuery(query)
    }
 
*/
}
