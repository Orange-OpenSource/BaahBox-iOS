//
//  SensorInputManager.swift
//  OrangeTrainingBox
//
//  Created by Frederique Pinson on 14/02/2019.
//  Copyright © 2019 Orange. All rights reserved.
//

import Foundation

class SensorInputManager {
    static let sharedInstance = SensorInputManager()
    private init() {}
    
    var musclesInput: (muscle1: Int, muscle2: Int) = (0,0)
    var joystickInput: (up: Bool, down: Bool, left: Bool, right: Bool) = (false, false, false, false)
    
    // Frame format:
    // C1|a1|C2|a2|JBin|90 = <muscle1, muscle2, Joystic=JBin, EndOfFrame>
    // Where:
    // muscle1 = C1x32+a1
    // muscle2 = C2x32+a2
    // joystic = right|left|down|up
    // EndOfFrame = 90 -> '\n'
    public func analyseCompressedRawInput(_ rawInput: [UInt8]) {
        
        print("inputData: \(rawInput)")
        guard rawInput.count == 5 else {
            print ("bad value")
            return
        }
        
        musclesInput.muscle1 = bytesToValue(coeff: rawInput[0], add: rawInput[1])
        musclesInput.muscle2 = bytesToValue(coeff: rawInput[2], add: rawInput[3])
        let right = (rawInput[4] & 0x08 == 0x08)
        let left  = (rawInput[4] & 0x04 == 0x04)
        let down  = (rawInput[4] & 0x02 == 0x02)
        let up    = (rawInput[4] & 0x01 == 0x01)
        joystickInput = (up: up, down: down, left: left, right: right)
        
        print("M1: \(musclesInput.muscle1), M2:\(musclesInput.muscle2), Up:\(up), Down:\(down), Left:\(left), Right:\(right)")
        
        DispatchQueue.main.sync {
            self.sendNotificationReceivedData()
        }
    }
    
    fileprivate func sendNotificationReceivedData() {
        NotificationCenter.default.post(name: Notification.Name(rawValue: L10n.Notif.Ble.dataReceived), object: nil)
    }
    
    fileprivate func bytesToValue(coeff: UInt8, add: UInt8) -> Int {
        let res = Int(coeff) * 32 + Int(add)
        return res
    }
}