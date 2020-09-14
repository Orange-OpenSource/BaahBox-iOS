//
//  BLEDiscovery.swift
//  Baah Box
//
//  Copyright (C) 2017 – 2020 Orange SA
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
import CoreBluetooth

class BLEDiscovery: NSObject, CBCentralManagerDelegate {
    
    var centralManager: CBCentralManager?
    var currentPeripheral: CBPeripheral?
    var currentPeripheralName: String = ""
    var pendingPeripheralToConnect: CBPeripheral?
    var peripherals = Array<CBPeripheral>()
    var peripheralNames: [CBPeripheral?: String] = [:]
    var discoveryTimer: Timer!
    
    
    override init() {
        super.init()
        let centralQueue = DispatchQueue(label: "com.orange", attributes: [])
        centralManager = CBCentralManager(delegate: self, queue: centralQueue,
                                          options: [CBCentralManagerOptionShowPowerAlertKey: false])
    }
    
    static let sharedInstance: BLEDiscovery = {
        BLEDiscovery()
    }()
    
    static func shared() -> BLEDiscovery {
        return sharedInstance
    }
    
    func getCurrentPeripheralName() -> String {
        return peripheralNames[currentPeripheral] ?? ""
    }
    
    func getBTState () -> CBManagerState {
        guard let central = centralManager else {
            return .poweredOff
        }
        
        return central.state
    }
    
    func startScanning() {
        
        guard let central = centralManager else {
            return
        }
        
        switch central.state {
       
        case .poweredOn:
            DispatchQueue.main.async {
                if self.discoveryTimer != nil {
                    self.discoveryTimer.invalidate()
                }
                self.discoveryTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self,
                                                           selector: #selector(self.onDiscoveryTimerExpiration),
                                                           userInfo: nil, repeats: true)
            }
            self.peripherals.removeAll()
            
            // If we start scanning while already connected to a device,
            // this current device won't be part of the discoverd devices list coming from the CBManager.
            // Force it into the array of peripherals.
            
            if self.currentPeripheral != nil {
                self.peripherals.append(self.currentPeripheral!)
            }
            
            central.scanForPeripherals(withServices: [BLEServiceUUID], options: [CBCentralManagerScanOptionAllowDuplicatesKey: true])
           
            
        case .unauthorized:
            NotificationCenter.default.post(name: Notification.Name(rawValue: L10n.Notif.Ble.authorization), object: self, userInfo: nil)
            
        default:
            break
        }
    }
    
    func stopScanning () {
        centralManager?.stopScan()
    }
    
    func btConnect (_ peripheral: CBPeripheral) {
        
        guard let central = centralManager else {
            return
        }
        
        if central.state != .poweredOn {
            return
        }
        
        DispatchQueue.main.async {
            self.discoveryTimer.invalidate()
        }
        
        central.stopScan()
        
        if currentPeripheral == nil || currentPeripheral?.state == .disconnected {
            currentPeripheral = peripheral
            pendingPeripheralToConnect = nil
            peripherals.removeAll()
            bleService = nil
            central.connect(peripheral, options: nil)
            return
        }
        
        if currentPeripheral == peripheral {
            bleService?.sendNotificationPeripheralConnected()
        } else {
            pendingPeripheralToConnect = peripheral
            central.cancelPeripheralConnection(currentPeripheral!)
            currentPeripheral = nil
        }
    }
    
    func isConnected () -> Bool {
        return currentPeripheral?.state == CBPeripheralState.connected
    }
    
    func btDisconnect() {
        
        guard let central = centralManager else {
            return
        }
        
        if central.state != .poweredOn {
            return
        }
        
        guard let currentPeripheral = currentPeripheral else {
            return
        }
        
        central.cancelPeripheralConnection(currentPeripheral)
    }
    
    // =========================
    // MARK: - Timer management
    // =========================
    
    
    @objc func onDiscoveryTimerExpiration() {
        let discoveredPeripherals = ["peripherals": peripherals, "peripheralNames": peripheralNames] as [String: Any]
        NotificationCenter.default.post(name: Notification.Name(rawValue: L10n.Notif.Ble.discovery), object: self, userInfo: discoveredPeripherals)
    }
    
    var bleService: BLEService? {
        
        didSet {
            if let service = bleService {
                service.startDiscoveringServices()
            }
        }
    }
    
    // =================================
    // MARK: - CBCentralManagerDelegate
    // =================================

    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {
      
        let localName = advertisementData["kCBAdvDataLocalName"] as? String ?? ""

        if shouldIgnorePeripheral(for: localName, peripheral: peripheral) {
            return
        }

        if !peripherals.contains(peripheral) {
            peripherals.append (peripheral)
            peripheralNames[peripheral] = localName
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        
        if peripheral == currentPeripheral {
            bleService = BLEService (with: peripheral)
        }

        central.stopScan()
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        
        if pendingPeripheralToConnect != nil {
            btConnect(pendingPeripheralToConnect!)
            return
        }

        if peripheral == currentPeripheral {
            bleService = nil
            currentPeripheral = nil
            NotificationCenter.default.post(name: Notification.Name(rawValue: L10n.Notif.Ble.disconnection), object: self, userInfo: nil)
        }
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOff:
            clearDevices()
        case .resetting:
            clearDevices()
        case .unauthorized:
         break  // NotificationCenter.default.post(name: Notification.Name(rawValue: L10n.Notif.Ble.authorization), object: self, userInfo: nil)
        default:
            break
        }
    }
    
    // ================
    // MARK: - Private
    // ================

    
    func shouldIgnorePeripheral(for localName: String, peripheral: CBPeripheral) -> Bool {

        if (localName.isEmpty || localName == "Adafruit Bluefruit LE") && !peripherals.contains(peripheral) {
            return true
        }
        
        return false
    }
    
    func clearDevices() {
        bleService = nil
        currentPeripheral = nil
    }
}
