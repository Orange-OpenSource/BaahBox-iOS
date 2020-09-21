//
//  SheepGameScene.swift
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

class SheepGameScene: SKScene, ParametersDefaultable {
    
    var gameDelegate: SheepGameInteractable?
    
    let welcomeSheep = SKSpriteNode(imageNamed: Asset.Games.SheepGame.sheepWelcome.name)
    let sheep = SKSpriteNode(imageNamed: Asset.Games.SheepGame.sheep1.name)
    let gate = SKSpriteNode(imageNamed: Asset.Games.SheepGame.sheepGate.name)
    let ground = SKSpriteNode(imageNamed: Asset.Games.SheepGame.sheepGround.name)
    let bang = SKSpriteNode(imageNamed: Asset.Games.SheepGame.sheepBang.name)
    let sheepBumpImage = UIImage(named: Asset.Games.SheepGame.sheepBump.name)
    let sheepJumpImage = UIImage(named: Asset.Games.SheepGame.sheepJump.name)
    let sheepGameOverImage = UIImage(named: Asset.Games.SheepGame.sheepWelcome.name)
    
    var sheepBumpTexture: SKTexture?
    var sheepJumpTexture: SKTexture?
    var sheepGameOverTexture: SKTexture?
    
    let sheepWalkAnimation: SKAction
    let sheepWelcomeAnimation: SKAction
    
    var isGameStarted = false
    var gameObjective: Int = 1
    var successfullJumps = 0
    var isJumping = false
    
    var lastUpdateTime: TimeInterval = 0
    var dt: TimeInterval = 0
    var velocity = CGPoint.zero
    var threshold: Int = 0
    var speedCoef: Int = 1
    var maxHeigthJump: CGFloat
    let groundPosition = CGPoint(x: 0, y: 768.0)
    // AKA CGPoint(x: size.width/2 - ground.size.width/2, y: size.height/2 - size.height/8)
    
    let dataManager = ParameterDataManager.sharedInstance
    
    lazy var notificationCenter: NotificationCenter = {
        return NotificationCenter.default
    }()
    var notificationObserver: NSObjectProtocol?
    
    
    // MARK: - init
    //======================================
    
    override init(size: CGSize) {
        let walkImage1 = UIImage(named: Asset.Games.SheepGame.sheep1.name)
        let walkImage2 = UIImage(named: Asset.Games.SheepGame.sheep2.name)
        let sheepWalkTextures = [SKTexture(image: walkImage1!),
                                 SKTexture(image: walkImage2!)]
        sheepWalkAnimation = SKAction.animate(with: sheepWalkTextures,
                                              timePerFrame: 0.1)
        
        let welcomeImage2 = UIImage(named: Asset.Games.SheepGame.sheepWelcome2.name)
        let welcomeImage = UIImage(named: Asset.Games.SheepGame.sheepWelcome.name)
        
        let sheepWelcomeTextures = [SKTexture(image: welcomeImage2!),
                                    SKTexture(image: welcomeImage!)]
        sheepWelcomeAnimation = SKAction.animate(with: sheepWelcomeTextures,
                                                 timePerFrame: 0.1)
        
        maxHeigthJump = 0.0
        
        super.init(size: size)
        loadParameters()
    }
    
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func willMove(from view: SKView) {
        super.willMove(from: view)
        print("Sheep scene willMoveFromView")
        removeAllActions()
        for node in self.children {
            node.removeFromParent()
        }
        sheepBumpTexture = nil
        sheepJumpTexture = nil
        sheepGameOverTexture = nil
        
        self.physicsWorld.contactDelegate = nil
        self.gameDelegate = nil
        NotificationCenter.default.removeObserver(self)
    }
    
    
    // MARK: - scene init
    //======================================
    override func didMove(to view: SKView) {
        backgroundColor = Asset.Colors.pinky.color
        ground.anchorPoint = CGPoint.zero
        welcomeSheep.anchorPoint = CGPoint(x: 0.0, y: 1.0)
        sheepBumpTexture = SKTexture(image: sheepBumpImage!)
        sheepJumpTexture = SKTexture(image: sheepJumpImage!)
        sheepGameOverTexture = SKTexture(image: sheepGameOverImage!)

        sheep.anchorPoint = CGPoint.zero
        gate.anchorPoint = CGPoint.zero
        bang.anchorPoint = CGPoint.zero
        bang.position = CGPoint.zero
        bang.isHidden = true
        sheep.zPosition = -2
        gate.zPosition = -1
        addChild(sheep)
        addChild(gate)
        addChild(ground)
        addChild(bang)
        addChild(welcomeSheep)
        welcomeSheep.isHidden = true
        ground.position = groundPosition
        ground.size.width = size.width
        sheep.position = CGPoint(x: size.width/2 - sheep.size.width/2, y: ground.position.y )
        welcomeSheep.position = CGPoint(x: size.width/2 - welcomeSheep.size.width/2, y: size.height)// ground.position.y )
        gate.position = CGPoint(x: size.width, y: ground.position.y)
        maxHeigthJump = size.height - sheep.size.height - groundPosition.y
        
        setupNotificationCenter()
        displayWelcomeScreen()
        
    }
    
