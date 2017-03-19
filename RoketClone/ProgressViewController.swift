//
//  ProgressViewController.swift
//  RoketClone
//
//  Created by Othman Mashaab on 19/03/2017.
//  Copyright © 2017 Othman Mashaab. All rights reserved.
//
import Foundation
import UIKit
import HealthKit

class ProgressViewController: UIViewController {

    @IBOutlet weak var stepsLabel: UILabel!
    
    let healthStore: HKHealthStore? = {
        if HKHealthStore.isHealthDataAvailable() {
            return HKHealthStore()
        } else {
            return nil
        }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
      

    
    }

}

    



