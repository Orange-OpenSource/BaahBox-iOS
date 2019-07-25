//
//  TaudGameParameterVC.swift
//  OrangeTrainingBox
//
//  Copyright © 2018 Orange. All rights reserved.
//

import UIKit

class TaudGameParameterVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let dataManager = ParameterDataManager.sharedInstance
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        title = L10n.Parameters.Taud.title
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
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "flyCell", for: indexPath) as?  GeneralSliderPlusCell else {
                return UITableViewCell()
            }
            
            let text = NSMutableAttributedString(string: L10n.Parameters.Taud.number,
                                                 attributes: [NSAttributedString.Key.font:  UIFont.boldSystemFont(ofSize: 16)])
            
            cell.title.attributedText = text
            cell.sliderItem.value = Float (dataManager.numberOfFlies)
            
            let val = NSMutableAttributedString(string: cell.sliderItem.value.clean,
                                                attributes: [NSAttributedString.Key.font:  UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor : Asset.Colors.pinky.color])
            
            cell.value.attributedText = val
            return cell
            
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "timeCell", for: indexPath) as?  GeneralSliderPlusCell else {
                return UITableViewCell()
            }
            
            let text = NSMutableAttributedString(string: L10n.Parameters.Taud.time,
                                                 attributes: [NSAttributedString.Key.font:  UIFont.boldSystemFont(ofSize: 16)])
            
            cell.title.attributedText = text
            cell.sliderItem.value = Float (dataManager.flySteadyTime)
            
            let value = L10n.Parameters.Taud.timeValue(cell.sliderItem.value.clean)
            let val = NSMutableAttributedString(string: value,
                                                attributes: [NSAttributedString.Key.font:  UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor : Asset.Colors.pinky.color])
            cell.value.attributedText = val
            return cell
        
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "shootTypeCell", for: indexPath) as? GeneralSwitchCell else {
                return UITableViewCell()
            }
            
            let text = NSMutableAttributedString(string: L10n.Parameters.Taud.shootStyle,
                                                 attributes: [NSAttributedString.Key.font:  UIFont.boldSystemFont(ofSize: 16)])
            cell.label.attributedText = text
            cell.switchItem.isOn = dataManager.shootingType == .automatic ? true : false
            
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    
    // MARK: - User's actions
    
    
    @IBAction func onFlySelection(_ sender: UISlider) {
        dataManager.numberOfFlies = Int (sender.value)
        tableView.reloadData()
    }
    
    @IBAction func onTimeSelection(_ sender: UISlider) {
        dataManager.flySteadyTime = Int (sender.value)
        tableView.reloadData()
    }
    
    @IBAction func onShootingSelection(_ sender: UISwitch) {
        dataManager.shootingType = sender.isOn ? .automatic : .manual
    }

}
