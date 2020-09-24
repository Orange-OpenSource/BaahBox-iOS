//
//  GameCell.swift
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

final class GameCell: UITableViewCell {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var iconWidth: NSLayoutConstraint!
    @IBOutlet weak var iconHeight: NSLayoutConstraint!
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var musclesStackView: UIStackView!
    
    let capteurImage = UIImage(named: Asset.Dashboard.capteur.name)
    
    func setImage(_ image: UIImage) {
        let imageRatio = image.size.width / image.size.height
        iconWidth.constant = iconHeight.constant * imageRatio
        icon.image = image
    }
    
    func setIconHeight(height: CGFloat) {
        iconHeight.constant = height
    }
    
    func configureMusclesStackView(nbMuscles: Int) {
        emptyMusclesStackView()
        for _ in 0..<nbMuscles {
            let capteurView = UIImageView(image: capteurImage)
            capteurView.heightAnchor.constraint(equalToConstant: 25.0).isActive = true
            capteurView.widthAnchor.constraint(equalToConstant: 17.0).isActive = true
            musclesStackView.addArrangedSubview(capteurView)
        }
    }
    
    func emptyMusclesStackView() {
        for view in musclesStackView.arrangedSubviews {
            view.removeFromSuperview()
        }
    }
}
