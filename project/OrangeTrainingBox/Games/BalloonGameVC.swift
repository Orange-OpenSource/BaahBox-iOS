//
//  GameViewController.swift
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
import SpriteKit

public protocol BalloonGameInteractable {
    func swelling ()
    func gameOver ()
}

class BalloonGameVC: SettableVC, BalloonGameInteractable {

    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var textLabel: UILabel!
    
    var scene: BalloonGameScene!
    var lastValue: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = L10n.Game.Balloon.title
        navTintColor = Asset.Colors.orange.color
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureScene()
        configureSkView()
        configureBottomView(showStartGame: true)
        setupNotificationCenter()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        scene = nil
        NotificationCenter.default.removeObserver(self)
        let skView = view as! SKView
        skView.presentScene(nil)
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    func configureSkView () {
        let skView = view as! SKView
        skView.ignoresSiblingOrder = true
        skView.showsFPS = false
        skView.showsNodeCount = false
        skView.presentScene(scene)
    }
    
    func configureScene () {
        scene = BalloonGameScene(size: CGSize(width: 1536, height: 2048))
        scene.gameDelegate = self
        scene.scaleMode = .aspectFill
    }
    
    func configureBottomView(showStartGame: Bool, replay: Bool = false) {
        startButton.isHidden = !showStartGame
        textLabel.isHidden = showStartGame
        let startText = replay ?  L10n.Game.reStart :  L10n.Game.start
        let text = NSMutableAttributedString(string: startText,
                                             attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 27)])
        
        text.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: NSRange(location: 0, length: text.length))
        if showStartGame {
            startButton.setAttributedTitle(text, for: .normal)
        }
    }
    
    
    
    @objc func onParameterUpdate() {
        // update parameters
    }
    
    
   
   
    
    @IBAction func onStartButtonPressed(_ sender: Any) {
        scene.isGameStarted = true
        configureBottomView(showStartGame: false)
    }
    
    // MARK: - BalloonGameInteractable protocol
    
    func swelling () {
        var secondLineText = L10n.Game.Balloon.Text.secondMuscle
        
        let text = NSMutableAttributedString(string: L10n.Game.Balloon.Text.first +  "\n",
                                             attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 27)])
       
        switch ParameterDataManager.sharedInstance.sensorType {
        case .joystick:
            secondLineText = L10n.Game.Balloon.Text.secondJoystick
        default:
            secondLineText = L10n.Game.Balloon.Text.secondMuscle
        }
        
        
        text.append(NSMutableAttributedString(string: secondLineText,
                                              attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 27, weight: .light)]))
        
        text.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: NSRange(location: 0, length: text.length))
        textLabel.attributedText = text
    }
    
    func gameOver() {
        let text = NSMutableAttributedString(string: L10n.Game.Balloon.Congrats.first + "\n",
                                             attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 27)])
        
        text.append(NSMutableAttributedString(string: L10n.Game.Balloon.Congrats.second,
                                              attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 27, weight: .light)]))
        text.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: NSRange(location: 0, length: text.length))
        textLabel.attributedText = text
        
        configureBottomView(showStartGame: true, replay: true)
    }
    
    
    // MARK: - Notification Center
    
    private func setupNotificationCenter() {
    //   Parameter update
        NotificationCenter.default.addObserver(self, selector: #selector(onParameterUpdate),
                                               name: NSNotification.Name(rawValue: L10n.Notif.Parameter.update),
                                               object: nil)
    }
 
}
