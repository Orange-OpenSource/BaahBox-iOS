//
//  StarGameScene.swift
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

import SpriteKit

class StarGameScene: SKScene, GameScene, ParametersDefaultable {
    
    weak var title: UILabel?
    weak var subtitle: UILabel?
    weak var feedback: UILabel?
    weak var button: UIButtonBordered?
    weak var gameSceneDelegate: GameSceneDelegate?
    
    let star = SKSpriteNode(imageNamed: Asset.Games.StarGame.starLow.name)
    var strengthValue: Int = 0
    let strenghThreshold: Double = 50
    
    var isOnGoing: Bool {
        if case .onGoing = self.state {
            return true
        }
        return false
    }
    
    var state: GameState {
        didSet {
            gameSceneDelegate?.onChanged(state: state)
            switch state {
                
            case .notStarted:
                strengthValue = 0
                title?.isHidden = false
                subtitle?.isHidden = false
                feedback?.isHidden = true
                feedback?.transform = CGAffineTransform(scaleX: 1, y: 1)
                button?.setTitle(L10n.Game.start, for: .normal)
                button?.isHidden = false
                
            case .onGoing:
                title?.isHidden = true
                subtitle?.isHidden = true
                feedback?.isHidden = true
                feedback?.transform = CGAffineTransform(scaleX: 1, y: 1)
                button?.isHidden = true
                
            case .halted:
                break
                
            case .ended:
                strengthValue = 0
                title?.isHidden = true
                subtitle?.isHidden = true
                feedback?.isHidden = false
                feedback?.transform = CGAffineTransform(scaleX: 2, y: 2);
                button?.setTitle(L10n.Game.reStart, for: .normal)
                button?.isHidden = false
            }
        }
    }
    
    // =============================
    // MARK: - Init & configuration
    // =============================
    
    override init(size: CGSize) {
        strengthValue = 0
        state = .notStarted
        super.init(size: size)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(title: UILabel, subtitle: UILabel, feedback: UILabel?, score: UILabel?, button: UIButtonBordered, delegate: GameSceneDelegate) {
        self.title = title
        self.subtitle = subtitle
        self.button = button
        self.feedback = feedback
        self.gameSceneDelegate = delegate
        configureLabelsForStart()
        
    }
    
    func configureLabelsForStart() {
        self.title?.text = L10n.Game.Star.header
        self.feedback?.isHidden = true
        switch ParameterDataManager.sharedInstance.sensorType {
        case .joystick:
            self.subtitle?.text = L10n.Game.Star.subHeaderJoystick
        default:
            self.subtitle?.text = L10n.Game.Star.subHeaderMuscle
        }
    }
    
    func configureStarSpriteForStart() {
        star.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        star.texture = SKTexture(imageNamed: Asset.Games.StarGame.starLow.name)
        let imageSize = star.texture!.size()
        star.position = CGPoint(x: size.width/2 , y: size.height/2 + imageSize.height/4)
    }
    
    
    // ================
    // MARK: - SKView
    // ================
    
    override func willMove(from view: SKView) {
        super.willMove(from: view)
        removeAllActions()
        removeAllChildren()
        unsetNotifications()
    }
    
    override func didMove(to view: SKView) {
        backgroundColor = Asset.Colors.violet.color
        configureStarSpriteForStart()
        self.scaleMode = .aspectFill
        addChild(star)
        strengthValue = 0
        state = .notStarted
        setNotifications()
    }
    
    
    // ================
    // MARK: - Actions
    // ================
    
    func onButtonPressed() {
        switch state {
        case .notStarted:
            state = .onGoing
        case .onGoing, .halted: // shoud not happen in this game
            break
        case .ended:
            state = .onGoing // .notStarted
        }
    }
    
    // ========================
    // MARK: - Data processing
    // ========================
    
    private func getMuscleStrength() -> Int {
        if ParameterDataManager.sharedInstance.muscle1IsON {
            return SensorInputManager.sharedInstance.musclesInput.muscle1
        } else if ParameterDataManager.sharedInstance.muscle2IsON {
            return SensorInputManager.sharedInstance.musclesInput.muscle2
        } else {
            return 0
        }
    }
    
    
    @objc func updateData(_ notification: Notification) {
        guard isOnGoing  && !ParameterDataManager.sharedInstance.demoMode else {
            return
        }
        switch ParameterDataManager.sharedInstance.sensorType {
        case .joystick:
            guard SensorInputManager.sharedInstance.joystickInput.up && strengthValue <= Int(95*hardnessCoeff) else {
                return
            }
            strengthValue = strengthValue + 1
        case .muscles: // using Muscle inputs
            // The strength is in [0...1000] -> Have it fit into [0...100]
            strengthValue = Int (getMuscleStrength() / 10)
        case .buttons:
            break
        }
    }
    
    
    // ==================
    // MARK: - Game loop
    // ==================
    
    override func update(_ currentTime: TimeInterval) {
        guard isOnGoing else {
            star.size = (star.texture?.size())!
            return
        }
        switch strengthValue {
        case 0...Int(20 * hardnessCoeff):
            star.texture = SKTexture (imageNamed: Asset.Games.StarGame.starLow.name)
            feedback?.isHidden = true
            title?.isHidden = false
            subtitle?.isHidden = false
            
        case Int(21 * hardnessCoeff)...Int(70 * hardnessCoeff):
            feedback?.text = L10n.Game.keepGoing
            feedback?.isHidden = false
            title?.isHidden = true
            subtitle?.isHidden = true
        default:
            star.texture = SKTexture(imageNamed: Asset.Games.StarGame.starBlur.name)
            feedback?.text = L10n.Game.congrats
            title?.isHidden = true
            subtitle?.isHidden = true
            let score = Score(won: true, total: 0)
            state = .ended(score)
        }
    }
    
    
    // ============================
    // MARK: - Notification Center
    // ============================
    
    private func setNotifications() {
        // data from sensors
        NotificationCenter.default.addObserver(self, selector: #selector(updateData(_:)),
                                               name: Notification.Name(rawValue: L10n.Notif.Ble.dataReceived),
                                               object: nil)
    }
    
    private func unsetNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    // =========================
    // MARK: - Touch handling
    // =========================
    
    func sceneTouched(touchLocation: CGPoint) {
        guard isOnGoing && ParameterDataManager.sharedInstance.demoMode else {
            return
        }
        let ground = star.position.y - star.size.height/2
        switch touchLocation.y {
        case 0...ground:
            strengthValue = 0
        case (ground + 1)...star.position.y + star.size.height/2:
            strengthValue = Int(strenghThreshold)
        default:
            strengthValue = Int(strenghThreshold * 2)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        let touchLocation = touch.location(in: self)
        sceneTouched(touchLocation: touchLocation)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        let touchLocation = touch.location(in: self)
        sceneTouched(touchLocation: touchLocation)
    }
}
