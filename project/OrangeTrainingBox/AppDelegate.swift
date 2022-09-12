//
//  AppDelegate.swift
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
import ESSAbout

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var shouldPresentConnectionPannel = true
    var safeAreaInsets = UIEdgeInsets()


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Essential About component initialization
        let configESSAbout = ESSAboutConfig()
        
        var elements = [ESSAboutElement]()
        elements.append(ESSAboutElement(type: .html, titleKey: "ESSAbout.rubricTitle.AppNewFeaturesTitle", contentKey: "news_app.html", linkInBrowser: false))
        elements.append(ESSAboutElement(type: .html, titleKey: "ESSAbout.rubricTitle.AppLegalInformationsTitle", contentKey: "legal_notices.html", linkInBrowser: false))
        elements.append(ESSAboutElement(type: .html, titleKey: "ESSAbout.rubricTitle.AppTermOfUseTitle", contentKey: "cgu.html", linkInBrowser: false))
        elements.append(ESSAboutElement(type: .html, titleKey: "ESSAbout.rubricTitle.AppPrivacypolicyTitle", contentKey: "privacy.html", linkInBrowser: false))
        
        configESSAbout.mainElements = elements
        ESSAboutManager.with(configESSAbout)
        
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
