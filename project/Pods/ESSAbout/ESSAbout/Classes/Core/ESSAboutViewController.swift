/*
 *
 * ESSAbout
 *
 * File name:   ESSAboutViewController.swift
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
import UIKit

class ESSAboutViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var currentSelected: Int!
    var currentOffsetContentSize: CGFloat = UIFont.fontSizeOffset * 3

    override  func viewDidLoad() {
        super.viewDidLoad()
        currentSelected = 0
        
        if let split = self.splitViewController {
            
            let closeButton = UIBarButtonItem(title: ESSAboutManager.sharedInstance.ipadCloseButtonText, style: .plain, target: self, action: #selector(closeSplitViewController(_:)))
            self.navigationItem.leftBarButtonItem = closeButton
            
            let initialIndexPath = IndexPath(row: 0, section: 1)
            self.tableView.selectRow(at: initialIndexPath, animated: true, scrollPosition: UITableView.ScrollPosition.none)

            if !split.isCollapsed {
                self.performSegue(withIdentifier: "showDetail", sender: initialIndexPath)
            }
        }

        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        self.title = ESSAboutManager.sharedInstance.mainTitleText
        
        NotificationCenter.default.addObserver(self, selector: #selector(ESSAboutViewController.rotated), name: UIDevice.orientationDidChangeNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ESSAboutViewController.preferredContentSizeChanged), name: UIContentSizeCategory.didChangeNotification, object: nil)
        
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc func rotated() {
        if (UIDevice.current.userInterfaceIdiom == .phone) {
            if let splitVCExist = self.splitViewController {
                if UIDevice.current.orientation.isLandscape {
                    if !splitVCExist.isCollapsed {
                        var indexOnRotate = IndexPath(row: 0, section: 1)
                        if let currentIndexPath: IndexPath = self.tableView.indexPathForSelectedRow {
                            indexOnRotate = currentIndexPath
                        }
                        self.tableView.selectRow(at: indexOnRotate, animated: true, scrollPosition: UITableView.ScrollPosition.none)
                        self.performSegue(withIdentifier: "showDetail", sender: indexOnRotate)
                    }
                } else if UIDevice.current.orientation.isPortrait {
                    if let indexPath: IndexPath = self.tableView.indexPathForSelectedRow {
                        self.tableView.deselectRow(at: indexPath, animated: true)
                    }
                    self.tableView.deselectRow(at: IndexPath(row: currentSelected, section: 1), animated: true)
                    
                }
            }
        }
    }
    
    @objc func preferredContentSizeChanged() {
        ESSAboutManager.sharedInstance.initializeFont()
        currentOffsetContentSize = UIFont.fontSizeOffset * 3
        let navbarFont =  UIFont.boldSystemFont(ofSize: UIFont.fontSizeWithPreferredContentSizeBasedOnNormal(forSize: 17.0))
        let nav = self.navigationController?.navigationBar
        nav?.titleTextAttributes = [NSAttributedString.Key.font: navbarFont, NSAttributedString.Key.foregroundColor: ESSAboutManager.sharedInstance.titleColor as Any]
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    override func performSegue(withIdentifier identifier: String, sender: Any?) {
        if (shouldPerformSegue(withIdentifier: identifier, sender: sender)) {
            super.performSegue(withIdentifier: identifier, sender: sender)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let del = ESSAboutManager.sharedInstance.essStatDelegate {
            del.componentDidShowView("AppInfoMainView")
        }
        let navbarFont =  UIFont.boldSystemFont(ofSize: UIFont.fontSizeWithPreferredContentSizeBasedOnNormal(forSize: 17.0))
        let nav = self.navigationController?.navigationBar
        nav?.titleTextAttributes = [NSAttributedString.Key.font: navbarFont, NSAttributedString.Key.foregroundColor: ESSAboutManager.sharedInstance.titleColor as Any]
        
        if let indexPath = self.tableView.indexPathForSelectedRow {
            if(currentSelected != indexPath.row){
                self.tableView.selectRow(at: IndexPath(row: currentSelected, section: 1), animated: false, scrollPosition: UITableView.ScrollPosition.none)
                 if self.splitViewController != nil && !self.splitViewController!.isCollapsed {
                    self.performSegue(withIdentifier: "showDetail", sender: self)
                }

            }
            if self.splitViewController != nil && self.splitViewController!.isCollapsed {
                self.tableView.deselectRow(at: indexPath, animated: false)
                self.tableView.deselectRow(at: IndexPath(row: currentSelected, section: 1), animated: false)
            }
            if(UIDevice.current.orientation.isPortrait) {
                rotated()
            }
        }
        
        view.backgroundColor = ESSAboutManager.sharedInstance.backgroundColor
        tableView.backgroundColor = ESSAboutManager.sharedInstance.backgroundColor
    }


    @objc func closeSplitViewController(_ sender: Any) {
        self.splitViewController?.preferredDisplayMode = .primaryHidden
        self.splitViewController?.dismiss(animated: true, completion: nil)
    }

    // MARK: - Segues
    override  func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath: IndexPath = self.tableView.indexPathForSelectedRow {
                let mainElement = ESSAboutManager.sharedInstance.mainElements[(indexPath as NSIndexPath).row]
                
                let controller = (segue.destination as! UINavigationController).topViewController as! ESSAboutDetailViewController
               
                if mainElement.type == .webview {
                    controller.urlString = mainElement.contentKey
                }
                controller.detailItem = mainElement
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "showDetail" {
            return handleActionAbout()
        }
        return true
    }
    
    func handleActionAbout() -> Bool {
        if let indexPath: IndexPath = self.tableView.indexPathForSelectedRow {
            let mainElement = ESSAboutManager.sharedInstance.mainElements[(indexPath as NSIndexPath).row]
            
            switch mainElement.type {
            case .browser:
                self.tableView.deselectRow(at: indexPath, animated: true)
                UIApplication.shared.openURL(URL(string: mainElement.contentKey)!)
                return false
                
            case .custom:
                if let delegate: ESSAboutCustomDelegate = ESSAboutManager.sharedInstance.essDelegate {
                    var controller : UINavigationController?
                    var isSplited : Bool = false
                    if let splitVC = self.splitViewController {
                        controller = (splitVC.viewControllers[(splitVC.viewControllers.count)-1]) as? UINavigationController
                        if (controller == nil) {
                            let EssAboutRootViewControllerID = "ESSAboutNavigationDetailController"
                            let storyboard = UIStoryboard(name: "ESSAbout", bundle: ESSAboutManager.bundle)
                            let viewController = storyboard.instantiateViewController(withIdentifier: EssAboutRootViewControllerID) as! UINavigationController
                            splitVC.showDetailViewController(viewController , sender: nil)
                            controller = viewController
                        } else {
                           controller!.popViewController(animated: false)
                        }
                        isSplited = !splitVC.isCollapsed
                    } else {
                        controller = self.navigationController
                    }
                    
                    if(mainElement.titleKey != "ESSAbout.rubricTitle.TrustBadgeTitle") {
                        currentSelected = indexPath.row
                    }
                    delegate.handleCustomLink(mainElement.titleKey, navigationController: controller!, splitControler: self.splitViewController, isSplited: isSplited)
                   
                }
                return false
            default:
                currentSelected = indexPath.row
                return true
            }
        }
        return false
    }
    
    override  func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UITableViewDelegate Methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.section == 1) {
            let mainElement = ESSAboutManager.sharedInstance.mainElements[indexPath.row]
            if let splitVC = self.splitViewController {
                if !splitVC.isCollapsed && (currentSelected == indexPath.row) {
                    //nothing to do
                } else {
                    self.performSegue(withIdentifier: "showDetail", sender: self)
                }
            } else if (shouldPerformSegue(withIdentifier: "showDetail", sender: nil)){
                let storyboard = UIStoryboard(name: "ESSAbout", bundle: ESSAboutManager.bundle)
                let viewController = storyboard.instantiateViewController(withIdentifier: "ESSAboutDetailViewController") as! ESSAboutDetailViewController
                if mainElement.type == .webview {
                    viewController.urlString = mainElement.contentKey
                }
                
                viewController.detailItem = mainElement
                viewController.navigationItem.leftItemsSupplementBackButton = true
                viewController.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
                
                navigationController?.pushViewController(viewController, animated: true)
                self.tableView.deselectRow(at: indexPath, animated: true)
            } else {
                self.tableView.deselectRow(at: indexPath, animated: true)
            }
            
            if let delegate: ESSAboutStatDelegate = ESSAboutManager.sharedInstance.essStatDelegate {
                delegate.componentDidPerformEvent(mainElement.titleKey)
            }
        }
        
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 295.0 + currentOffsetContentSize
        } else {
            return 48 + currentOffsetContentSize
        }
    }

    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.section == 0) {
            let cell =  tableView.dequeueReusableCell(withIdentifier: "ESSAboutHeaderCell", for: indexPath) as! ESSAboutHeaderCell
            cell.appNameLabel.text = ESSAboutManager.sharedInstance.applicationName
            cell.appVersionLabel.text = ESSAboutManager.sharedInstance.version
            cell.appCopyrightLabel.text = ESSAboutManager.sharedInstance.copyright
            
            cell.appNameLabel.font = ESSAboutManager.sharedInstance.mainFont3
            cell.appVersionLabel.font = ESSAboutManager.sharedInstance.mainFont2
            cell.appCopyrightLabel.font = ESSAboutManager.sharedInstance.mainFont2
            
            if let headerImage = ESSAboutManager.sharedInstance.config?.headerImage {
                cell.headerImageView.image = headerImage
            }
            
            if let contentModeHeaderImage = ESSAboutManager.sharedInstance.config?.contentModeHeader {
                cell.headerImageView.contentMode = contentModeHeaderImage
            }

            cell.orangeLogoImageView.isHidden = !(ESSAboutManager.sharedInstance.config?.headerLogoVisibility)!
            cell.header.backgroundColor = ESSAboutManager.sharedInstance.config?.headerColor
            
            return cell
        } else {
            let cellElement = ESSAboutManager.sharedInstance.mainElements[(indexPath as NSIndexPath).row]
            let icon = UIImage(named: cellElement.iconKey, in: ESSAboutManager.essBundleForIcon, compatibleWith: nil)
            var identifier = "ESSAboutCell"
            if (icon != nil && !cellElement.iconKey.isEmpty) {
                identifier = "ESSAboutIconCell"
            }
        
            let cell =  tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
            let cellText = ESSAboutManager.bundle.localizedString(forKey: cellElement.titleKey, value: "", table: "ESSAbout")
            // Configure Cell
            if identifier == "ESSAboutIconCell"  {
                (cell.contentView.viewWithTag(21) as! UIImageView).image = icon
            }
            (cell.contentView.viewWithTag(20) as! UILabel).text = cellText
            (cell.contentView.viewWithTag(20) as! UILabel).font = ESSAboutManager.sharedInstance.mainFont1
            cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
            cell.accessibilityTraits = UIAccessibilityTraits.button
            let backgroundView = UIView()
            backgroundView.backgroundColor = ESSAboutManager.sharedInstance.config?.highlightColor
            cell.selectedBackgroundView = backgroundView
            cell.backgroundColor = ESSAboutManager.sharedInstance.backgroundColor
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : ESSAboutManager.sharedInstance.mainElements.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
}