    func displayWelcomeScreen () {
        sheep.isHidden = false
        stopSheepWelcomeAnimation()
        welcomeSheep.isHidden = true
        startSheepWalkAnimation ()
    }
    
    func startGame() {
        sheep.texture = SKTexture (imageNamed: Asset.Games.SheepGame.sheep1.name)
        sheep.size = sheep.texture!.size()
        sheep.anchorPoint  = CGPoint.zero
        sheep.position = CGPoint(x: size.width/2 - sheep.size.width/2, y: ground.position.y )
        gate.position = CGPoint(x: size.width, y: ground.position.y)
        
        isGameStarted = true
        isJumping = false
        successfullJumps = 0
        
        welcomeSheep.isHidden = true
        sheep.isHidden = false
        bang.isHidden = true
        ground.isHidden = false
        gate.isHidden = false
        startSheepWalkAnimation ()
    }
    
    func gameOver () {
        stopSheepWalkAnimation()
        sheep.isHidden = true
        
        isGameStarted = false
        bang.isHidden = true
        ground.isHidden = true
        gate.isHidden = true
        welcomeSheep.isHidden = false
        
        
        welcomeSheep.size.height = (welcomeSheep.texture?.size().height)! * 1.2
        welcomeSheep.size.width = (welcomeSheep.texture?.size().width)! * 1.2
        welcomeSheep.position = CGPoint(x: (welcomeSheep.texture?.size().width)! * 0.5, y: size.height)
        
        welcomeSheep.anchorPoint = CGPoint(x: 0.5, y: 1.0)
        welcomeSheep.run(sheepWelcomeAnimation)
        welcomeSheep.run(SKAction.wait(forDuration: 3.0))
        startSheepWelcomeAnimation()
    }
    
    @objc func loadParameters () {
        threshold = dataManager.threshold
        gameObjective = dataManager.numberOfFences
        
        switch dataManager.fenceVelocity {
        case .slow:
            speedCoef = 1
        case .average:
            speedCoef = 2
        default:
            speedCoef = 3
        }
    }
    
    // MARK: - loop
    //======================================
    
    override func update(_ currentTime: TimeInterval) {
        if lastUpdateTime > 0 {
            dt = currentTime - lastUpdateTime
        } else {
            dt = 0
        }
        
        lastUpdateTime = currentTime
        
        if !isGameStarted {
            return
        }
        
        if sheep.position.y == ground.position.y {
            startSheepWalkAnimation()
        } else {
            stopSheepWalkAnimation()
            sheep.texture = sheepJumpTexture
        }
        _ = checkCollision()
    }
    
    
    // MARK: - Notification Center
    
    private func setupNotificationCenter() {
        //data from sensors
        NotificationCenter.default.addObserver(self, selector: #selector(updateData(_:)),
                                               name: Notification.Name(rawValue: L10n.Notif.Ble.dataReceived),
                                               object: nil)
        
        // Parameter update
        NotificationCenter.default.addObserver(self, selector: #selector(loadParameters),
                                               name: Notification.Name(rawValue: L10n.Notif.Parameter.update),
                                               object: nil)
    }
    
    private func getMuscleStrength() -> Int {

        if ParameterDataManager.sharedInstance.muscle1IsON {
            return SensorInputManager.sharedInstance.musclesInput.muscle1
        } else {
            if ParameterDataManager.sharedInstance.muscle2IsON {
               return SensorInputManager.sharedInstance.musclesInput.muscle2
            } else { // no activated muscle in settings
                return 0
            }
        }
    }
    
    @objc func updateData(_ notification: Notification) {
        
        switch ParameterDataManager.sharedInstance.sensorType {
        case .joystick:
            let currentHeight = sheep.position.y
            let delta: CGFloat = 100.0
            var heightTarget = currentHeight
            
            guard SensorInputManager.sharedInstance.joystickInput.up || SensorInputManager.sharedInstance.joystickInput.down else {
                return
            }
            
            if SensorInputManager.sharedInstance.joystickInput.up  && (currentHeight + delta < size.height - sheep.size.height) {
                heightTarget = currentHeight + delta

                jumpTo(sprite: sheep, height: heightTarget)
            }
            
        default:
            if getMuscleStrength() <= threshold { return }
            
            let strengthValue = getMuscleStrength()
            var heightConstraint = (CGFloat(strengthValue) - CGFloat (hardnessCoeff*350)) / 1000
            
            if heightConstraint < 0 {
                heightConstraint = 0
            }
            
            let jumpheightWithConstraint = groundPosition.y + (maxHeigthJump * heightConstraint)
            
            jumpTo(sprite: sheep, height: jumpheightWithConstraint)
        }
    }
    
