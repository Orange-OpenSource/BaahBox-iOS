//
//  BTConnectionViewController.swift
//  Baah Box
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
import CoreBluetooth

class BTConnectionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var btPeripherals = Array<CBPeripheral>()
    var btPeriperalNames : [CBPeripheral?:String] = [:]
    var selectedCells : [String: Bool] = [:]
    let btManager = BLEDiscovery.shared()
    var selectedPeripheralIndex = -1
    var headerCellIndex = 0
    var footerCellIndex = 0
    let actInd: UIActivityIndicatorView = UIActivityIndicatorView()
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title =  L10n.Ble.Connection.title
        NotificationCenter.default.addObserver(self, selector: #selector(peripheralDiscovered(_:)), name: NSNotification.Name(rawValue: L10n.Notif.Ble.discovery), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(peripheralConnected(_:)), name: NSNotification.Name(rawValue: L10n.Notif.Ble.connection), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(peripheralDisconnected(_:)), name: NSNotification.Name(rawValue: L10n.Notif.Ble.disconnection), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        btManager.startScanning()
        configureTableView()
        updateNavBar(shouldShowAnimation: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        btManager.stopScanning()
    }
    
    func updateNavBar (shouldShowAnimation : Bool = false) {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 34, height: 15))
        let title = NSMutableAttributedString(string: L10n.Generic.ok,
                                              attributes: [NSAttributedString.Key.font:  UIFont.boldSystemFont(ofSize: 20), NSAttributedString.Key.foregroundColor : Asset.Colors.pinky.color])
        if selectedPeripheralIndex != -1 {
            button.setAttributedTitle(title, for: .normal)
            button.setTitleColor(UIColor.red, for: .normal)
            button.addTarget(self, action: #selector(doConnection(sender:)), for: .touchUpInside)
            navigationItem.rightBarButtonItem = UIBarButtonItem (customView: button)
        } else {
            
            if shouldShowAnimation {
                navigationItem.rightBarButtonItem = getStartInidcatorButton()
            } else {
                navigationItem.rightBarButtonItem = nil
            }
        }
    }
    
    func configureSelectedCells () {
    
        for index in 0..<btPeripherals.count {
            let peripheralName = getPeripheralName(at: index)
            let connectedPeripheralName = btManager.peripheralNames[btManager.currentPeripheral]
            
            if selectedCells[peripheralName] == nil {
                selectedCells[peripheralName] = peripheralName == connectedPeripheralName ? true : false
            }
        }
    }
    
    func resetSelectedCells () {
        
        for item in selectedCells {
            selectedCells[item.key] = false
        }
    }
    
    func resetSelectedItem () {
        selectedPeripheralIndex = -1
    }
    
    func toogleSelectedCells(with name: String) {
    
        for item in selectedCells {
         
            if item.key == name {
                selectedCells[item.key] = !item.value
            } else {
                selectedCells[item.key] = false
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func doConnection(sender: UIBarButtonItem) {
        navigationItem.rightBarButtonItem = getStartInidcatorButton()
        btManager.btConnect(btPeripherals[selectedPeripheralIndex])
    }
    
    func configureTableView () {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        headerCellIndex = 0
        updateFooterIndex()
    }
    
    func updateFooterIndex () {
        footerCellIndex = btPeripherals.count + 1
    }
    
    //MARK: - TableView delegates
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // Adds 1 cell for the header and 1 for the footer
        return btPeripherals.count + 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case headerCellIndex:
            return configureHeaderCell(at: indexPath)
        case footerCellIndex:
            return configureFooterCell(at: indexPath)
        default:
            return configureBTPeripheralCell(at: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case footerCellIndex:
            navigationItem.rightBarButtonItem = getStartInidcatorButton()
            btManager.btDisconnect()
        default:
            let newIndex = getPeripheralIndex (at: indexPath)
            
            let peripheralName = getPeripheralName(at: newIndex)
            toogleSelectedCells(with: peripheralName)
            selectedPeripheralIndex = selectedCells[peripheralName]! ? newIndex : -1
            tableView.reloadData()
            updateNavBar()
        }
    }
    
    
    // MARK: - Cell configuration
    
    func configureHeaderCell(at indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "btHeaderCell", for: indexPath) as? BTHeaderCell else {
            return UITableViewCell()
        }
    
        cell.configure()
        return cell
    }
    
    func configureFooterCell(at indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "buttonCell", for: indexPath) as? GeneralButtonCell else {
            return UITableViewCell()
        }
        
        if btManager.isConnected() && btPeripherals.count > 0 {
            
            let activeCells = selectedCells.filter { item -> Bool in
                return item.value
            }

            let connectedPeripheralName = btManager.peripheralNames[btManager.currentPeripheral]
            cell.configure (activeButton: activeCells.first?.key == connectedPeripheralName)

        } else {
            cell.isHidden = true
        }
        
        return cell
    }
    
    func configureBTPeripheralCell(at indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "btCell", for: indexPath) as? BTCell else {
            return UITableViewCell()
        }
        
        let index = getPeripheralIndex (at: indexPath)
        let peripheralName = getPeripheralName(at: index)
        cell.configure(with: peripheralName,shouldShowTick: selectedCells[peripheralName] ?? false)
        return cell
    }
    
    func getPeripheralIndex(at indexPath : IndexPath) -> Int {
        return indexPath.row - 1
    }
    
    func getPeripheralName (at index : Int) -> String {
        guard index >= 0  else { return "" }
    
        let peripheral =  btPeripherals[index]
        return btPeriperalNames[peripheral] ?? ""
    }
    
    // MARK: - Notification handling
    
    @objc func peripheralDiscovered(_ notification: Notification) {
        
        if let userInfo = (notification as NSNotification).userInfo {
            
            if let newPeripherals = userInfo["peripherals"] as? Array<CBPeripheral> {
                btPeripherals = newPeripherals
            }

            if let newPeripheralNames = userInfo["peripheralNames"] as? [CBPeripheral?:String] {
                btPeriperalNames = newPeripheralNames
            }

        }
        
        configureSelectedCells()
        updateFooterIndex()
        
        if btPeripherals.count > 0 {
            updateNavBar()
            actInd.stopAnimating()
        } else {
            updateNavBar(shouldShowAnimation: true)
        }
        
        tableView.reloadData()
    }
    
    @objc func peripheralConnected(_ notification: Notification) {
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func peripheralDisconnected(_ notification: Notification) {
        DispatchQueue.main.async {
            self.resetSelectedCells()
            self.resetSelectedItem()
            self.updateFooterIndex()
            self.updateNavBar()
            self.tableView.reloadData()
        }
    }
    
    
    func getStartInidcatorButton () -> UIBarButtonItem {
        let customView = UIButton ()
        
        customView.frame = CGRect (x: 0, y: 0, width: 40, height: 40)
        customView.isUserInteractionEnabled = false
        
       
        actInd.frame = CGRect (x: 0, y: 0, width: 40, height: 40)
        actInd.center = customView.center
        actInd.hidesWhenStopped = true
        actInd.style = .gray
        
        customView.addSubview(actInd)
        
        actInd.startAnimating()
        
        let button = UIBarButtonItem (customView: customView)
        button.isEnabled = false
        
        return button
    }
    

}
