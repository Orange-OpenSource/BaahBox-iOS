//
//  AppDelegate.swift
//  OrangeTrainingBox
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