    // MARK: - sprite moves
    //======================================
    
    func move(sprite: SKSpriteNode, velocity: CGPoint) {
        let amountToMove = CGPoint(x: velocity.x * CGFloat(dt), y: velocity.y * CGFloat(dt))
        sprite.position = CGPoint(
            x: sprite.position.x + amountToMove.x,
            y: sprite.position.y + amountToMove.y)
    }
    
    func moveSpriteToPosition(sprite: SKSpriteNode, position: CGPoint) {
        sprite.position = position
    }
    func moveSpriteToHeight(sprite: SKSpriteNode, position: CGPoint) {
        sprite.position.y = position.y
    }
    
    func jumpTo(sprite: SKSpriteNode, height: CGFloat) {
        
        let actionJump = SKAction.move(to: CGPoint(x: sprite.position.x, y: height), duration: 1.0)
        let actionFall = SKAction.move(to: CGPoint(x: sprite.position.x, y: groundPosition.y ), duration: 1.0)
        let sequence = SKAction.sequence([actionJump, actionFall])
        
        sprite.run(sequence)
    }
    
    // MARK: - sheep walk animation
    //======================================
    func startSheepWalkAnimation() {
        if sheep.action(forKey: "sheepWalkAnimation") == nil {
            sheep.run(
                SKAction.repeatForever(sheepWalkAnimation),
                withKey: "sheepWalkAnimation")
        }
    }
    
    func stopSheepWalkAnimation() {
        sheep.removeAction(forKey: "sheepWalkAnimation")
    }
    
    // MARK: - sheep Welcome animation
    //======================================
    func startSheepWelcomeAnimation() {
        if welcomeSheep.action(forKey: "sheepWelcomeAnimation") == nil {
            welcomeSheep.run(
                SKAction.repeatForever(SKAction.sequence([SKAction.wait(forDuration: 3.0), sheepWelcomeAnimation])),
                withKey: "sheepWelcomeAnimation")
        }
    }
    
    func stopSheepWelcomeAnimation() {
        welcomeSheep.removeAction(forKey: "sheepWelcomeAnimation")
    }
    
    func getNewPosition(from position: CGPoint) -> CGFloat {
        
        let heightConstraint = CGFloat (300 * hardnessCoeff)
        var newPosition = position.y - heightConstraint
        
        if newPosition < ground.position.y {
            newPosition = ground.position.y
        }
        return newPosition
    }
    
    // MARK: - touch handling
    //======================================
    func sceneTouched(touchLocation: CGPoint) {
        
        let  position = boundsCheckForSheep(touchLocation)
        if !(gate.frame.intersects(sheep.frame)) && position.y > ground.position.y {
            jumpTo(sprite: sheep, height: getNewPosition(from: position))
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
    
    
    // MARK: - collision detection
    //======================================
    
    private func checkCollision() -> Bool {
        var result = false
        if gate.frame.intersects(sheep.frame) {
            stopSheepWalkAnimation()
            sheep.texture = sheepBumpTexture
            bang.position = CGPoint (x: sheep.position.x + 350, y: sheep.position.y + 400)
            result = true
            isGameStarted = false
            gameDelegate?.collisionOccured()
        } else {
            boundsCheckForGate()
            let variation  = CGFloat(2 * speedCoef)
            gate.position = CGPoint(x: gate.position.x - variation, y: gate.position.y)
            
            if sheep.position.y == groundPosition.y {
                
                if isJumping && isGameStarted  && gate.position.x < size.width/2 {
                    successfullJumps += 1
                    
                    if successfullJumps == gameObjective {
                        gameDelegate?.gameOver()
                        gameOver()
                    } else {
                        gameDelegate?.successfullJump()
                        gameDelegate?.walking()
                    }
                } else {
                    gameDelegate?.walking()
                }
                
                isJumping = false
                
            } else {
                isJumping = true
                gameDelegate?.jumpInProgress()
            }
        }
        
        bang.isHidden = !result
        return result
    }
    
    
    // MARK: - utils
    //======================================
    private func boundsCheckForSheep(_ location: CGPoint) -> CGPoint {
        var position  = location
        if position.y < groundPosition.y {
            position.y = groundPosition.y
        } else if position.y > size.height - sheep.size.height {
            position.y = size.height - sheep.size.height
        }
        return position
    }
    
    
    private func boundsCheckForGate() {
        if gate.position.x <= 2.0 {
            gate.position.x = size.width - 5
        }
    }
}
