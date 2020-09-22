//
//  GameScene.swift
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
import SpriteKit

public protocol GameSceneDelegate: AnyObject{
    func onChanged(state: GameState)
}

extension GameSceneDelegate {
    func onChanged(state: GameState) {
        // nothing to do
    }
}

public protocol GameScene {
    var gameSceneDelegate: GameSceneDelegate? { get set }
    var state: GameState { get }
    
    func configure(title: UILabel, subtitle: UILabel, feedback: UILabel?, score: UILabel?, button: UIButtonBordered, delegate: GameSceneDelegate)
    func onButtonPressed()
    
}

