//
//  UIButtonBordered.swift
//  OrangeTrainingBox
//
//  Created by Frederique Pinson on 19/12/2018.
//  Copyright © 2018 Orange. All rights reserved.

import UIKit


@IBDesignable class UIButtonBordered: UIButton {
    
    
    @IBInspectable var borderColor: UIColor = .clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var borderW: CGFloat = 0.0 {
        didSet {
            layer.borderWidth = borderW
        }
    }
    
    @IBInspectable var cornerRd: CGFloat = 0.0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
}
