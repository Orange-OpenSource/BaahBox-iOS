//
//  StarGameVC.swift
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
    
public protocol StarGameInteractable {
    func shoving()
    func swelling()
    func win()
    func configureScreen(forState state: GameState)
}

class StarGameVC: SettableVC, StarGameInteractable {
   
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var subHeaderLabel: UILabel!
    @IBOutlet weak var feedbackLabel: UILabel!
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    var scene: StarGameScene?
    var lastValue: Int = 0
        
    override func viewDidLoad() {
        super.viewDidLoad()
        title = L10n.Game.Star.title
        navTintColor = Asset.Colors.violet.color
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureScene()
        configureSkView()
        configureHeaders()
        configureScreen(forState: .notStarted)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        scene = nil
        NotificationCenter.default.removeObserver(self)
        let skView = view as! SKView
        skView.presentScene(nil)
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }

    func configureHeaders() {
        headerLabel.text = L10n.Game.Star.header
        switch ParameterDataManager.sharedInstance.sensorType {
        case .joystick:
            subHeaderLabel.text = L10n.Game.Star.subHeaderJoystick
        default:
            subHeaderLabel.text = L10n.Game.Star.subHeaderMuscle
        }
    }

    func configureSkView() {
        let skView = self.view as! SKView
        skView.ignoresSiblingOrder = true
        skView.showsFPS = false
        skView.showsNodeCount = false
        skView.presentScene(scene)
    }
    
    func configureScene() {
        scene = StarGameScene(size: CGSize(width: 1536, height: 2048))
        scene?.gameDelegate = self
        scene?.scaleMode = .aspectFill
        //scene.size = self.node.size
    }
    
    func configureScreen(forState state: GameState) {
        switch state {
        case .notStarted:
            navigationController?.setNavigationBarHidden(false, animated: true)
          //  scene?.startStarAnimation()
            scene?.isGameStarted = false
            headerLabel.isHidden = false
            subHeaderLabel.isHidden = false
            feedbackLabel.isHidden = true
            startButton.isHidden = false
            resetButton.isHidden = true
            stopButton.isHidden = true
            configureBottomView()
        case .onGoing:
            navigationController?.setNavigationBarHidden(true, animated: true)
         //   scene?.stopStarAnimation()
            scene?.isGameStarted = true
            headerLabel.isHidden = true
            subHeaderLabel.isHidden = true
            feedbackLabel.isHidden = false
            startButton.isHidden = true
            stopButton.isHidden = false
            resetButton.isHidden = true
        case .won:
          //  scene?.stopStarAnimation()
            headerLabel.isHidden = true
            subHeaderLabel.isHidden = true
            feedbackLabel.isHidden = false
            startButton.isHidden = true
            stopButton.isHidden = true
            resetButton.isHidden = false
            scene?.isGameStarted = false
        default:
            print("should not happen")
        }
    }

    func configureBottomView() {
        let text = NSMutableAttributedString(string: L10n.Game.start,
                                             attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 27)])
        
        text.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: NSRange(location: 0, length: text.length))
        startButton.setAttributedTitle(text, for: .normal)
        
        resetButton.setTitle(L10n.Game.reStart, for: .normal)
        stopButton.setTitle(L10n.Game.stop, for: .normal)
    }
    
    
    @IBAction func onStartButtonPressed(_ sender: Any) {
        configureScreen(forState: .onGoing)
    }
    
    @IBAction func onResetButtonPressed(_ sender: Any) {
        configureScreen(forState: .notStarted)
    }

    @IBAction func onStopButtonPressed(_ sender: Any) {
        configureScreen(forState: .notStarted)
    }
    
    // =====================================
    // MARK: - StarGameInteractable protocol
    // =====================================
    
    func shoving () {
        feedbackLabel.isHidden = true
    }
    
    func swelling () {
        let text = NSMutableAttributedString(string: L10n.Game.Star.Text.keepGoing,
                                             attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 32
                                                )])
        feedbackLabel.attributedText = text
        feedbackLabel.isHidden = false
    }
    
    func win() {
        let text = NSMutableAttributedString(string: L10n.Game.Star.Text.congrats + "\n",
                                             attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 60)])
        
        text.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: NSRange(location: 0, length: text.length))
        feedbackLabel.attributedText = text
        configureScreen(forState: .won)
    }
}
