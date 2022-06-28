/*
 *
 * ESSAbout
 *
 * File name:   ESSAboutElement.swift
 * Version:     2.1.0
 * Created:     04/10/2016
 * Created by:  Julien GALHAUT
 *
 * Copyright (C) 2016 Orange
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

import Foundation

/// Enum describing the type of a element
@objc public enum ESSAboutElementType : Int {
    
    case webview
    
    case browser
    
    case custom
    
    case html
    
    func name() -> String {
        switch self {
            case .browser: return "browser"
            case .webview: return "webview"
            case .custom: return "custom"
            case .html: return "html"
        }
    }
}

/// A Element is a block displayed in main section
@objc public final class ESSAboutElement : NSObject {
    
    /// Type of a element
    public var type : ESSAboutElementType
    /// Icon of element
    public var iconKey : String
    /// Localized Key for element's title
    public var titleKey : String
    /// Localized Key for element's content (could include HTML content)
    public var contentKey :String
    
    public var linkInBrowser :Bool
    
    /**
     Initializer
     
     - parameter type:        desired ESSAboutElementType
     - parameter titleKey:    desired localized Key for Element's title
     - parameter contentKey:  desired localized Key for Element's content
     
     - returns: initialized Term object
     */
    public init(type : ESSAboutElementType, iconKey: String = "",  titleKey : String, contentKey : String = "", linkInBrowser : Bool = false) {
        self.type = type
        self.iconKey = iconKey
        self.titleKey = titleKey
        self.contentKey = contentKey
        self.linkInBrowser = linkInBrowser
    }
    
    /**
     Initializer
     
     - parameter type:        desired ESSAboutElementType
     - parameter titleKey:    desired localized Key for Element's title
     
     - returns: initialized Term object
     */
    public init(type : ESSAboutElementType, titleKey : String) {
        self.type = type
        self.titleKey = titleKey
        self.contentKey = ""
        self.iconKey = ""
        self.linkInBrowser = false
    }

}
