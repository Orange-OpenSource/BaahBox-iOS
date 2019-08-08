//
//  BLEService.swift
//  Baah Box
//
///  Copyright (C) 2017 – 2019 Orange SA
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

import Foundation
import CoreBluetooth

// Service: BT commands use the UART service
let BLEServiceUUID = CBUUID(string: "6E400001-B5A3-F393-E0A9-E50E24DCCA9E")

// Characteristics for UART service
let txPositionCharUUID = CBUUID(string: "6E400002-B5A3-F393-E0A9-E50E24DCCA9E")
let rxPositionCharUUID = CBUUID(string: "6E400003-B5A3-F393-E0A9-E50E24DCCA9E")


class BLEService: NSObject, CBPeripheralDelegate {
    var peripheral: CBPeripheral?
    var txPositionCharacteristic: CBCharacteristic?
    var rxPositionCharacteristic: CBCharacteristic?
    var rxData: [UInt8] = [0]
    var inputData: [UInt8] = []

    #if TEST_BANDWIDTH
    var counter = 0
    var timer = Timer()
    #endif
    
    init(with btPeripheral: CBPeripheral) {
        super.init()
        peripheral = btPeripheral
        peripheral?.delegate = self

        #if TEST_BANDWIDTH
        DispatchQueue.main.sync {
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { timer in
                print("count: \(self.counter)")
                self.counter = 0
            })
        }
        #endif
    }
    
    deinit {
        reset()
    }
    
    func startDiscoveringServices() {
        peripheral?.discoverServices([BLEServiceUUID])
    }
    
    func reset() {
        peripheral = nil
    }
    
    // MARK: - CBPeripheralDelegate
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        
        if peripheral != self.peripheral {
            return
        }
        
        if let error = error {
            print ("BlueTooth error: \(error)")
            return
        }
        
        guard let peripheralServices = peripheral.services else {
            return
        }
        
        let _ = peripheralServices.map {service in
            
            if service.uuid == BLEServiceUUID {
                peripheral.discoverCharacteristics([txPositionCharUUID, rxPositionCharUUID], for: service)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        
        if peripheral != self.peripheral {
            return
        }
        
        if let error = error {
            print ("BlueTooth error: \(error)")
            return
        }
        
        var numberOfDiscoverdCharacteristics = 0
        
        if let characteristics = service.characteristics {
            
            for characteristic in characteristics {
                
                if characteristic.uuid == rxPositionCharUUID {
                    numberOfDiscoverdCharacteristics += 1
                    peripheral.setNotifyValue(true, for: characteristic)
                    rxPositionCharacteristic = characteristic
                }
                
                if characteristic.uuid == txPositionCharUUID {
                    numberOfDiscoverdCharacteristics += 1
                    txPositionCharacteristic = characteristic
                }
            }
            
            if numberOfDiscoverdCharacteristics == 2 {
                sendNotificationPeripheralConnected()
            }
        }
    }

    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        
        if peripheral != self.peripheral {
            return
        }
        
        if let error = error {
            print("BlueTooth error : \(error)")
            return
        }
        
        guard let data = characteristic.value else { return }
        
        rxData = [UInt8](repeating: 0, count: data.count)
        data.copyBytes(to: &rxData, count: data.count)
        
        // Frame 6 Bytes
        // [b1...b5,\n]
        for rxChar in rxData {
            if rxChar != 90 {
                inputData.append(rxChar)
            } else {
                #if TEST_BANDWIDTH
                    self.counter = self.counter+1
                #endif
                SensorInputManager.sharedInstance.analyseCompressedRawInput(inputData)
                inputData = []
            }
        }
    }
    
    // MARK: - Private
    
    func writeCommand(_ command: Data) {
        
        if let txPositionCharacteristic = txPositionCharacteristic {
            peripheral?.writeValue(command as Data, for: txPositionCharacteristic, type: .withResponse)
        }
    }
    
    func sendNotificationPeripheralConnected() {
        let connectionDetails = ["peripheralName": peripheral?.name ?? "empty value" ]
        NotificationCenter.default.post(name: Notification.Name(rawValue: L10n.Notif.Ble.connection), object: self, userInfo: connectionDetails)
    }
}
