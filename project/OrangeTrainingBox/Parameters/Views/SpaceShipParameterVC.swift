//
//  SpaceShipParameterVC.swift
//  OrangeTrainingBox
//
//  Copyright © 2018 Orange. All rights reserved.
//

import UIKit

class SpaceShipParameterVC: UIViewController , UITableViewDelegate, UITableViewDataSource {
    
    let dataManager = ParameterDataManager.sharedInstance
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        title = L10n.Parameters.Ship.title
    }
    
    // MARK:- Tableview management
    
    func configureTableView () {
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return " "
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "shipCell", for: indexPath) as?  GeneralSliderPlusCell else {
                return UITableViewCell()
            }
            
            let text = NSMutableAttributedString(string: L10n.Parameters.Ship.number,
                                                 attributes: [NSAttributedString.Key.font:  UIFont.boldSystemFont(ofSize: 16)])
            
            cell.title.attributedText = text
            cell.sliderItem.value = Float (dataManager.numberOfSpaceShips)
            
            let val = NSMutableAttributedString(string: cell.sliderItem.value.clean,
                                                attributes: [NSAttributedString.Key.font:  UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor : Asset.Colors.pinky.color])
            
            cell.value.attributedText = val
            return cell
            
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "speedCell", for: indexPath) as?  GeneralSegmentCell else {
                return UITableViewCell()
            }
            
            let text = NSMutableAttributedString(string: L10n.Parameters.Ship.speed,
                                                 attributes: [NSAttributedString.Key.font:  UIFont.boldSystemFont(ofSize: 16)])
            cell.label.attributedText = text
            
            cell.segmentItem.removeAllSegments()
            cell.segmentItem.insertSegment(withTitle: L10n.Generic.slow, at: 0, animated: false)
            cell.segmentItem.insertSegment(withTitle: L10n.Generic.medium, at: 1, animated: false)
            cell.segmentItem.insertSegment(withTitle: L10n.Generic.fast, at: 2, animated: false)
            
            switch dataManager.asteriodVelocity {
            case .slow:
                cell.segmentItem.selectedSegmentIndex = 0
            case .average:
                cell.segmentItem.selectedSegmentIndex = 1
            default:
                cell.segmentItem.selectedSegmentIndex = 2
            }
            
            return cell
            
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "explosionTypeCell", for: indexPath) as? GeneralSwitchCell else {
                return UITableViewCell()
            }
            
            let text = NSMutableAttributedString(string: L10n.Parameters.Ship.explosionStyle,
                                                 attributes: [NSAttributedString.Key.font:  UIFont.boldSystemFont(ofSize: 16)])
            cell.label.attributedText = text
            cell.switchItem.isOn = dataManager.explosionType == .particles ? true : false
            
            return cell
            
            
        default:
            return UITableViewCell()
        }
    }
    
    // MARK: - User's actions
    
    @IBAction func onSpeedSelection(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:  dataManager.asteriodVelocity = .slow
        case 1:  dataManager.asteriodVelocity = .average
        default: dataManager.asteriodVelocity = .fast
        }
    }
    
    @IBAction func onShipSelection(_ sender: UISlider) {
        dataManager.numberOfSpaceShips = Int (sender.value)
        tableView.reloadData()
    }
    
    @IBAction func onExplosionTypeSelection(_ sender: UISwitch) {
        dataManager.explosionType = sender.isOn ? .particles : .animatedCrash
    }
}