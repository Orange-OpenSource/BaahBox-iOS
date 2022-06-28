/*
 *
 * ESSAbout
 *
 * File name:   UIFont+ESSContentSize.swift
 * Version:     2.2.0
 * Created:     04/10/2016
 * Created by:  Julien GALHAUT
 *
 * Copyright (C) 2017 Orange
 *
 * This software is confidential and proprietary information of Orange.
 * You shall not disclose such Confidential Information and shall use it only in
 * accordance with the terms of the agreement you entered into.
 * Unauthorized copying of this file, via any medium is strictly prohibited.
 *
 * If you are Orange employee you shall use this software in accordance with
 * the Orange Source Charter ( http://opensource.itn.ftgroup/index.php/Orange_Source ).
 *
 */

import UIKit
import Foundation

extension UIFont {
    static var fontSizeOffset : CGFloat {
        get {
            switch UIApplication.shared.preferredContentSizeCategory {
            case UIContentSizeCategory.accessibilityExtraExtraExtraLarge: return 8.0
            case UIContentSizeCategory.accessibilityExtraExtraLarge: return 7.0
            case UIContentSizeCategory.accessibilityExtraLarge: return 6.0
            case UIContentSizeCategory.accessibilityLarge: return 6.0
            case UIContentSizeCategory.accessibilityMedium: return 5.0
            case UIContentSizeCategory.extraExtraExtraLarge: return 4.0
            case UIContentSizeCategory.extraExtraLarge: return 3.0
            case UIContentSizeCategory.extraLarge: return 2.0
            case UIContentSizeCategory.large: return 1.0
            case UIContentSizeCategory.medium: return 0.0
            case UIContentSizeCategory.small: return -1.0
            case UIContentSizeCategory.extraSmall: return -2.0
            default: return 0.0
            }
        }
    }
    
    static func fontSizeWithPreferredContentSizeBasedOnNormal(forSize size: CGFloat) -> CGFloat {
        return size + fontSizeOffset
    }
}
