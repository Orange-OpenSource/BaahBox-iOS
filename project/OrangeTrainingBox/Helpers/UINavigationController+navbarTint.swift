//
//  UINavigationController+navbarTint.swift
//  OrangeTrainingBox
//
//  Created by Frederique Pinson on 19/11/2018.
//  Copyright © 2018 Orange. All rights reserved.
//

import UIKit


@IBDesignable extension UINavigationController {
    @IBInspectable var barTintColor: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            navigationBar.barTintColor = uiColor
        }
        get {
            guard let color = navigationBar.barTintColor else { return nil }
            return color
        }
    }
    @IBInspectable var tintColor: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            navigationBar.tintColor = uiColor
        }
        get {
            guard let color = navigationBar.tintColor else { return nil }
            return color
        }
    }
    
    
    @IBInspectable var barTextColor: UIColor? {
        set {
            guard let uiColor = newValue else {return}
            navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: uiColor]
        }
        get {
            guard let textAttributes = navigationBar.titleTextAttributes else { return nil }
            return textAttributes[NSAttributedString.Key.foregroundColor] as? UIColor
        }
    }
}

