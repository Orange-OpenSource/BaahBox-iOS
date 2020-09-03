//
//  SpaceshipGameVC.swift
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


class SpaceshipGameVC: GameVC, GameSceneDelegate  {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var button: UIButtonBordered!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var lifeView: UIView!
    
    var displayTimer: Timer!
    var scene: SpaceshipGameScene?
    
    var lifeViews: [UIImageView] = []
    
    @IBOutlet weak var buttonTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var buttonCenterXContraint: NSLayoutConstraint!
    @IBOutlet weak var buttonBottomConstraint: NSLayoutConstraint!
    
    // =======================
    // MARK: - View Lifecycle
    // =======================
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = L10n.Game.Space.title
        navTintColor = Asset.Colors.blueGreen.color
        ParameterDataManager.sharedInstance.muscle1IsON = true
        ParameterDataManager.sharedInstance.muscle2IsON = true
        
        button.setTitle(L10n.Game.stop, for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureScene()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        scene?.gameOver()
        scene = nil
        super.viewWillDisappear(animated)
        
    }
    
    
    // ===============
    // MARK: - Scene
    // ===============
    
    func configureScene() {
        scene = SpaceshipGameScene(size:CGSize(width: 1536, height: 2048))
        scene!.scaleMode = .aspectFill
        scene?.configure(title: titleLabel, subtitle: subtitleLabel, feedback: nil, score: scoreLabel, button: button, delegate: self)
        let skView = configureSkView(showData: true)
        skView?.presentScene(scene)
        configureLifeViews()
    }
    

    func onChanged(state: GameState) {
        switch state {
        case .notStarted, .ended:
            configureLifeViews()
            hideLifeViews()
            setButtonLocation(forStart: true)
            
        case .halted:
            break
           // configureLifeViews()
            //showLifeViews()
            
        default:
            configureLifeViews()
            showLifeViews()
            setButtonLocation(forStart: false)
        }
    }
    
    func hideLifeViews() {
        lifeView.isHidden = true
    }
    
    func showLifeViews() {
        lifeView.isHidden = false
    }
    
    private func configureLifeViews() {
        for lifeView in lifeViews {
            lifeView.removeFromSuperview()
        }
        lifeViews = []
        let lifeWidth: CGFloat = 45.0
        let padding: CGFloat = 15.0
        let lifeHeight: CGFloat = 45.0
        let lifeWidthPadded: CGFloat = lifeWidth + padding
        print("in show : lifes : \(String(describing: scene?.lifes))")

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
    
   
    func collisionOccured() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            self.scene?.state = .halted
        })
    }
    
    func gameOver() {
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                    self.scene?.state = .ended(Score(won: false, total: self.scene?.score ?? 0))
                })
    }
    
    // =============================
    // MARK : - User's interactions
    // =============================
    
    @IBAction func onButtonPressed(_ sender: Any) {
        scene?.onButtonPressed()
        
        DispatchQueue.main.async {
            if self.displayTimer != nil {
                self.displayTimer.invalidate()
            }

            self.displayTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.onDisplayTimerExpiration), userInfo: nil, repeats: false);
        }
    }
    
       // ==================
       // MARK: - Internals
       // ==================
       
       @objc func onDisplayTimerExpiration () {
           displayTimer.invalidate()
        // button alternates to stop/ start position
       }
       
    func setButtonLocation(forStart: Bool) {
        buttonBottomConstraint.constant = (forStart ? 100 : 20)
       // buttonCenterXContraint.isActive = (forStart ? true : false)
        buttonTrailingConstraint.constant = (forStart ? 73: 10)
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

