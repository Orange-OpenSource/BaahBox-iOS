//
//  BTCell.swift
//  Orange Training Box
//
//  Copyright © 2017 Orange. All rights reserved.
//

import UIKit
import CoreBluetooth

class BTCell: UITableViewCell {

    @IBOutlet weak var checkImage: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    func configure (with peripheralName: String, shouldShowTick: Bool) {
        
        let text = NSMutableAttributedString(string: peripheralName,
                                             attributes: [NSAttributedString.Key.font:  UIFont.systemFont(ofSize: 20)])
        
        label.attributedText = text
        checkImage.isHidden = !shouldShowTick
        backgroundColor  = UIColor.white
    }
}
