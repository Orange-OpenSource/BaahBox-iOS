//
//  GameScene.swift
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

import SpriteKit

class BalloonGameScene: SKScene, ParametersDefaultable {
    
    var lastUpdateTime: TimeInterval = 0
    var dt: TimeInterval = 0
    var isGameStarted = false
    var strengthValue : Int = 0
    var startY: CGFloat = CGFloat (0)
    var gameDelegate: BalloonGameInteractable?
    let balloon = SKSpriteNode(imageNamed: Asset.Games.BalloonGame.balloon00.name)
    let balloonAnimation: SKAction
    var notificationObserver: NSObjectProtocol?
    
    
    override init(size: CGSize) {
        
        let balloonTextures = [SKTexture(imageNamed: Asset.Games.BalloonGame.balloon00.name),
                               SKTexture(imageNamed: Asset.Games.BalloonGame.balloon01.name),
                               SKTexture(imageNamed: Asset.Games.BalloonGame.balloon02.name),
                               SKTexture(imageNamed: Asset.Games.BalloonGame.balloon03.name),
                               SKTexture(imageNamed: Asset.Games.BalloonGame.balloon04.name)]
        
        balloonAnimation = SKAction.animate(with: balloonTextures,
                                            timePerFrame: 1)
        super.init(size: size)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented") 
    }
    
    
    func startGame () {
        balloon.texture = SKTexture (imageNamed: Asset.Games.BalloonGame.balloon00.name)
        balloon.size = (balloon.texture?.size())!
        strengthValue = 0
    }
    
    override func willMove(from view: SKView) {
        super.willMove(from: view)
        print("Balloon scene willMoveFromView")
        removeAllActions()
        for node in self.children {
            node.removeFromParent()
        }
        self.gameDelegate = nil
        unsetNotifications()
    }
    
    override func didMove(to view: SKView) {
        backgroundColor = Asset.Colors.orange.color
        
        balloon.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        let balloonImage = UIImage(named: Asset.Games.BalloonGame.balloon00.name)
        balloon.texture = SKTexture (image: balloonImage!)
        let imageSize = balloon.texture!.size()
        balloon.position = CGPoint(x: size.width/2 , y: size.height/2 + imageSize.height/4)
        addChild(balloon)
        setNotifications()
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
            case 0...Int(20*hardnessCoeff):
                balloon.texture = SKTexture (imageNamed: Asset.Games.BalloonGame.balloon00.name)
                balloon.size = (balloon.texture?.size())!
                gameDelegate?.swelling()
            case Int(21*hardnessCoeff)...Int(90*hardnessCoeff):
                let expansionCoeff = CGFloat (strengthValue + 30) / 100
                balloon.texture = SKTexture (imageNamed: Asset.Games.BalloonGame.balloon03.name)
                balloon.size.height = (balloon.texture?.size().height)! * expansionCoeff
                balloon.size.width = (balloon.texture?.size().width)! * expansionCoeff
                gameDelegate?.swelling()
            default:
                balloon.texture = SKTexture (imageNamed: Asset.Games.BalloonGame.balloon04.name)
                balloon.size = (balloon.texture?.size())!
                gameDelegate?.gameOver()
                isGameStarted = false
            }
            
        } else {
            balloon.size = (balloon.texture?.size())!
            strengthValue = 0
        }
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
    
    // MARK: - Notification Center
    
    private func setNotifications() {
        //data from sensors
        NotificationCenter.default.addObserver(self, selector: #selector(updateData(_:)),
                                               name: Notification.Name(rawValue: L10n.Notif.Ble.dataReceived),
                                               object: nil)
    }
    
    private func unsetNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    // MARK: - touch handling
    //======================================
    func sceneTouched(touchLocation: CGPoint) {
        
        var distance = Int (abs (touchLocation.y - startY))
        
        if distance > 600 {
            distance = 600
        }
        strengthValue = Int (distance / 6)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        let touchLocation = touch.location(in: self)
        
        startY = touchLocation.y
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

