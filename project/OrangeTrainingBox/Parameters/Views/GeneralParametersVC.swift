//
//  GeneralParametersVC.swift
//  Baah Box
//
//  Copyright (C) 2017 – 2019 Orange SA
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

import UIKit

class GeneralParametersVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    let dataManager = ParameterDataManager.sharedInstance
    let demoModeTag = -1
    let sensorTypeTag = 1001
    let sensitivityTag  = 1002
    
    enum SectionDescription: Int {
        case demo = 0
        case sensor = 1
        case muscle = 2
        case sensitivity = 3
        case detection = 4
        
        func numberOfRows () -> Int {
            switch self {
            case .demo:
                return 1
            case .sensor:
                return 1
            case .muscle:
                return 2
            case .sensitivity:
                return 1
            case .detection:
                return 1
            }
        }
        
        func title () -> String {
            switch self {
            case .demo:
                return L10n.GeneralParameters.Section.Demo.title
            case .sensor:
                return L10n.GeneralParameters.Section.Sensor.title
            case .muscle:
                return L10n.GeneralParameters.Section.Muscle.title
            case .sensitivity:
                return L10n.GeneralParameters.Section.Sensitivity.title
            case .detection:
                return L10n.GeneralParameters.Section.Detection.title
            }
        }
        
        func subtitle() -> String {
            switch self {
            case .demo:
                return L10n.GeneralParameters.Section.Demo.subtitle
            case .sensor:
                return L10n.GeneralParameters.Section.Sensor.subtitle
            case .muscle:
                return L10n.GeneralParameters.Section.Muscle.subtitle
            case .sensitivity:
                return L10n.GeneralParameters.Section.Sensitivity.subtitle
            case .detection:
                return L10n.GeneralParameters.Section.Detection.subtitle
            }
        }
        
        func items() -> [String] {
            switch self {
            case .demo:
                return[L10n.GeneralParameters.Section.Demo.item1]
            case .sensor:
                return [L10n.GeneralParameters.Section.Sensor.item1]
            case .muscle:
                return [L10n.GeneralParameters.Section.Muscle.item1, L10n.GeneralParameters.Section.Muscle.item2]
            case .sensitivity:
                return [L10n.GeneralParameters.Section.Sensitivity.item1]
            case .detection:
                return [""]
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = L10n.GeneralParameters.Header.title
        configureTableView()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: - Tableview management
    
    func configureTableView () {
        tableView.tableFooterView = UIView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == SectionDescription.muscle.rawValue && dataManager.sensorType == .joystick {
            return 0
        } else {
            return  SectionDescription.init(rawValue: section)?.numberOfRows() ?? 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let frame = tableView.frame
        
        let title = UILabel (frame: CGRect (x: 0, y: 0, width: frame.size.width, height: 10))
        
        let textContent = NSMutableAttributedString(string: (SectionDescription.init(rawValue: section)?.title())!, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .bold)])
        
        title.attributedText = textContent
        title.numberOfLines = 0
        title.lineBreakMode = .byWordWrapping
        title.translatesAutoresizingMaskIntoConstraints = false
        
        
        let subTitle = UILabel (frame: CGRect (x: 0, y: 0, width: frame.size.width, height: 25))
        
        let textContent2 = NSMutableAttributedString(string: (SectionDescription.init(rawValue: section)?.subtitle())!, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .regular), NSAttributedString.Key.foregroundColor: UIColor (displayP3Red: 0.6, green: 0.6, blue: 0.6, alpha: 1)])
        
        subTitle.attributedText = textContent2
        subTitle.numberOfLines = 0
        subTitle.lineBreakMode = .byWordWrapping
        subTitle.translatesAutoresizingMaskIntoConstraints = false
        
        let headerView = UIView (frame: CGRect (x: 0, y: 0, width: frame.size.width, height: 50))
        headerView.addSubview(title)
        headerView.addSubview(subTitle)
        
        
        headerView.addConstraint(NSLayoutConstraint(item: title, attribute: .leading, relatedBy: .equal, toItem: headerView,
                                                    attribute: .leading, multiplier: 1, constant: 15))
        headerView.addConstraint(NSLayoutConstraint(item: title, attribute: .trailing, relatedBy: .equal, toItem: headerView,
                                                    attribute: .trailing, multiplier: 1, constant: -15))
        headerView.addConstraint(NSLayoutConstraint(item: title, attribute: .top, relatedBy: .equal, toItem: headerView,
                                                    attribute: .top, multiplier: 1, constant: 5))

        headerView.addConstraint(NSLayoutConstraint(item: subTitle, attribute: .leading, relatedBy: .equal, toItem: headerView,
                                                    attribute: .leading, multiplier: 1, constant: 15))
        headerView.addConstraint(NSLayoutConstraint(item: subTitle, attribute: .trailing, relatedBy: .equal, toItem: headerView,
                                                    attribute: .trailing, multiplier: 1, constant: -15))
        headerView.addConstraint(NSLayoutConstraint(item: subTitle, attribute: .top, relatedBy: .equal, toItem: title,
                                                    attribute: .bottom, multiplier: 1, constant: 5))

        headerView.backgroundColor = UIColor (displayP3Red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
        return headerView
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        var result: CGFloat = 60.0
        
        if section == SectionDescription.detection.rawValue {
            result = 80.0
        }
        if section == SectionDescription.muscle.rawValue && dataManager.sensorType == .joystick {
            result = 0.0
        }
        return result
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case SectionDescription.demo.rawValue:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "generalSwitchCell", for: indexPath) as? GeneralSwitchCell else {
                return UITableViewCell()
            }
            
            let text = NSMutableAttributedString(string: SectionDescription.demo.items()[indexPath.row],
                                                 attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16)])
            cell.label.attributedText = text
            cell.switchItem.isOn = dataManager.demoMode
            cell.switchItem.tag  = demoModeTag
            
            return cell
            
        case SectionDescription.sensor.rawValue:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "generalSegmentCell", for: indexPath) as? GeneralSegmentCell else {
                    return UITableViewCell()
                }
                
                let text = NSMutableAttributedString(string: SectionDescription.sensor.items()[indexPath.row],
                                                     attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16)])
                
                cell.label.attributedText = text
                
                cell.segmentItem.removeAllSegments()
                cell.segmentItem.insertSegment(withTitle: L10n.Parameters.Global.Sensor.muscle, at: 0, animated: false)
                cell.segmentItem.insertSegment(withTitle: L10n.Parameters.Global.Sensor.joystick, at: 1, animated: false)
                cell.segmentItem.insertSegment(withTitle: L10n.Parameters.Global.Sensor.button, at: 2, animated: false)
                
                switch dataManager.sensorType {
                case .buttons:
                    cell.segmentItem.selectedSegmentIndex = 2
                case .joystick:
                    cell.segmentItem.selectedSegmentIndex = 1
                default:
                    cell.segmentItem.selectedSegmentIndex = 0
                }
                
                cell.segmentItem.tag  = sensorTypeTag

                return cell
       
        case SectionDescription.muscle.rawValue:
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "generalSwitchCell", for: indexPath) as? GeneralSwitchCell else {
                return UITableViewCell()
            }
            
            let text = NSMutableAttributedString(string: SectionDescription.muscle.items()[indexPath.row],
                                                 attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16)])
            
            cell.label.attributedText = text
            cell.switchItem.isOn = indexPath.row == 0 ? dataManager.muscle1IsON : dataManager.muscle2IsON
            cell.switchItem.tag = indexPath.row
            
            return cell
            
        case SectionDescription.sensitivity.rawValue:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "generalSegmentCell", for: indexPath) as? GeneralSegmentCell else {
                return UITableViewCell()
            }
            
            let text = NSMutableAttributedString(string: SectionDescription.sensitivity.items()[indexPath.row],
                                                 attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16)])
            
            cell.label.attributedText = text
            
            cell.segmentItem.removeAllSegments()
            cell.segmentItem.insertSegment(withTitle: L10n.Generic.low, at: 0, animated: false)
            cell.segmentItem.insertSegment(withTitle: L10n.Generic.medium, at: 1, animated: false)
            cell.segmentItem.insertSegment(withTitle: L10n.Generic.high, at: 2, animated: false)
            
            switch dataManager.sensitivity {
            case .low:
                cell.segmentItem.selectedSegmentIndex = 0
            case .average:
                cell.segmentItem.selectedSegmentIndex = 1
            default:
                cell.segmentItem.selectedSegmentIndex = 2
            }
            cell.segmentItem.tag  = sensitivityTag

            return cell
            
        case SectionDescription.detection.rawValue:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "generalSliderCell", for: indexPath) as? GeneralSliderCell else {
                return UITableViewCell()
            }
            
            cell.sliderItem.value = Float (dataManager.threshold)
            
            let text = NSMutableAttributedString(string: cell.sliderItem.value.clean,
                                                 attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16)])
            
            cell.label.attributedText = text
            
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    
    // MARK: - User's actions

    @IBAction func onSwitchSelection(_ sender: UISwitch) {
        
        if sender.tag == demoModeTag {
            dataManager.demoMode = sender.isOn
            return
        }
        
        if sender.tag == 0 {
            dataManager.muscle1IsON = sender.isOn
        } else {
            dataManager.muscle2IsON = sender.isOn
        }
    }
    
    @IBAction func onSensitivitySelection(_ sender: UISegmentedControl) {
        
        if sender.tag == sensitivityTag {
            switch sender.selectedSegmentIndex {
            case 0:  dataManager.sensitivity = .low
            case 1:  dataManager.sensitivity = .average
            default: dataManager.sensitivity = .high
            }
        } else if sender.tag == sensorTypeTag {
            switch sender.selectedSegmentIndex {
            case 2:  dataManager.sensorType = .buttons
            case 1:  dataManager.sensorType = .joystick
            default: dataManager.sensorType = .muscles
            }
            tableView.reloadData()
        }
    }
    
   
    @IBAction func onThresholdSelection(_ sender: UISlider) {
        dataManager.threshold = Int (sender.value)
        tableView.reloadData()
    }
}
