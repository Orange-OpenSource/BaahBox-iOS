//
//  ParametersDefaults.swift
//  OrangeTrainingBox
//
//  Copyright © 2018 Orange. All rights reserved.
//

import UIKit

enum DefaultHardnessValue: Double {
    case low = 0.2
    case medium = 0.6
    case high = 1.0
}

protocol ParametersDefaultable {
    var hardnessCoeff : Double { get }
}

extension ParametersDefaultable {
    
    // The highest the sensitivity the lowest the hardness coefficient
    
    var hardnessCoeff: Double {
        get {
            switch ParameterDataManager.sharedInstance.sensitivity {
            case .low:
                return DefaultHardnessValue.high.rawValue
            case .average:
                return DefaultHardnessValue.medium.rawValue
            case .high:
                return DefaultHardnessValue.low.rawValue
            }
        }
    }
}
