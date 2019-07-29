//
//  ParametersDefaults.swift
//  Orange Baah Box
//
//  Copyright (C) 2017 – 2019 Orange SA
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program. If not, see <http://www.gnu.org/licenses/>.
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
