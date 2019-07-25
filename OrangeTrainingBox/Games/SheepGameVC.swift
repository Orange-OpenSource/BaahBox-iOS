//
//  SheepGameVC.swift
//  Orange Training Box
//
//  Created by Frederique Pinson on 21/08/2018.
//  Copyright © 2018 Orange. All rights reserved.
//

import UIKit
import SpriteKit

public protocol SheepGameInteractable {
    func collisionOccured ()
    func jumpInProgress ()
    func successfullJump ()
    func walking ()
    func gameOver ()
}

class SheepGameVC: SettableVC, SheepGameInteractable {

    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!

    @IBOutlet weak var scoreLabel: UILabel!
    
    var displayTimer: Timer!
    var scene: SheepGameScene!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = L10n.Game.Sheep.title
        navTintColor = Asset.Colors.pinky.color
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureScene()
        configureSkView()
        configureBottomView()
        setupNotificationCenter()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        scene.gameOver()
        scene = nil
        NotificationCenter.default.removeObserver(self)
        let skView = view as! SKView
        skView.presentScene(nil)
    }

    func configureScene () {
        scene = SheepGameScene (size: CGSize(width: 1536, height: 2048))
        scene.gameDelegate = self
        scene.scaleMode = .aspectFill
    }
    
    func configureSkView () {
        let skView = view as! SKView

        skView.ignoresSiblingOrder = true
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.presentScene(scene)
    }
    
    func configureBottomView () {
        var text = NSMutableAttributedString(string: L10n.Game.Sheep.Text.Jump.first + "\n",
                                             attributes: [NSAttributedString.Key.font:  UIFont.boldSystemFont(ofSize: 27)])
        
        text.append(NSMutableAttributedString(string: L10n.Game.Sheep.Text.Jump.second,
                                              attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 27, weight: .light)]))
        
        text.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: NSRange(location: 0, length: text.length))
        textLabel.attributedText = text
        
        configureScore(with: 0)
        
        text = NSMutableAttributedString(string: L10n.Game.start,
                                        attributes: [NSAttributedString.Key.font:  UIFont.boldSystemFont(ofSize: 27)])
        
        text.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: NSRange(location: 0, length: text.length))
        startButton.setAttributedTitle(text, for: .normal)
        startButton.isHidden = false
        
    }
    
    func configureScore (with score: Int) {
        
        let text : NSMutableAttributedString
        
        switch score {
        case 0:
            if scene.gameObjective  == 1 {
                text = NSMutableAttributedString(string: L10n.Game.Sheep.Score.Start.one,
                    attributes: [NSAttributedString.Key.font:  UIFont.systemFont(ofSize: 20, weight: .light)])
            } else {
                text = NSMutableAttributedString(string: L10n.Game.Sheep.Score.Start.many(scene.gameObjective),
                    attributes: [NSAttributedString.Key.font:  UIFont.systemFont(ofSize: 20, weight: .light)])
            }
            
        case 1:
            text = NSMutableAttributedString(string: L10n.Game.Sheep.Score.Pending.one(scene.gameObjective - scene.successfullJumps),
                attributes: [NSAttributedString.Key.font:  UIFont.systemFont(ofSize: 20, weight: .light)])
            
        default:
            text = NSMutableAttributedString(string: L10n.Game.Sheep.Score.Pending.many(scene.successfullJumps, scene.gameObjective - scene.successfullJumps),
                attributes: [NSAttributedString.Key.font:  UIFont.systemFont(ofSize: 20, weight: .light)])
        }
        
        text.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: NSRange(location: 0, length: text.length))
        
        scoreLabel.attributedText = text
        scoreLabel.isHidden = false
    }
    
    override var shouldAutorotate: Bool {
        return false
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    // MARK: - SheepGameInteractable protocol
    
    func collisionOccured() {
        var text = NSMutableAttributedString(string: L10n.Game.oops + "\n",
                                             attributes: [NSAttributedString.Key.font:  UIFont.boldSystemFont(ofSize: 27)])
        
        text.append(NSMutableAttributedString(string: L10n.Game.tryAgain,
                                              attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 27, weight: .light)]))
        
        text.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: NSRange(location: 0, length: text.length))
        textLabel.attributedText = text
        
        text = NSMutableAttributedString(string: L10n.Game.reStart + "\n",
                                         attributes: [NSAttributedString.Key.font:  UIFont.boldSystemFont(ofSize: 27)])
        
        text.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: NSRange(location: 0, length: text.length))
        
        startButton.setAttributedTitle(text, for: .normal)
        startButton.isHidden = false

    }
    
    func walking() {
        let text = NSMutableAttributedString(string: L10n.Game.Sheep.Text.Jump.first + "\n",
                                             attributes: [NSAttributedString.Key.font:  UIFont.boldSystemFont(ofSize: 27)])
       
        text.append(NSMutableAttributedString(string: L10n.Game.Sheep.Text.Jump.second,
                                              attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 27, weight: .light)]))
        text.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: NSRange(location: 0, length: text.length))
        textLabel.attributedText = text
    }
    
    func jumpInProgress () {
        let text = NSMutableAttributedString(string: L10n.Game.hop + "\n",
                                             attributes: [NSAttributedString.Key.font:  UIFont.boldSystemFont(ofSize: 27)])
        
        text.append(NSMutableAttributedString(string: L10n.Game.wellDone,
                                              attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 27, weight: .light)]))
        
        text.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: NSRange(location: 0, length: text.length))
        textLabel.attributedText = text
        
    }

    func successfullJump () {
        configureScore(with: scene.successfullJumps)
    }
    
    func gameOver() {
        
        scoreLabel.isHidden = true
        
        var text = NSMutableAttributedString(string: L10n.Game.win + "\n",
                                             attributes: [NSAttributedString.Key.font:  UIFont.boldSystemFont(ofSize: 27)])
        
        text.append(NSMutableAttributedString(string: L10n.Game.Sheep.Score.Result.win,
                                              attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 27, weight: .light)]))
        
        text.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: NSRange(location: 0, length: text.length))
        textLabel.attributedText = text
        
        text = NSMutableAttributedString(string: L10n.Game.reStart + "\n",
                                             attributes: [NSAttributedString.Key.font:  UIFont.boldSystemFont(ofSize: 27)])
        
        text.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: NSRange(location: 0, length: text.length))
        
        startButton.setAttributedTitle(text, for: .normal)
        startButton.isHidden = false
    }
    
    // MARK : - User's interactions
    
    @IBAction func onStartButton(_ sender: Any) {
        
        let text = NSMutableAttributedString(string: L10n.Game.go + "\n",
                                             attributes: [NSAttributedString.Key.font:  UIFont.boldSystemFont(ofSize: 27)])
        
        text.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: NSRange(location: 0, length: text.length))
            
        startButton.setAttributedTitle(text, for: .normal)
        
        DispatchQueue.main.async {
            if self.displayTimer != nil {
                self.displayTimer.invalidate()
            }
            
            self.displayTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.onDisplayTimerExpiration), userInfo: nil, repeats: false);
        }
    }
    
    
    // MARK: - Internals
    
    @objc func onDisplayTimerExpiration () {
        displayTimer.invalidate()

        configureScore(with: 0)
        startButton.isHidden = true
        scene.startGame()
        
    }
    
    // MARK: - Notification Center
    
    private func setupNotificationCenter() {
        
        // Parameter update
        NotificationCenter.default.addObserver(self, selector: #selector(onParameterUpdate),
                                               name: NSNotification.Name(rawValue: L10n.Notif.Parameter.update),
                                               object: nil)
    }
    
    @objc func onParameterUpdate() {
        if !scene.isGameStarted {
            configureScore(with: 0)
        }
    }

}
