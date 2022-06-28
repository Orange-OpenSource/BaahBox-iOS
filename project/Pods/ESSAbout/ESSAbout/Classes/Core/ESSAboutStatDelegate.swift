/*
 *
 * ESSAbout
 *
 * File name:   ESSAboutStatDelegate.swift
 * Version:     2.1.0
 * Created:     04/10/2016
 * Created by:  Julien GALHAUT
 *
 * Copyright (C) 2016 Orange
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

import Foundation

@objc public protocol ESSAboutStatDelegate {
    func componentDidShowView(_ withName: String)
    func componentDidPerformEvent(_ withName: String)
}

