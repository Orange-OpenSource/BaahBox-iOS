//
//  BTHeaderCell.swift
//  Orange Training Box
//
//  Copyright © 2017 Orange. All rights reserved.
//

import UIKit

class BTHeaderCell: UITableViewCell {
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    func configure() {
        var text = NSMutableAttributedString(string: L10n.Ble.Connection.header,
                                             attributes: [NSAttributedString.Key.font:  UIFont.boldSystemFont(ofSize: 24)])
        headerLabel.attributedText = text
        
        text = NSMutableAttributedString(string: L10n.Ble.Connection.descritpion,
                                         attributes: [NSAttributedString.Key.font:  UIFont.systemFont(ofSize: 14),
                                                      
                                                      NSAttributedString.Key.foregroundColor:UIColor(displayP3Red: 0.6, green: 0.6, blue: 0.6, alpha: 1)])
        
        descriptionLabel.attributedText = text
        backgroundColor = UIColor (displayP3Red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
        isUserInteractionEnabled = false
    }
}
