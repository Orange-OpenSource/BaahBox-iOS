//
//  GeneralParametersVC.swift
//  Baah Box
//
//  Copyright (C) 2017 – 2025 Orange SA
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
        case range = 3
        case sensitivity = 4
        case detection = 5
        
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
            case .range:
                return 2
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
            case .range:
                return L10n.GeneralParameters.Section.Range.title
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
            case .range:
                return L10n.GeneralParameters.Section.Range.subtitle
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
            case .range:
                return [L10n.GeneralParameters.Section.Range.item1]
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
        let nbRows = SectionDescription.init(rawValue: section)?.numberOfRows() ?? 0
        switch dataManager.sensorType {
        case .joystick, .analogJoystick:
            switch section
            {
            case  SectionDescription.demo.rawValue, SectionDescription.sensor.rawValue:
                return nbRows
            default:
                return 0
            }
        case .handle:
            switch section
            {
            case SectionDescription.detection.rawValue, SectionDescription.muscle.rawValue, SectionDescription.sensitivity.rawValue:
                return 0
                
            default:
                return nbRows
            }
        case .muscles:
            if section == SectionDescription.range.rawValue {
                return 0
            } else {
                return nbRows
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let frame = tableView.frame
        
        let title = UILabel (frame: CGRect (x: 0, y: 0, width: frame.size.width, height: 10))
        
        let textContent = NSMutableAttributedString(string: (SectionDescription.init(rawValue: section)?.title())!,
                                                    attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .bold)])
        
        title.attributedText = textContent
        title.numberOfLines = 0
        title.lineBreakMode = .byWordWrapping
        title.translatesAutoresizingMaskIntoConstraints = false
        
        
        let subTitle = UILabel (frame: CGRect (x: 0, y: 0, width: frame.size.width, height: 25))
        
        let textContent2 = NSMutableAttributedString(string: (SectionDescription.init(rawValue: section)?.subtitle())!,
                                                     attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .regular),
                                                                  NSAttributedString.Key.foregroundColor: UIColor (displayP3Red: 0.6, green: 0.6, blue: 0.6, alpha: 1)])
        
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
        
        var headerHeight: CGFloat = 60.0
        
        switch dataManager.sensorType {
        case .joystick, .analogJoystick:
            switch section
            {
            case SectionDescription.demo.rawValue, SectionDescription.sensor.rawValue:
                return headerHeight
            default:
                return 0
            }
        case .handle:
            switch section
            {
            case SectionDescription.detection.rawValue, SectionDescription.muscle.rawValue, SectionDescription.sensitivity.rawValue:
                return 0
            default:
                if section == SectionDescription.range.rawValue {
                    headerHeight = 80.0
                }
                return headerHeight
            }
        case .muscles:
            if section == SectionDescription.range.rawValue {
                return 0
            } else {
                if section == SectionDescription.detection.rawValue {
                    headerHeight = 80.0
                }
                return headerHeight
            }
        }
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
            cell.segmentItem.insertSegment(withTitle: L10n.Parameters.Global.Sensor.handle, at: 2, animated: false)
            cell.segmentItem.insertSegment(withTitle: L10n.Parameters.Global.Sensor.analogJoystick, at: 3, animated: false)
            
            switch dataManager.sensorType {
            case .analogJoystick:
                cell.segmentItem.selectedSegmentIndex = 3
            case .joystick:
                cell.segmentItem.selectedSegmentIndex = 1
            case .handle:
                cell.segmentItem.selectedSegmentIndex = 2
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
        
        case SectionDescription.range.rawValue:
            var identifier = "rangeUpperBoundCell"
            var titre = "Limite haute (entre 90° et 180°)"
            if indexPath.row == 0 {
                identifier = "rangeLowerBoundCell"
                titre = "Limite basse (entre 0° et 90°)"
            } else {
                
            }
            guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as?  GeneralSliderPlusCell else {
                return UITableViewCell()
            }
           
            let text = NSMutableAttributedString(string: titre,
                                                 attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16)])
            
            cell.title.attributedText = text
            cell.sliderItem.value = Float (indexPath.row == 0 ? dataManager.analogInputRangeForHandle.lowerBound: dataManager.analogInputRangeForHandle.upperBound)
            
            cell.sliderItem.tag = indexPath.row
            
            let value = L10n.GeneralParameters.Settings.angleValue(cell.sliderItem.value.clean)
            let val = NSMutableAttributedString(string: value,
                                                attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16),
                                                             NSAttributedString.Key.foregroundColor: Asset.Colors.pinky.color])
            cell.value.attributedText = val
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
            case 3:
                dataManager.sensorType = .analogJoystick
            case 2:
                dataManager.sensorType = .handle
            case 1:
                dataManager.sensorType = .joystick
            default:
                dataManager.sensorType = .muscles
            }
            tableView.reloadData()
        }
    }
    
    
    @IBAction func onBoundSelection(_ sender: UISlider) {
        if sender.tag == 0 {
            let newRange: ClosedRange<Int> = Int(sender.value)...dataManager.analogInputRangeForHandle.upperBound
            dataManager.analogInputRangeForHandle = newRange
        } else {
            let newRange: ClosedRange<Int> = dataManager.analogInputRangeForHandle.lowerBound...Int(sender.value)
            dataManager.analogInputRangeForHandle = newRange
        }
        tableView.reloadData()
    }
    
    
    @IBAction func onThresholdSelection(_ sender: UISlider) {
        dataManager.threshold = Int (sender.value)
        tableView.reloadData()
    }
}
