//
//  AboutViewController
//  Baah Box
//
//  Copyright (C) 2017 – 2024 Orange SA
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

class AboutViewController: PrettyUITableViewController {
    private var cells: [CellType] = []
    private var appName = "BaahBox"
    var version: String = "1.0"
    
    var navTintColor: UIColor = UIColor.black {
        didSet {
            configureNavBar()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let buildVersion = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        
        if let buildVersion = buildVersion, let appVersion = appVersion {
            version  = "Version \(appVersion) (\(buildVersion))"
            
        }
        title = L10n.Settings.About.title
        
        tableView.tableLayoutSetup()
        tableView.tableFooterView = UIView()
        registerCell(identifier: "GenericInfoCell")
        registerCell(identifier: "GenericSectionCell")
        registerCell(identifier: "GenericHeaderCell")
        addCells()
    }
    
    override func viewWillAppear(_: Bool) {
            // configureSettingsNavBar()
    }
    
  
    private func addCells() {
        cells.append(.info)
        
        cells.append(.htmlSection(L10n.Settings.About.termsOfUse, "cgu"))
        cells.append(.htmlSection(L10n.Settings.About.legalNotices, "legal_notices"))
    }
    
        // MARK: - Table view data source
    
    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        cells.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch cells[indexPath.row] {
            case .header:
                let cell = tableView.dequeueReusableCell(withIdentifier: "GenericHeaderCell", for: indexPath)
                (cell as? GenericHeaderCell)?.configure(image: UIImage(named: "AppIcon"), backgroundColor: UIColor.black)
                return cell
                
            case .info:
                let cell = tableView.dequeueReusableCell(withIdentifier: "GenericInfoCell", for: indexPath)
                (cell as? GenericInfoCell)?.configure(title: appName,
                                                      topText: version,
                                                      bottomText: L10n.Settings.About.copyright)
                return cell
                
            case let .htmlSection(title, _):
                let cell = tableView.dequeueReusableCell(withIdentifier: "GenericSectionCell", for: indexPath)
                (cell as? GenericSectionCell)?.configure(text: title)
                return cell
        }
    }
    
    
        // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch cells[indexPath.row] {
            case let .htmlSection(title, fileName):
                presentWebView(title: title, fileName: fileName)
            default: break
        }
    }
    
    
    
    func configureNavBar() {
        if #available(iOS 13, *) {
            if let localNavigationBar = navigationController?.navigationBar {
                
                let standardAppearance = UINavigationBarAppearance()
                standardAppearance.backgroundColor = .white
                standardAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: navTintColor]
                
                let compactAppearance = UINavigationBarAppearance()
                compactAppearance.backgroundColor = .white
                compactAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: navTintColor]
                
                
                let scrollEdgeAppearance = UINavigationBarAppearance()
                scrollEdgeAppearance.backgroundColor = .white
                scrollEdgeAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: navTintColor]
                
                localNavigationBar.standardAppearance = standardAppearance
                localNavigationBar.compactAppearance = compactAppearance
                localNavigationBar.scrollEdgeAppearance = scrollEdgeAppearance
            }
        } else {
            navigationController?.barTextColor = navTintColor
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: navTintColor]
            navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: navTintColor]
        }
        navigationController?.tintColor = navTintColor
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.isHidden = false
        
    }
 
}

public extension UITableViewController {
    func registerCell(identifier: String) {
        let nib = UINib(nibName: identifier, bundle: Bundle.main)
        tableView.register(nib, forCellReuseIdentifier: identifier)
    }
}
