//
//  GameCell.swift
//  OrangeTrainingBox
//
//  Created by Balazs Kovesi on 23/10/2018.
//  Copyright © 2018 Orange. All rights reserved.
//

import UIKit

final class GameCell: UITableViewCell {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var iconWidth: NSLayoutConstraint!
    @IBOutlet weak var iconHeight: NSLayoutConstraint!
    @IBOutlet weak var colorView: UIView!
    
    func setImage(_ image: UIImage) {
        let imageRatio = image.size.width / image.size.height
        iconWidth.constant = iconHeight.constant * imageRatio
        icon.image = image
    }
    
    func setIconHeight(height: CGFloat) {
        iconHeight.constant = height
    }
}
