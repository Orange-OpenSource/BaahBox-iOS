    //
    //  PrettyUITableViewController
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

open class PrettyUITableViewController: UITableViewController {
    var backgroundHeaderView: UIView!
    
    func createBackgroundHeaderView() {
        backgroundHeaderView = UIView()
        tableView.addSubview(backgroundHeaderView)
        tableView.sendSubviewToBack(backgroundHeaderView)
    }
    
    func updateLayout(offset: CGFloat, height: CGFloat) {
        let newY = min(0, offset)
        let newWidth = view.frame.width
        let newHeight = -newY + height
        if let backgroundHeaderView = backgroundHeaderView {
            backgroundHeaderView.frame = CGRect(x: 0, y: newY, width: newWidth, height: newHeight)
            tableView.sendSubviewToBack(backgroundHeaderView)
        }
    }
    
    override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let indexPath = IndexPath(row: 0, section: 0)
        if let view = tableView.cellForRow(at: indexPath)?.contentView {
            backgroundHeaderView?.backgroundColor = view.backgroundColor ?? UIColor.black
            updateLayout(offset: tableView.contentOffset.y, height: view.frame.height)
        }
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        createBackgroundHeaderView()
    }
}
