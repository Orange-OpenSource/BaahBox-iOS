//
//  GameViewController.swift
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

class BalloonGameVC: GameVC, GameSceneDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var feedbackLabel: UILabel!
    @IBOutlet weak var button: UIButtonBordered!
    
    var scene: BalloonGameScene!
    var lastValue: Int = 0
    
    // =======================
    // MARK: - View Lifecycle
    // =======================
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = L10n.Game.Balloon.title
        navTintColor = Asset.Colors.orange.color
        if #available(iOS 13, *) {
            if let navFont = UIFont(name: ".SFCompactText-Regular", size: 18) {
                let navBarAttributesDictionary  = [NSAttributedString.Key.font: navFont]
                
                self.navigationController?.navigationBar.standardAppearance.titleTextAttributes = navBarAttributesDictionary
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureScene()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        scene = nil
        super.viewWillDisappear(animated)
    }
    
    // ===============
    // MARK: - Scene
    // ===============
    
    func configureScene () {
        scene = BalloonGameScene(size:CGSize(width: 1536, height: 2048))
        scene?.configure(title: titleLabel, subtitle: subtitleLabel, feedback: feedbackLabel, score: nil, button: button, delegate: self)
        scene.scaleMode = .aspectFill
        let skView = configureSkView()
        skView?.presentScene(scene)
    }
    
    // MARK: - User's interactions
    
    @IBAction func onButtonPressed(_ sender: Any) {
        scene?.onButtonPressed()
    }
        
    // =================
    // MARK: - Settings
    // =================
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
}
