//
//  BTHeaderCell.swift
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

class BTHeaderCell: UITableViewCell {
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    func configure() {
        var text = NSMutableAttributedString(string: L10n.Ble.Connection.header,
                                             attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 24)])
        headerLabel.attributedText = text
        
        text = NSMutableAttributedString(string: L10n.Ble.Connection.description,
                                         attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14),
                                         NSAttributedString.Key.foregroundColor: UIColor(displayP3Red: 0.6, green: 0.6, blue: 0.6, alpha: 1)])
        
        descriptionLabel.attributedText = text
        backgroundColor = UIColor (displayP3Red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
        isUserInteractionEnabled = false
    }
}
