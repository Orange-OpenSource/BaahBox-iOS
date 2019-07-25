//
//  ParameterDataManager.swift
//  Orange Training Box
//
//  Copyright © 2018 Orange. All rights reserved.
//

import Foundation


class ParameterDataManager: Codable {
    
    static let sharedInstance = ParameterDataManager.unarchive() ?? ParameterDataManager()
    private init() {}
    
    enum SensitivitySelection: Int, Codable {
        case low = 0
        case average = 1
        case high = 2
    }
    
    enum VelocitySelection: Int, Codable {
        case slow = 0
        case average = 1
        case fast = 2
    }
    
    enum ShootingType: Int, Codable {
        case automatic = 0
        case manual = 1
    }
    
    enum ExplosionType: Int, Codable {
        case animatedCrash = 0
        case particles = 1
    }
    
    enum SensorType: Int, Codable {
        case muscles = 0
        case joystick = 1
        case buttons = 2
    }
    
    enum CodingKeys: String, CodingKey {
        case demoMode
        case muscle1IsON
        case muscle2IsON
        case sensitivity
        case threshold
        case sensorType
        
        // Sheep Game
        case numberOfFences
        case fenceVelocity
        
        // Space Battle game
        case asteriodVelocity
        case numberOfSpaceShips
        case explosionType
        
        // Taud game
        case numberOfFlies
        case flySteadyTime
        case shootingType
    }
    
    // General parameters
    var demoMode : Bool = false { didSet { self.archive() }}
    var muscle1IsON : Bool = true { didSet { self.archive() }}
    var muscle2IsON : Bool = false { didSet { self.archive() }}
    var sensitivity : SensitivitySelection = .low { didSet { self.archive() }}
    var threshold : Int = 250 { didSet { self.archive() }}
    var sensorType : SensorType = .joystick {
        didSet {
            self.archive()
            print("sensorType: \(sensorType)")
        }
    }

    // Sheep game
    var numberOfFences : Int = 1 { didSet { self.archive() }}
    var fenceVelocity : VelocitySelection = .slow { didSet { self.archive() }}
    
    // Space Battle game
    var asteriodVelocity : VelocitySelection = .slow { didSet { self.archive() }}
    var numberOfSpaceShips : Int = 5 { didSet { self.archive() }}
    var explosionType : ExplosionType = .animatedCrash { didSet { self.archive() }}

    // Taud game
    var numberOfFlies : Int = 5 { didSet { self.archive() }}
    var flySteadyTime : Int = 5 { didSet { self.archive() }}
    var shootingType : ShootingType = .automatic { didSet { self.archive() }}
}


extension ParameterDataManager {
    
    fileprivate static let archiveFileName = "ParameterDataManager.archive"
    
    // MARK: Archive/Unarchive
    static func unarchive() -> ParameterDataManager? {
        guard let data = NSKeyedUnarchiver.unarchiveObject(withFile: ParameterDataManager.archivePath(archiveFileName)) as? Data else {
            print("No data available")
            return nil
        }
        do {
            let manager = try PropertyListDecoder().decode(ParameterDataManager.self, from: data)
            print("Parameters successfuly loaded")
            return manager
        } catch {
            print("Unarchive Failed")
            return nil
        }
    }
    
    func archive() {
        NotificationCenter.default.post(name: Notification.Name(rawValue: L10n.Notif.Parameter.update), object: self, userInfo: nil)
        do {
            let data = try PropertyListEncoder().encode(ParameterDataManager.sharedInstance)
            let success = NSKeyedArchiver.archiveRootObject(data, toFile: ParameterDataManager.archivePath(ParameterDataManager.archiveFileName))
            print("Parameters (\(success ? "successfuly saved)" : "save failed")")
        } catch {
            print("Achive failed")
        }
    }
    
    static func archivePath(_ fileName:String) -> String {
        return NSTemporaryDirectory() + fileName
    }
}
