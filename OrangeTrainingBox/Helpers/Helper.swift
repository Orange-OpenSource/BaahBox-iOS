//
//  Helper.swift
//  Orange Training Box
//
//  Created by Frederique Pinson on 21/03/2017.
//  Copyright © 2017 Orange. All rights reserved.
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
        self.draw(in:imageRect)
        
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





