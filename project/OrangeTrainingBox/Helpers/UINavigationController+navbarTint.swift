//
//  UINavigationController+navbarTint.swift
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

