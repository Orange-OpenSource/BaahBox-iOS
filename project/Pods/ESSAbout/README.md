# ESSAbout

## Old version

##### ESSAppInfo with legacy style  

Available in branch "master_legacy" only write in objective-c  
[https://gitlab.forge.orange-labs.fr/Essentials/ESSApplicationInformation_iOS/tree/master_legacy](https://gitlab.forge.orange-labs.fr/Essentials/ESSApplicationInformation_iOS/tree/master_legacy)

Read the readme.md file for more instruction

Or  
  
##### ESSAppInfo with new brand style   

Available in branch "master_newbrand" only write in objective-c  
[https://gitlab.forge.orange-labs.fr/Essentials/ESSApplicationInformation_iOS/tree/master_newbrand](https://gitlab.forge.orange-labs.fr/Essentials/ESSApplicationInformation_iOS/tree/master_newbrand)

Read the readme.md file for more instruction

## Download demo ipa on OMD Page
[http://omd.com.fr.intraorange/platform/ios/modules/application-information](http://omd.com.fr.intraorange/platform/ios/modules/application-information)

You can install the last version here [ESSAbout](itms-services://?action=download-manifest&url=https://essentials.kermit.orange-labs.fr/IOS/ESSAbout.plist)

## Introduction

The About Essential component can be used to present Legal Information, privacy policy, terms of use or any other information about an application.

The ApplicationInformation component is compatible with iOS 8/9/10 and is build for iPhone and iPad with SWIFT 3, in landscape and portrait mode. 

The component has been built using autolayout, so for iPad you can use different kind of presentation, the component will adapt himself.

You can edit style with other brand like sosh.


## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.
It will create a workspace that you will be able to open in XCode.


## Installation

ESSAbout is available through [CocoaPods](http://cocoapods.org). It is the prefered way to integrate this component to your application.

To install it WITH Trust Badge dependency, simply add the following line to your Podfile:

    pod "ESSAbout"


To install it WITHOUT Trust Badge dependency, simply add the following line to your Podfile:

    pod "ESSAbout/Lite"
    

To use and configure Trust Badge Essential component, please read the official readme :
[https://github.com/Orange-OpenSource/orange-trust-badge-ios]
(https://github.com/Orange-OpenSource/orange-trust-badge-ios)
    
If you don't want to (or can not) use Cocoapods in your project, you can extract the sources of the component and include it in your project manually.


## Configuration

To configure the component you must provide ESSAboutConfig object and add element in the main dictionarie containing special keys and associated values.

Here is a sample source code :

	import ESSAbout

	func application(application: UIApplication, didFinishLaunchingWithOptions 		launchOptions: [NSObject: AnyObject]?) -> Bool {
	
		let configESSAbout = ESSAboutConfig()
	
	 	var elements = [ESSAboutElement]()
        elements.append(ESSAboutElement(type: .html, titleKey: "ESSAbout.rubricTitle.AppNewFeaturesTitle", contentKey: "nouveautes_application.html", linkInBrowser: false))
        elements.append(ESSAboutElement(type: .html, titleKey: "ESSAbout.rubricTitle.AppLegalInformationsTitle", contentKey: "infos_legales.html", linkInBrowser: false))
        elements.append(ESSAboutElement(type: .html, titleKey: "ESSAbout.rubricTitle.AppTermOfUseTitle", contentKey: "cgu.html", linkInBrowser: false))
        elements.append(ESSAboutElement(type: .html, titleKey: "ESSAbout.rubricTitle.AppPrivacypolicyTitle", contentKey: "charte_vie_privee.html", linkInBrowser: false))
        
        
      configESSAbout.mainElements = elements
        
		ESSAboutManager.with(configESSAbout)
		return true
	}

There is no limit in the number of subcategories you can add.

Official wordings are provided for the component, as in the configuration file above. You can load those predefined titles using the localized string identifier. 

Those wordings are available in French and English.

Here are all the predefined wordings available :

	"ESSAbout.rubricTitle.AppNewFeaturesTitle" = "What's new";
	"ESSAbout.rubricTitle.AppLegalInformationsTitle" = "Legal information";
	"ESSAbout.rubricTitle.AppTermOfUseTitle" = "General terms of use";
	"ESSAbout.rubricTitle.AppPrivacypolicyTitle" = "Privacy Policy";
	"ESSAbout.rubricTitle.TrustBadgeTitle" = "Trust Badge";


## Open browser, webview, custom view

If you want opnnening an item in safari web browser, you can add a type and an url like this :

		elements.append(ESSAboutElement(type: .browser, titleKey: "Google", contentKey: "https://www.google.fr", linkInBrowser: false))

or in the internal webview : 

		elements.append(ESSAboutElement(type: .webview, titleKey: "Google", contentKey: "https://www.google.fr", linkInBrowser: false))


or in the internal other view controller : 

		elements.append(ESSAboutElement(type: .custom, titleKey: "My Custom Key name or title", contentKey: "")
		
## Trust Badge Integration

If you integrate full component with trust badge add this element instead of 'privacy policy" :

 	elements.append(ESSAboutElement(type: .custom, titleKey: "ESSAbout.rubricTitle.TrustBadgeTitle"))

## Loading the component

presentation in NavigationController :

	ESSAboutManager.sharedInstance.essDelegate = self
   	ESSAboutManager.sharedInstance.essStatDelegate = self
	let EssAboutRootViewControllerID = "ESSAboutNavigationViewController"
   	let storyboard = UIStoryboard(name: "ESSAbout", bundle: ESSAboutManager.bundle)
   	let viewController = storyboard.instantiateViewController(withIdentifier: EssAboutRootViewControllerID)
    self.navigationController?.pushViewController(viewControllerNavigation, animated: true)
  
  presentation in modal view with splitViewController :
  
  	ESSAboutManager.sharedInstance.essDelegate = self
   	ESSAboutManager.sharedInstance.essStatDelegate = self
    let EssAboutRootViewControllerID = "ESSAboutSplitViewController"
    let storyboard = UIStoryboard(name: "ESSAbout", bundle: ESSAboutManager.bundle) 
    let viewControllerSplit = storyboard.instantiateViewController(withIdentifier: EssAboutRootViewControllerID)
    self.navigationController?.present(viewControllerSplit, animated: true, completion: nil)
        
	
	
## Styling the component

Editable :   
-highlight color   
-background color   
-statusbar color  
-header color  
-header image  
-orange logo visibility  
-app name font and size (main font 3)  
-version and copyright font and size (main font 2)  
-main list element font and size (main font 1)  

All parameters are available in ESSAboutConfig.  
 

	let configESSAbout = ESSAboutConfig()
	
	configESSAbout.statusBarStyle = .lightContent 
	configESSAbout.headerLogoVisibility = false
   	configESSAbout.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
   	configESSAbout.highlightColor = UIColor(white: 0.65, alpha: 1.0)
   	configESSAbout.mainFont1 = UIFont(name:"HelveticaNeue-Thin", size: 12.0)!
   	configESSAbout.mainFont2 = UIFont(name:"HelveticaNeue-Medium, size: 14.0)!
   	configESSAbout.mainFont3 = UIFont(name:"HelveticaNeue-Thin", size: 16.0)!
   	configESSAbout.headerImage = UIImage(named: "your_header")
   	
   	
 
## ESSAboutCustomDelegate

The ESSAboutCustomDelegate is used to make callbacks to the main application. For now, only one callback exists :
	
	@objc public protocol ESSAboutCustomDelegate {
   		func handleCustomLink(_ name: String, navigationController: UINavigationController, splitControler: UISplitViewController?, isSplited: Bool)
	}
	
This delegate method can be used to open your custom view in navigation controller of the component or modal view.

	
## Statystics/Analytics

In order to use an Analytics solution with the ESSAbout component, a ESSAboutStatDelegate delegate protocol has been created. Those are the methods to implement :

	@objc public protocol ESSAboutStatDelegate {
    	func componentDidShowView(_ withName: String)
    	func componentDidPerformEvent(_ withName: String)
	}

In this component, upper methods will be called for the following events/view :

- one call (showView) every time a secondary view appears
	- withName parameter is equal to the value of the key "name" you put in the configuration dictionary
- second is call (performEvent) every time a secondary view type are 'BROWSER' or 'CUSTOM'
- No events are sent in this component, the only one that can be done is a click on a link in a webview.

## Release note
 
Version 2.0.0 : SWIFT 3 Migration / open other view controller  
Version 2.1.0 : Remove plist configuration file, styling the component with color, font or picture of your choice.  
Version 2.1.2 : Fixed Iphone 6/7 Plus landscape's problems    
Version 2.1.3 : update Orange Trust Badge to 1.0.25  
Version 2.1.4 : remove ESSAbout class, rename storyboard ID  
Version 2.1.5 : Make stat and custom delegates available in ObjC, hotfix  
Version 2.1.6 : fix navigationBar tintcolor always white instead of UINavigationBar.appearance().tintColor    
Version 2.2.0 : update with new brand v4, bug fix  
Version 2.2.1 : improve rtl support  
Version 2.2.2 : add custom params (color title and header image position)
Version 2.2.3 : fix margin left/right on ios11
Version 2.3.0 : Swift 4 and Xcode 9 migration, iPhone X compatibility  
Version 2.4.0 : min version is iOS 9.0, Swift 4.1 and Xcode 9.4 migration, minor ui bug fix, cartharge suport  
Version 2.5.0 : Xcode 10.2 & Swift 5

## Contact
GALHAUT Julien, julien1.galhaut@orange.com  
NEVO Anthony, anthony.nevo@orange.com


