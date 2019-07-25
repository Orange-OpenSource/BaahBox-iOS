//
//  GeneralButtonCell.swift
//  OrangeTrainingBox

//  Copyright © 2018 Orange. All rights reserved.
//

import UIKit

class GeneralButtonCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    
    func configure (activeButton : Bool) {
        let textContent = NSMutableAttributedString(string: L10n.Generic.disconnect, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .bold), NSAttributedString.Key.foregroundColor : activeButton ? UIColor.red : UIColor.lightGray])
        titleLabel.attributedText = textContent
        isHidden = false
        isUserInteractionEnabled = activeButton
    }
}
