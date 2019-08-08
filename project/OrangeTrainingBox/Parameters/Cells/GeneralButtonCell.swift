//
//  GeneralButtonCell.swift
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

class GeneralButtonCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    
    func configure(activeButton: Bool) {
        let textContent = NSMutableAttributedString(string: L10n.Generic.disconnect, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .bold), NSAttributedString.Key.foregroundColor: activeButton ? UIColor.red: UIColor.lightGray])
        titleLabel.attributedText = textContent
        isHidden = false
        isUserInteractionEnabled = activeButton
    }
}
