//
//  UIViewController+WebView
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

public extension UIViewController {
    func presentWebView(title: String, fileName: String) {
        let storyboard = UIStoryboard(name: "Settings", bundle: Bundle.main)
        let viewController = storyboard.instantiateViewController(withIdentifier: "GenericWebViewController")
        if let genericWebViewController = viewController as? GenericWebViewController {
            genericWebViewController.title = title
            genericWebViewController.fileName = fileName
        }
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.plain, target: nil, action: nil)
        navigationController?.pushViewController(viewController, animated: true)
    }
}
