//
//  ButtonWithImageAndText.swift
//  OrangeTrainingBox
//
//  Created by Balazs Kovesi on 23/10/2018.
//  Copyright © 2018 Orange. All rights reserved.
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
            imageEdgeInsets = UIEdgeInsets(top: verticalMargin, left: horizontalMargin, bottom: verticalMargin, right: bounds.width - horizontalMargin - imageWidth)
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
