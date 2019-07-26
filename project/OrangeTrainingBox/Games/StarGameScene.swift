//
//  StarGameScene.swift
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

import SpriteKit

class StarGameScene: SKScene, ParametersDefaultable {
    
    var lastUpdateTime: TimeInterval = 0
    var dt: TimeInterval = 0
    var isGameStarted = false
    var strengthValue : Int = 0
    let strenghThreshold: Double = 50
    var gameDelegate: StarGameInteractable?

    let star = SKSpriteNode(imageNamed: Asset.Games.StarGame.starLow.name)
    let starAnimation: SKAction
    
    override init(size: CGSize) {
        
        let starTextures = [SKTexture(imageNamed: Asset.Games.StarGame.starLow.name),
                               SKTexture(imageNamed: Asset.Games.StarGame.starBlur.name)]
        
        starAnimation = SKAction.animate(with: starTextures, timePerFrame: 1)
        
        super.init(size: size)
        resetGame()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startStarAnimation() {
        if star.action(forKey: "starAnimation") == nil {
            star.run (SKAction.repeatForever(starAnimation), withKey: "starAnimation")
        }
    }
  
    func stopStarAnimation() {
        star.removeAllActions()
    }
   
    override func willMove(from view: SKView) {
        super.willMove(from: view)
        print("Star scene willMoveFromView")
        removeAllActions()
        for node in self.children {
            node.removeFromParent()
        }
        self.gameDelegate = nil
    }
    
    override func didMove(to view: SKView) {
        backgroundColor = Asset.Colors.violet.color
        
        star.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        star.texture = SKTexture (imageNamed: Asset.Games.StarGame.starLow.name)
        let imageSize = star.texture!.size()
        star.position = CGPoint(x: size.width/2 , y: size.height/2 + imageSize.height/4)
        addChild(star)
        setupNotificationCenter()
      //  startStarAnimation()
    }
    
    func resetGame() {
        lastUpdateTime = 0
        dt = 0
        strengthValue = 0
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        if lastUpdateTime > 0 {
            dt = currentTime - lastUpdateTime
        } else {
            dt = 0
        }
        lastUpdateTime = currentTime
        
        if isGameStarted {
            print("Strength : \(strengthValue)")
            switch strengthValue {
            
            case 0...Int(20 * hardnessCoeff):
                star.texture = SKTexture (imageNamed: Asset.Games.StarGame.starLow.name)
                gameDelegate?.shoving()
            
            case Int(21 * hardnessCoeff)...Int(70 * hardnessCoeff):
                star.texture = SKTexture (imageNamed: Asset.Games.StarGame.starLow.name)
                gameDelegate?.swelling()
           
            default:
                star.texture = SKTexture (imageNamed: Asset.Games.StarGame.starBlur.name)
                resetGame()
                gameDelegate?.win()
            }
        } else {
            star.size = (star.texture?.size())!
        }
    }
    
    
    
    // Data update
    //
    
    @objc func updateData(_ notification: Notification) {
        if isGameStarted {
            switch ParameterDataManager.sharedInstance.sensorType {
            case .joystick:
                guard SensorInputManager.sharedInstance.joystickInput.up && strengthValue  <= Int(95*hardnessCoeff) else {
                    return
                }
                strengthValue  = strengthValue + 1
                
                
                print("updateData : Strength : \(strengthValue)")
                
            default: // using Muscle inputs
                // The strength is in [0...1000] -> Have it fit into [0...100]
                strengthValue = Int (getMuscleStrength() / 10)
                
            }
        }
        
    }
    
    
    // ===========================
    // MARK: - Notification Center
    // ===========================
    
    private func setupNotificationCenter() {
        // data from sensors
        NotificationCenter.default.addObserver(self, selector: #selector(updateData(_:)),
                                               name: Notification.Name(rawValue: L10n.Notif.Ble.dataReceived),
                                               object: nil)
    }
    
    private func getMuscleStrength() -> Int {
        if ParameterDataManager.sharedInstance.muscle1IsON {
            return SensorInputManager.sharedInstance.musclesInput.muscle1
        } else if ParameterDataManager.sharedInstance.muscle2IsON {
            return SensorInputManager.sharedInstance.musclesInput.muscle2
        } else {
            return 0
        }
    }
    
    
    
    
    
    
    
    
    
    // ======================
    // MARK: - Touch handling
    // ======================
    
    func sceneTouched(touchLocation: CGPoint) {
        if isGameStarted {
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

