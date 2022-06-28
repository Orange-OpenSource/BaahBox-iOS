/*
 *
 * ESSAbout
 *
 * File name:   UIFont+ESSContentSize.swift
 * Version:     2.2.0
 * Created:     04/10/2016
 * Created by:  Julien GALHAUT
 *
 * Copyright (C) 2017 Orange
 *
 * This software is confidential and proprietary information of Orange.
 * You shall not disclose such Confidential Information and shall use it only in
 * accordance with the terms of the agreement you entered into.
 * Unauthorized copying of this file, via any medium is strictly prohibited.
 *
 * If you are Orange employee you shall use this software in accordance with
 * the Orange Source Charter ( http://opensource.itn.ftgroup/index.php/Orange_Source ).
 *
 */

import UIKit

class ESSAboutHeaderCell: UITableViewCell {
    
    
    static let reuseIdentifier = "ESSAboutHeaderCell"
    
    @IBOutlet weak var appNameLabel: UILabel!
    @IBOutlet weak var appVersionLabel: UILabel!
    @IBOutlet weak var appCopyrightLabel: UILabel!
    
    @IBOutlet weak var orangeLogoImageView: UIImageView!
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var header: UIView!
    
    
    override func awakeFromNib() {
    }
    
    
    
}

