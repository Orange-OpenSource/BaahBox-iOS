//
//  MainParametersTVC.swift
//  Baah Box
//
//  Copyright (C) 2017 – 2020 Orange SA
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

class MainParametersVC: GameVC, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    enum SectionDescription: Int {
        case connection = 0
        case general = 1
        case games = 2
        
        var numberOfRows: Int {
            switch self {
            case .connection:
                return 1
            case .general:
                return 1
            case .games:
                return 3
            }
        }
        
        var title: String {
            switch self {
            case .connection:
                return " "
            case .general:
                return " "
            case .games:
                return L10n.MainParameters.Games.title
            }
        }
        
        var subtitle: [String] {
            switch self {
            case .connection:
                return [L10n.MainParameters.connection]
            case .general:
                return [L10n.MainParameters.general]
            case .games:
                return [L10n.MainParameters.Games.sheep, L10n.MainParameters.Games.spaceShip, L10n.MainParameters.Games.taud]
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        title = L10n.MainParameters.Header.title
        NotificationCenter.default.addObserver(self, selector: #selector(peripheralDisconnected(_:)),
                                               name: NSNotification.Name(rawValue: L10n.Notif.Ble.disconnection), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func configureNavBar() {
        navigationController?.tintColor = navTintColor
        navigationController?.barTextColor = navTintColor
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: navTintColor]
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: navTintColor]
        
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.isHidden = false
    }
    
    @objc func onDone(sender: UIBarButtonItem) {
       navigationController?.popViewController(animated: true)
    }
    
    func configureTableView () {
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    // MARK: - Table view data source

      func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

      func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SectionDescription(rawValue: section)?.numberOfRows ?? 0
    }

     func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let frame = tableView.frame
        
        let title = UILabel(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: 10))
        
        let textContent = NSMutableAttributedString(string: (SectionDescription.init(rawValue: section)?.title)!,
                                                    attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .bold)])
        
        title.attributedText = textContent
        title.numberOfLines = 0
        title.lineBreakMode = .byWordWrapping
        title.translatesAutoresizingMaskIntoConstraints = false
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: 50))
        headerView.addSubview(title)

        headerView.addConstraint(NSLayoutConstraint(item: title, attribute: .leading, relatedBy: .equal,
                                                     toItem: headerView, attribute: .leading, multiplier: 1, constant: 15))
        headerView.addConstraint(NSLayoutConstraint(item: title, attribute: .trailing, relatedBy: .equal,
                                                     toItem: headerView, attribute: .trailing, multiplier: 1, constant: -15))
        headerView.addConstraint(NSLayoutConstraint(item: title, attribute: .top, relatedBy: .equal,
                                                     toItem: headerView, attribute: .top, multiplier: 1, constant: 5))
        
        headerView.backgroundColor = UIColor(displayP3Red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
        return headerView
    }
    
     func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case SectionDescription.connection.rawValue:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "mainParameterCell", for: indexPath) as? MainParameterCell else {
                return UITableViewCell()
            }
            
            cell.headerLabel.text = SectionDescription.connection.subtitle.first
            
            let text = NSMutableAttributedString(string: btManager.getCurrentPeripheralName(),
                                             attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14),
                                                          NSAttributedString.Key.foregroundColor: UIColor(displayP3Red: 0.6,
                                                                                        green: 0.6, blue: 0.6, alpha: 1)])
            
            cell.boxLabel.attributedText = text
            
            if btManager.getCurrentPeripheralName() == "" {
                cell.accessoryType = .disclosureIndicator
            } else {
                cell.accessoryType = .none
            }
            return cell
            
        case SectionDescription.general.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: "basicCell", for: indexPath)
            cell.textLabel?.text = SectionDescription.general.subtitle.first
            return cell
            
        case SectionDescription.games.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: "basicCell", for: indexPath)
            cell.textLabel?.text = SectionDescription.games.subtitle[indexPath.row]
            return cell
        default:
            return UITableViewCell()
        }
    }
    
      func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.section {
        case SectionDescription.connection.rawValue:
          
            if btManager.getBTState() == .poweredOn {
                performSegue(withIdentifier: "toConnectionlPanel", sender: nil)
            } else {
                presentBLEConnectionPopup()
            }
            

        case SectionDescription.general.rawValue:
            performSegue(withIdentifier: "toGeneralPanel", sender: nil)

        case SectionDescription.games.rawValue:
            switch indexPath.row {
            case 0:
                performSegue(withIdentifier: "toSheepPanel", sender: nil)
            case 1:
                performSegue(withIdentifier: "toSpaceShipPanel", sender: nil)
            case 2:
                performSegue(withIdentifier: "toTaudPanel", sender: nil)
            default:
                break
            }
            
        default:
            break
        }
    }
    
    @objc func peripheralDisconnected(_ notification: Notification) {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

}
