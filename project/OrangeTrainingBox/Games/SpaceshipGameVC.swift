//
//  SpaceshipGameVC.swift
//  Orange Training Box
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

public protocol SpaceShipGameInteractable {
    func collisionOccured()
    func gameOver()
    func configureScreen(forState state: GameState)
    func refreshScore()
}

class SpaceshipGameVC: SettableVC, SpaceShipGameInteractable {

    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var stopButton: UIButtonBordered!
    
    @IBOutlet weak var lifeView: UIView!
    var scene: SpaceshipGameScene?
    var lastValue: Int = 0
    var lifeViews: [UIImageView] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        title = L10n.Game.Space.title
        navTintColor = Asset.Colors.blueGreen.color
        ParameterDataManager.sharedInstance.muscle1IsON = true
        ParameterDataManager.sharedInstance.muscle2IsON = true
        
        stopButton.setTitle(L10n.Game.stop, for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureScene()
        configureSkView()
        configureScreen(forState: .notStarted)
        showLifeViews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        scene?.gameOver()
        scene = nil
        let skView = view as! SKView
        skView.presentScene(nil)
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
   
    func configureScene() {
        scene = SpaceshipGameScene(size:CGSize(width: 1536, height: 2048))
        scene!.gameDelegate = self
        scene!.scaleMode = .aspectFill
    }
    
    func configureSkView () {
        let skView = view as! SKView
        skView.ignoresSiblingOrder = true
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.presentScene(scene)
    }
    
   
    private func showScore() {
        guard let scene = scene else { return }
        scoreLabel.text = "Score: \(scene.score)"
    }
    
    func refreshScore() {
        guard scene != nil else { return }
            showScore()
            showLifeViews()
    }
    
    private func showLifeViews() {
        for lifeView in lifeViews {
            lifeView.removeFromSuperview()
        }
        lifeViews = []
        let lifeWidth: CGFloat = 45.0
        let padding: CGFloat = 15.0
        let lifeHeight: CGFloat = 45.0
        let lifeWidthPadded: CGFloat = lifeWidth + padding
        
        guard let lifeCount = scene?.lifes else { return }
        for i in 0 ..< lifeCount {
            let lifeImage = UIImage(named: Asset.Games.SpaceshipGame.spaceLife.name)
            let lifeImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: lifeWidth, height: lifeHeight))
            lifeImageView.image = lifeImage
            lifeImageView.contentMode = .scaleAspectFill
            
            lifeImageView.center = CGPoint(x: CGFloat(i) * lifeWidthPadded + lifeWidthPadded/2, y: lifeHeight/2)
            lifeView.addSubview(lifeImageView)
            lifeViews.append(lifeImageView)
        }
    }
    
    func configureButtonWithText (_ text: String = L10n.Game.start) {
        let text = NSMutableAttributedString(string: text,
                                             attributes: [NSAttributedString.Key.font:  UIFont.boldSystemFont(ofSize: 27)])
        text.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: NSRange(location: 0, length: text.length))
        startButton.setAttributedTitle(text, for: .normal)
    }
    
    
    @IBAction func onStopButtonPressed(_ sender: Any) {
        switch scene!.gameState {
        case .onGoing:
            scene?.gameOver()
        default:
            print("stop button pressed, should not happen")
        }
    }
    
    @IBAction func onStartButtonPressed(_ sender: Any) {
        guard let scene = scene else { return }
       
        switch scene.gameState {
        case .notStarted:
            scene.initGame()
            configureScreen(forState: .onGoing)
            scene.runGame()
        case .halted:
            configureScreen(forState: .onGoing)
            scene.runGame()
        case .lost:
            scene.initGame()
            configureScreen(forState: .onGoing)
            scene.runGame()
        default:
            print("should not happen")
        }
    }
    
    // ==========================================
    // MARK: - SpaceShipGameInteractable protocol
    // ==========================================
    
    func configureScreen(forState state: GameState) {
        
        switch state {
        case .notStarted:
            navigationController?.setNavigationBarHidden(true, animated: true)
            configureButtonWithText(L10n.Game.start)
            startButton.isHidden = false
            scoreLabel.isHidden = true
            stopButton.isHidden = true

            scene?.startSpaceShipAnimation()
            refreshScore()
            
        case .onGoing:
            scene?.stopSpaceShipAnimation()
            navigationController?.setNavigationBarHidden(true, animated: true)
            scoreLabel.isHidden  = false
            startButton.isHidden = true
            stopButton.isHidden = false
            refreshScore()
            
        case .halted:
            navigationController?.setNavigationBarHidden(false, animated: true)
            configureScreen(forState: .onGoing)
            scene?.runGame()

        case .lost:
            navigationController?.setNavigationBarHidden(false, animated: true)
            configureButtonWithText (L10n.Game.reStart)
            startButton.isHidden = false
            stopButton.isHidden = true

            refreshScore()
            
        case .won:
            print("WON : should not happen")
        }
    }
    
    func collisionOccured() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            self.configureScreen(forState: .halted)
        })
    }
    
    func gameOver() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            self.configureScreen(forState: .lost)
        })
    }
}


