//
//  Helper.swift
//  Baah Box
//
//  Copyright (C) 2017 – 2025 Orange SA
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
import UIKit

extension Double {
    var CGFloatValue: CGFloat {
        get {
            return CGFloat(self)
        }
    }
}
extension Int {
    var CGFloatValue: CGFloat {
        get {
            return CGFloat(self)
        }
    }
}

extension UIImage {
    func imageByAddingBorder(borderWidth width: CGFloat, borderColor color: UIColor) -> UIImage {
        UIGraphicsBeginImageContext(self.size)
        let imageRect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        self.draw(in: imageRect)
        
        let ctx = UIGraphicsGetCurrentContext()!
        let borderRect = imageRect.insetBy(dx: width / 2, dy: width / 2)
        
        ctx.setStrokeColor(color.cgColor)
        ctx.setLineWidth(width)
        ctx.stroke(borderRect)
        
        let borderedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return borderedImage!
}
}


extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    func makeVertical() {
        transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi / 2))
    }
}

extension UITableView {
    
    func setupLayout(_ basicEstimatedRowHeight: CGFloat = 100) {
        estimatedRowHeight = basicEstimatedRowHeight
        rowHeight = UITableView.automaticDimension
        sectionHeaderHeight = UITableView.automaticDimension
        sectionFooterHeight = UITableView.automaticDimension
        cellLayoutMarginsFollowReadableWidth = false // see: https://stackoverflow.com/a/33410884
        layoutIfNeeded()
    }
}

extension Float {
    var clean: String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(format: "%.2f", self)
        //return String(format: "%.2f", self)
    }
}

func rangeMap(_ value: Int, _ min1: Int, _ max1: Int, _ min2: Int, _ max2: Int) -> Int {
    let slope = Float(max2 - min2) / Float(max1 - min1)
    return min2 + lround(Double(slope *  Float(value - min1)))
    }

func calibrateForAmplitude(_ value: Int, _ min1: Int, _ max1: Int) -> Int {
    let slope = Float((100) / (max1 - min1))
    return lround(Double(slope * Float(value - min1)))
    }


func convertAngleToAnalog(_ angle: Int) -> Int {
    return rangeMap(angle, 0, 180, 0, 1000)
}

func calibrateAnalogInput(_ value: Int) -> Int {
    let range = ParameterDataManager.sharedInstance.currentAnalogInputRange
    let lowerConvertedAngle = convertAngleToAnalog(range.lowerBound)
    let higherConvertedAngle = convertAngleToAnalog(range.upperBound)
    let slope = Double(1000.0 / Double(higherConvertedAngle - lowerConvertedAngle))
    guard value >= lowerConvertedAngle else {
        return 0
    }
    return  min(1000, lround(Double(value - lowerConvertedAngle) * slope))
}

