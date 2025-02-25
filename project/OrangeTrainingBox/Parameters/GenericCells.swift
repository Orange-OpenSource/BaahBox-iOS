//
//  GenericCells
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

public enum CellType {
    case header
    case info
    case htmlSection(String, String)
}

public class GenericHeaderCell: UITableViewCell {
    @IBOutlet var headerImage: UIImageView!

    public func configure(image: UIImage?, backgroundColor: UIColor) {
        headerImage.image = image
        headerImage.backgroundColor = backgroundColor
        contentView.backgroundColor = backgroundColor
    }
}

public class GenericInfoCell: UITableViewCell {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var topTextLabel: UILabel!
    @IBOutlet var bottomTextLabel: UILabel!

    public func configure(title: String, topText: String?, bottomText: String) {
        titleLabel.text = title
        topTextLabel.text = topText
        bottomTextLabel.text = bottomText
    }
}


public class GenericSectionCell: UITableViewCell {
    @IBOutlet var sectionTitleLabel: UILabel!

    public func configure(text: String) {
        sectionTitleLabel.text = text
    }
}
