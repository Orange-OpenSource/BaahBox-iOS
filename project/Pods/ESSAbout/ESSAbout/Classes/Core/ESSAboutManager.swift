/*
 *
 * ESSAbout
 *
 * File name:   ESSAboutManager.swift
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

open class ESSAboutConfig : NSObject {
    
    /// Name of the app, (Default : Bundle Display Name of host app)
    open var appName : String?
    
    open var version : String?
    
    open var copyright : String?
    
    open var ipadCloseButtonText : String?
    
    open var mainTitleText : String?
    
    /// (Optional) UIColor used to highlight element with a positive status (default black)
    open var highlightColor = UIColor(white: 0.85, alpha:1.0)
    
    /// (Optional) background UIColor of the header (default blue)
    open var headerColor = UIColor(red: 63/256, green: 165/256, blue: 244/256, alpha: 1)
    
    open var contentModeHeader : UIView.ContentMode = .bottomLeft
    
    /// (Optional) background UIColor of the view (default white)
    open var backgroundColor : UIColor = .white
    
    open var titleColor : UIColor = .white
    
    open var mainFont1 : UIFont?
    open var mainFont2 : UIFont?
    open var mainFont3 : UIFont?
    
    /// (Optional) boolean use for the logo of the header
    open var headerLogoVisibility = true
    
    /// (Optional) UIImage use for the header
    open var headerImage : UIImage?
    
    /// (Optional) Status bar style (default Application's default statusBarStyle)
    open var statusBarStyle = UIApplication.shared.statusBarStyle
    
    open var mainElements = [ESSAboutElement]()
}

@objc public final class ESSAboutManager : NSObject {
    
    var applicationName: String! = "Application name"
    var version: String?
    var copyright: String?
    var ipadCloseButtonText : String?
    var mainTitleText : String?
    var titleColor : UIColor! = .white
    var config : ESSAboutConfig?
    
    var mainElements  = [ESSAboutElement]()
    var backgroundColor: UIColor?
    var mainFont1: UIFont?
    var mainFont2: UIFont?
    var mainFont3: UIFont?
    
    public static let sharedInstance = ESSAboutManager()
    
    fileprivate var delegate: ESSAboutCustomDelegate?
    fileprivate var statDelegate: ESSAboutStatDelegate?
  
    /**
    
     - parameter configuration: An ESSAboutConfig containing ESSAbout configuration
     */
    public static func with(_ configuration : ESSAboutConfig) {
        sharedInstance.config = configuration
        sharedInstance.initialize()
    }
    
    func initialize(){
        
        self.mainElements.removeAll()
        if let mainElements = self.config?.mainElements{
            self.mainElements.append(contentsOf: mainElements)
        }
        
        assert(self.mainElements.count > 0, "You must have at least 1 element in Main Elements section to initialize this manager")
       
        initializeFont()
        
        if let backgroundColor = self.config?.backgroundColor {
            self.backgroundColor = backgroundColor
        }
        
        if let titleColor = self.config?.titleColor {
            self.titleColor = titleColor
        }
        
        if let title = self.config?.mainTitleText {
            self.mainTitleText = title
        } else {
            self.mainTitleText = ESSAboutManager.bundle.localizedString(forKey: "ESSAbout.infoTitle", value: "", table: "ESSAbout")
        }
        
        if let customVersion = config?.version{
            self.version = customVersion
        } else {
            let nvVersion: AnyObject? = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as AnyObject?
            self.version = String(format: ESSAboutManager.bundle.localizedString(forKey: "ESSAbout.versionLabel", value: "", table: "ESSAbout"), nvVersion as! String)
        }
        
        if let customCopyright = config?.copyright{
            self.copyright = customCopyright
        } else {
            self.copyright = ESSAboutManager.bundle.localizedString(forKey: "ESSAbout.rightsLabel", value: "", table: "ESSAbout")
        }
        
        //load custom appName
        if let customName = config?.appName{
            self.applicationName = customName
        } else {
            if let bundleDisplayName = Bundle.main.object(forInfoDictionaryKey: "kCFBundleDisplayName"){
                self.applicationName = bundleDisplayName as? String
            } else if let bundleName = Bundle.main.object(forInfoDictionaryKey: kCFBundleNameKey as String){
                self.applicationName = bundleName as? String
            } else {
                print("You should setup a custom application name in ESSAboutConfig")
            }
        }
        
        if let closeButtonNameText = config?.ipadCloseButtonText {
            self.ipadCloseButtonText = closeButtonNameText
        } else {
            self.ipadCloseButtonText = ESSAboutManager.bundle.localizedString(forKey: "ESSAbout.closeButtonIpad", value: "", table: "ESSAbout")
        }
        
    }
    
    func initializeFont() {
        if let mainFont1 = self.config?.mainFont1 {
            self.mainFont1 = mainFont1
        } else {
            self.mainFont1 = UIFont.boldSystemFont(ofSize: UIFont.fontSizeWithPreferredContentSizeBasedOnNormal(forSize: 17.0))
        }
        
        if let mainFont2 = self.config?.mainFont2 {
            self.mainFont2 = mainFont2
        } else {
            self.mainFont2 = UIFont(name:"HelveticaNeue-Medium", size: UIFont.fontSizeWithPreferredContentSizeBasedOnNormal(forSize: 12.0))
        }
        
        if let mainFont3 = self.config?.mainFont3 {
            self.mainFont3 = mainFont3
        } else {
            self.mainFont3 = UIFont(name:"HelveticaNeue-Medium", size: UIFont.fontSizeWithPreferredContentSizeBasedOnNormal(forSize: 28.0))
        }

    }
    
    
    public var essDelegate: ESSAboutCustomDelegate? {
        get {
            return delegate
        }
        set (newDelegate) {
            delegate = newDelegate
        }
    }
    
    
    public var essStatDelegate: ESSAboutStatDelegate? {
        get {
            return statDelegate
        }
        set (newStatDelegate) {
            statDelegate = newStatDelegate
        }
    }
    public static var essBundleForIcon: Bundle = Bundle.main

    public static var bundle:Bundle {
        let podBundle = Bundle(for: ESSAboutManager.self)
        guard let bundleURL = podBundle.url(forResource: "ESSAbout", withExtension: "bundle") else {
            return podBundle
        }
        return Bundle(url: bundleURL)!
    }
    
    public static func instantiateESSAboutSplitViewController() -> UIViewController {
        let storyboard = UIStoryboard(name: "ESSAbout", bundle: bundle)
        return storyboard.instantiateViewController(withIdentifier: "ESSAboutSplitViewController")
    }
    
    public static func instantiateESSAboutViewController() -> UIViewController {
        let storyboard = UIStoryboard(name: "ESSAbout", bundle: bundle)
        return storyboard.instantiateViewController(withIdentifier: "ESSAboutNavigationViewController")
    }
    
    public static func performESSAboutDetailViewController(_ caller: UIViewController, url: String) {
        let EssAboutRootViewControllerID = "ESSAboutDetailViewController"
        let storyboard = UIStoryboard(name: "ESSAbout", bundle: bundle)
        
        let viewController = storyboard.instantiateViewController(withIdentifier: EssAboutRootViewControllerID) as! ESSAboutDetailViewController
        viewController.urlString = url
        caller.navigationController?.pushViewController(viewController, animated: true)
    }
}
