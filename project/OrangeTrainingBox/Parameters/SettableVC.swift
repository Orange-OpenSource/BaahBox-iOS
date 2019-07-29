//
//  SettableVC.swift
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

class SettableVC : UIViewController {
    let btManager = BLEDiscovery.shared()
    let dataManager = ParameterDataManager.sharedInstance
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var navTintColor : UIColor = UIColor.black {
        didSet {
            configureNavBar()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(bleUp(_:)), name: NSNotification.Name(rawValue: L10n.Notif.Ble.up), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(bleDown(_:)), name: NSNotification.Name(rawValue: L10n.Notif.Ble.down), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavBar()
        configureBaahBox()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
       
    }
    
    deinit {
         NotificationCenter.default.removeObserver(self)
    }
    
    func configureBaahBox() {
        
        if dataManager.demoMode {
            return
        }
        
        if btManager.isConnected() {
            return
        }
        
       presentConnectionPopup()
    }

    func configureRightBarButtons () {
        var buttons : [UIBarButtonItem] = []
        
        let parameterButton = UIBarButtonItem (image: Asset.Dashboard.settingsIcon.image,
                                               style: UIBarButtonItem.Style.plain,
                                               target: self, action:#selector (onParameterButton))
        parameterButton.tintColor = navTintColor
        
        buttons.append(parameterButton)

        if btManager.getBTState() != .poweredOff {
        
            let btParameterButton = UIBarButtonItem (image: Asset.Dashboard.bluetooth.image,
                                               style: UIBarButtonItem.Style.plain,
                                               target: self, action:#selector (onBTButton))
            btParameterButton.tintColor = navTintColor
           
            buttons.append(btParameterButton)
        }
    
        navigationItem.rightBarButtonItems = buttons
        navigationItem.rightBarButtonItem?.tintColor = navTintColor
    }
    
    func configureNavBar() {
        navigationController?.tintColor = navTintColor
        navigationController?.barTextColor = navTintColor
        navigationItem.rightBarButtonItem?.tintColor = navTintColor
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: navTintColor]
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: navTintColor]
        
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.isHidden = false
        
        configureRightBarButtons()
    }
    
    
    @objc func onParameterButton(button: UIButton) {
        
        let storyboard = UIStoryboard(name: "Settings", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "mainParametersVC") as! MainParametersVC
        navigationController?.pushViewController(controller, animated: true)
        
        
//        DispatchQueue.main.async {
//            UIView.beginAnimations("animation", context: nil)
//            UIView.setAnimationDuration(0.5)
//            self.navigationController!.pushViewController(controller, animated: false)
//            UIView.setAnimationTransition(UIView.AnimationTransition.flipFromLeft, for: self.navigationController!.view, cache: false)
//            UIView.commitAnimations()
//        }
    }
    
    
    @objc func onBTButton(button: UIButton) {
        
        let storyboard = UIStoryboard(name: "Settings", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "connectionVC")
        navigationController?.pushViewController(controller, animated: true)
    }

    
    func presentBTSettingPanel () {
        
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        
        DispatchQueue.main.async {
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: nil)
            }
        }
    }
    
    func presentConnectionPannel () {
        let storyboard = UIStoryboard(name: "Settings", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "connectionVC")
        controller.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func presentConnectionPopup () {
        
        let alert = UIAlertController(title: L10n.Generic.connect, message: L10n.Ble.Connection.popupTitle, preferredStyle: .alert);
        
        alert.view.tintColor = Asset.Colors.pinky.color
        
        alert.addAction(UIAlertAction(title: L10n.Generic.cancel, style: .cancel, handler: {(action:UIAlertAction) in
            self.dataManager.demoMode = true
            self.appDelegate.shouldPresentConnectionPannel = false
            self.configureNavBar()
        }))
        
        alert.addAction(UIAlertAction(title: L10n.Generic.connect, style: .default, handler: {(action:UIAlertAction) in
            
            if self.btManager.getBTState() == .poweredOff {
                self.appDelegate.shouldPresentConnectionPannel = true
                self.presentBLEConnectionPopup()
            } else {
                self.configureNavBar()
                self.appDelegate.shouldPresentConnectionPannel = false
                self.presentConnectionPannel()
            }
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    func presentBLEConnectionPopup () {
        
        let alert = UIAlertController(title: L10n.Generic.ble, message: L10n.Ble.Connection.bleSwitchON, preferredStyle: .alert);
        
        alert.view.tintColor = Asset.Colors.pinky.color
        
        alert.addAction(UIAlertAction(title: L10n.Generic.cancel, style: .cancel, handler: {(action:UIAlertAction) in
            self.dataManager.demoMode = true
            self.appDelegate.shouldPresentConnectionPannel = false
        }))
        
        alert.addAction(UIAlertAction(title: L10n.Generic.activate, style: .default, handler: {(action:UIAlertAction) in
            self.presentBTSettingPanel()
        }))
        
        present(alert, animated: true, completion: nil)
        
    }

    
    // MARK: Notifications
    
    @objc func bleUp(_ notification: Notification) {
        DispatchQueue.main.async {
            self.configureNavBar()
            
            if self.appDelegate.shouldPresentConnectionPannel {
                self.presentConnectionPopup()
            }
        }
    }
    
    @objc func bleDown(_ notification: Notification) {
        DispatchQueue.main.async {
            self.configureNavBar()
        }
    }
}
