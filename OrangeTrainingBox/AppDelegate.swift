//
//  AppDelegate.swift
//  OrangeTrainingBox
//
//  Created by Frederique Pinson on 22/10/2018.
//  Copyright © 2018 Orange. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var shouldPresentConnectionPannel = true
    var safeAreaInsets = UIEdgeInsets()


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        let btManager = BLEDiscovery.shared()
        
        if btManager.getBTState() == .poweredOff {
            NotificationCenter.default.post(name: Notification.Name(rawValue: L10n.Notif.Ble.down), object: self, userInfo: nil)
        } else {
            NotificationCenter.default.post(name: Notification.Name(rawValue: L10n.Notif.Ble.up), object: self, userInfo: nil)
        }
    }

}

