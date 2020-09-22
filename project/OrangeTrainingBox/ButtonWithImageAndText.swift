//
//  ButtonWithImageAndText.swift
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

class ButtonWithImageAndText: UIButton {
    
    var imageRatioWidthHeight: CGFloat = 1
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if imageView != nil {
            let horizontalMargin: CGFloat = 5
            let verticalMargin: CGFloat = 10
            let imageHeight = bounds.height - 2 * verticalMargin
            let imageWidth = imageHeight * imageRatioWidthHeight
            imageEdgeInsets = UIEdgeInsets(top: verticalMargin, left: horizontalMargin, bottom: verticalMargin,
                                           right: bounds.width - horizontalMargin - imageWidth)
            if var titleFrame = titleLabel?.frame {
                titleFrame.origin.x = 2 * horizontalMargin + imageWidth
                titleFrame.size.width = bounds.width - 3 * horizontalMargin - imageWidth
                titleLabel?.frame = titleFrame
            }
        }
    }
    
    func setImage(_ image: UIImage) {
        setImage(image, for: .normal)
        imageRatioWidthHeight = image.size.width / image.size.height
        layoutSubviews()
    }
    
    func setTitle(_ title: String) {
        setTitle(title, for: .normal)
    }
}
