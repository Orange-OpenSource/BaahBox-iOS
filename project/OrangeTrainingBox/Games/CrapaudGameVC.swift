//
//  CrapaudGameVC.swift
//  Orange Baah Box
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

public protocol CrapaudGameInteractable {
    func flyCaught ()
    var nextScoreFlyCenterScenePosition: CGPoint { get }
}


class CrapaudGameVC: SettableVC, CrapaudGameInteractable {
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var startButtonBottomConstraint: NSLayoutConstraint!
    
    var numberOfFlys = ParameterDataManager.sharedInstance.numberOfFlies
    var displayTimer: Timer!
    var scene: CrapaudGameScene!
    var score = 0
    var scoreViews: [UIImageView] = []
    var scoreViewCenterYPosition = CGFloat(0)
    var scoreViewCenterXPosition: [CGFloat] = []
    var scoreViewSize: CGFloat = 0
    
    var nextScoreFlyCenterScenePosition: CGPoint {
        guard scoreViews.count > score else { return CGPoint() }
        let nextFlyScreenPosition = scoreViews[score].frame.origin + CGPoint(x: scoreViewSize / 2, y: scoreViewSize / 2)
        return screenToScenePoint(nextFlyScreenPosition)
    }
    
    func screenToScenePoint(_ screenPoint: CGPoint) -> CGPoint {
        let sceneHeight = scene.size.height
        let sceneWidth = scene.size.width
        let screenHeight = view.bounds.height
        let screenWidth = view.bounds.width
        let screenToSceneRatio = sceneHeight / screenHeight
        let visibleSceneWidth = screenWidth * screenToSceneRatio
        let sceneHidenMargin = (sceneWidth - visibleSceneWidth) / 2
        let xScenePosition = sceneHidenMargin + screenPoint.x * screenToSceneRatio
        let yScenePosition = (screenHeight - screenPoint.y) * screenToSceneRatio
        return CGPoint(x: xScenePosition, y: yScenePosition)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = L10n.Game.Frog.title
        navTintColor = Asset.Colors.greyGreen.color
        view.isMultipleTouchEnabled = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        numberOfFlys = ParameterDataManager.sharedInstance.numberOfFlies
        configureScene()
        configureSkView()
        configureBottomView(showStartGame: true)
        addScoreViews()
        showScoreViews()
        ParameterDataManager.sharedInstance.muscle1IsON = true
        ParameterDataManager.sharedInstance.muscle2IsON = true
        if startButton.isHidden {
            scene.startGame()
        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
         super.viewWillDisappear(animated)
        scene.disableGame()
        scene = nil
        let skView = view as! SKView
        skView.presentScene(nil)
    }

    

        
    private func addScoreViews() {
        for scoreView in scoreViews {
            scoreView.removeFromSuperview()
        }
        scoreViews = []
        let safeInsets = appDelegate.safeAreaInsets
        let screenWidth = view.frame.width
        let screenHeight = view.frame.height
        scoreViewSize = screenWidth / CGFloat(max(numberOfFlys + 2, 5))
        let numberOfIntervals = numberOfFlys + 1
        let allScoresWidth = scoreViewSize * CGFloat(numberOfFlys)
        let intervalWidth = (screenWidth - allScoresWidth) / CGFloat(numberOfIntervals)
        let scoreViewTopFromScreenBottom = max(15, safeInsets.bottom) + scoreViewSize
        let yPosition = screenHeight -  scoreViewTopFromScreenBottom
        scoreViewCenterYPosition = yPosition + scoreViewSize / 2
        startButton.translatesAutoresizingMaskIntoConstraints = false
        startButtonBottomConstraint.constant = (safeInsets.bottom > 0 ? 0 : 15) + scoreViewSize + 5
        for i in 0 ..< numberOfFlys {
            let xPosition = intervalWidth + CGFloat(i) * (scoreViewSize + intervalWidth)
            scoreViewCenterXPosition.append(xPosition  + scoreViewSize / 2)
            let scoreView = UIImageView(frame: CGRect(x: xPosition, y: yPosition, width: scoreViewSize, height: scoreViewSize))
            scoreView.image = UIImage(named: Asset.Games.CrapaudGame.flyPoint0.name)
            scoreView.contentMode = .scaleAspectFit
            scoreView.isHidden = false
            view.addSubview(scoreView)
            scoreViews.append(scoreView)
        }
    }
    
    private func showScoreViews() {
        for (index, scoreView) in scoreViews.enumerated() {
            scoreView.image = UIImage(named: index < score ? Asset.Games.CrapaudGame.flyPoint1.name : Asset.Games.CrapaudGame.flyPoint0.name)
        }
        view.layoutIfNeeded()
        if score >= numberOfFlys {
            gameOver()
        }
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    private func configureSkView () {
        let skView = view as! SKView
        skView.ignoresSiblingOrder = true
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.presentScene(scene)
    }
    
    private func configureScene () {
        scene = CrapaudGameScene(size:CGSize(width: 1536, height: 2048))
        scene.gameDelegate = self
        scene.scaleMode = .aspectFill
    }
    
    private func configureBottomView (showStartGame : Bool) {
        startButton.isHidden = !showStartGame
        textLabel.isHidden = showStartGame
        
        if showStartGame {
            setButtonText(L10n.Game.start)
        }
    }
    
    func setButtonText(_ text: String) {
        let attributedText = NSMutableAttributedString(string: text,
                                             attributes: [NSAttributedString.Key.font:  UIFont.boldSystemFont(ofSize: 27)])
        attributedText.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: NSRange(location: 0, length: attributedText.length))
        startButton.setAttributedTitle(attributedText, for: .normal)
    }
    
  
    @IBAction func onStartButtonPressed(_ sender: Any) {
        setButtonText(L10n.Game.go)
        textLabel.isHidden = true
        
        DispatchQueue.main.async {
            if self.displayTimer != nil {
                self.displayTimer.invalidate()
            }
            self.scene.startGame()
            self.displayTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.onDisplayTimerExpiration), userInfo: nil, repeats: false);
        }
    }
    
    @objc func onDisplayTimerExpiration () {
        displayTimer.invalidate()
        
//        configureScore(with: 0)
        startButton.isHidden = true
        score = 0
        showScoreViews()

    }
    
    // MARK: - CrapaudGameInteractable protocol
    
    func flyCaught() {
        scoreViews[score].image = UIImage(named: Asset.Games.CrapaudGame.flyPoint1.name)
        score = score + 1
        if score == numberOfFlys {
            gameOver()
        }
    } 
    
    private func gameOver() {
//        hideScoreViews()
        let text = NSMutableAttributedString(string: L10n.Game.wahoo + "\n",
                                             attributes: [NSAttributedString.Key.font:  UIFont.boldSystemFont(ofSize: 27)])
        
        text.append(NSMutableAttributedString(string: L10n.Game.wellDone,
                                              attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 27, weight: .light)]))
        text.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: NSRange(location: 0, length: text.length))
        textLabel.attributedText = text
        textLabel.isHidden = false
        scene.stopGame()
        setButtonText(L10n.Game.reStart)
        startButton.isHidden = false

    }
}


