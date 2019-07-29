//
//  SheepGameParameterVC.swift
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

class SheepGameParameterVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        title = L10n.Parameters.Sheep.title
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
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return " "
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "fenceCell", for: indexPath) as?  GeneralSliderPlusCell else {
                return UITableViewCell()
            }
            
            let text = NSMutableAttributedString(string: L10n.Parameters.Sheep.fence,
                                                attributes: [NSAttributedString.Key.font:  UIFont.boldSystemFont(ofSize: 16)])
            
            cell.title.attributedText = text
            cell.sliderItem.value = Float (ParameterDataManager.sharedInstance.numberOfFences)
            
            let val = NSMutableAttributedString(string: cell.sliderItem.value.clean,
                                                 attributes: [NSAttributedString.Key.font:  UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor : Asset.Colors.pinky.color])
            
            cell.value.attributedText = val
            return cell
            
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "speedCell", for: indexPath) as?  GeneralSegmentCell else {
                return UITableViewCell()
            }
            
            let text = NSMutableAttributedString(string: L10n.Parameters.Sheep.speed,
                                                 attributes: [NSAttributedString.Key.font:  UIFont.boldSystemFont(ofSize: 16)])
            cell.label.attributedText = text
            
            cell.segmentItem.removeAllSegments()
            cell.segmentItem.insertSegment(withTitle: L10n.Generic.slow, at: 0, animated: false)
            cell.segmentItem.insertSegment(withTitle: L10n.Generic.medium, at: 1, animated: false)
            cell.segmentItem.insertSegment(withTitle: L10n.Generic.high, at: 2, animated: false)
            
            switch ParameterDataManager.sharedInstance.fenceVelocity {
                case .slow:
                cell.segmentItem.selectedSegmentIndex = 0
                case .average:
                cell.segmentItem.selectedSegmentIndex = 1
                default:
                cell.segmentItem.selectedSegmentIndex = 2
            }
            
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    
    // MARK: - User's actions
    
    @IBAction func onSpeedSelection(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:  ParameterDataManager.sharedInstance.fenceVelocity = .slow
        case 1:  ParameterDataManager.sharedInstance.fenceVelocity = .average
        default: ParameterDataManager.sharedInstance.fenceVelocity = .fast
        }
    }
    
    @IBAction func onFenceSelection(_ sender: UISlider) {
        ParameterDataManager.sharedInstance.numberOfFences = Int (sender.value)
        tableView.reloadData()
    }
}
