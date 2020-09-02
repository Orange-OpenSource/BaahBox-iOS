//
//  SpaceshipGameScene.swift
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

let collisionSpaceShipCategory: UInt32 = 0x1 << 0
let collisionMeteorCategory: UInt32 = 0x1 << 1

class SpaceshipGameScene: SKScene, SKPhysicsContactDelegate {
    
    var gameDelegate: SpaceShipGameInteractable?
    
    var lastUpdateTime: TimeInterval = 0
    var dt: TimeInterval = 0
    var isGameStarted = false
    var gameState: GameState = .notStarted
    
    let secondPerScorePoint: TimeInterval = 1.0
    var score: Int = 0
    var lifes: Int = 0
    var lastScoreTime: TimeInterval = 0
    
    let spaceShipScale: CGFloat = 0.75
    var spaceShipInitialPosition = CGPoint(x: 0, y: 0)
    let spaceShipNMLImage = UIImage(named: Asset.Games.SpaceshipGame.spaceshipNml.name)
    let spaceShipLFTImage = UIImage(named: Asset.Games.SpaceshipGame.spaceshipLeft.name)
    let spaceShipRGTImage = UIImage(named: Asset.Games.SpaceshipGame.spaceshipRight.name)
    var shipNmlTexture: SKTexture?
    var shipRightTexture: SKTexture?
    var shipLeftTexture: SKTexture?
    var spaceShip =  SKSpriteNode(imageNamed: Asset.Games.SpaceshipGame.spaceshipNml.name)
    var spaceShipAnimation = SKAction()
    
    var meteorAccelerationFactor: Double = 1.0
    var meteorSpawnAction = SKAction()
    
    
    //  let asteroidCollisionSoundAction = SKAction.playSoundFileNamed(
    // "SNCRASH1.wav", waitForCompletion: false)
    var crash = SKSpriteNode(imageNamed: Asset.Games.SpaceshipGame.crash.name)
    var crashAnimation = SKAction()

    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(size: CGSize) {
        super.init(size: size)

        shipNmlTexture = SKTexture(image: spaceShipNMLImage!)
        shipRightTexture = SKTexture(image: spaceShipRGTImage!)
        shipLeftTexture =  SKTexture(image: spaceShipLFTImage!)
        
        let spaceShipTextures =
            [shipNmlTexture, shipRightTexture, shipNmlTexture, shipLeftTexture]
        spaceShipAnimation = SKAction.animate(with: spaceShipTextures as! [SKTexture],
                                              timePerFrame: 1)
        
        meteorSpawnAction = SKAction.repeatForever(
            SKAction.sequence([SKAction.run() { [weak self] in
                self?.spawnMeteors()
                },
                               SKAction.wait(forDuration: 3.0)]))
    }
    
    
    override func willMove(from view: SKView) {
        super.willMove(from: view)
        print("space Scene willMoveFromView")
        removeAllActions()
        for node in self.children {
            node.removeFromParent()
        }
        shipNmlTexture = nil
        shipRightTexture = nil
        shipLeftTexture = nil
        self.physicsWorld.contactDelegate = nil
        gameDelegate = nil
        NotificationCenter.default.removeObserver(self)
    }
    
    
    override func didMove(to view: SKView) {
        backgroundColor = Asset.Colors.blueGreen.color
        gameState = .notStarted
        spaceShip.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        // spaceShip.texture = shipRightTexture//SKTexture (imageNamed: Asset.Games.SpaceshipGame.spaceshipNml.name)
        spaceShip.setScale(spaceShipScale)
        spaceShipInitialPosition = CGPoint(x: size.width/2, y: size.height/4 + spaceShip.size.height)
        spaceShip.position = spaceShipInitialPosition
        spaceShip.setScale(spaceShipScale)
        spaceShip.name = "ship"
        let collisionSize = spaceShip.size//CGSize(width: spaceShip.size.width * spaceShipScale, height: spaceShip.size.height * spaceShipScale)
        
        // Add physics body for collision detection
        spaceShip.physicsBody?.isDynamic = true
        spaceShip.physicsBody = SKPhysicsBody(texture: spaceShip.texture!, size: collisionSize)
        spaceShip.physicsBody?.affectedByGravity = false
        spaceShip.physicsBody?.categoryBitMask = collisionSpaceShipCategory
        spaceShip.physicsBody?.contactTestBitMask = collisionMeteorCategory
        
        spaceShip.physicsBody?.collisionBitMask = 0x0
        
        addChild(spaceShip)
        
        crash.anchorPoint = CGPoint(x: 0.3, y: 0.3)
        crash.setScale(0.5)
        crash.isHidden = true
        addChild(crash)
        
        self.physicsWorld.contactDelegate = self
        
        // Add Stars in the backgound with 3 emitterNodes for a parallax effect
        // – Stars in top layer: light, fast, big
        // – …
        // – Stars in back layer: dark, slow, small
        
        var emitterNode = spaceStarEmitter(color: SKColor.lightGray, starSpeedY: 50, starsPerSecond: 1, starScaleFactor: 0.2)
        emitterNode.zPosition = -10
        self.addChild(emitterNode)
        
        emitterNode = spaceStarEmitter(color: SKColor.gray, starSpeedY: 30, starsPerSecond: 2, starScaleFactor: 0.1)
        emitterNode.zPosition = -11
        self.addChild(emitterNode)
        
        emitterNode = spaceStarEmitter(color: SKColor.darkGray, starSpeedY: 15, starsPerSecond: 4, starScaleFactor: 0.05)
        emitterNode.zPosition = -12
        self.addChild(emitterNode)
    }
    
    
    func initGame() {
        score = 0
        lifes = ParameterDataManager.sharedInstance.numberOfSpaceShips
        loadParameters()
        spaceShip.position = spaceShipInitialPosition
        setupNotificationCenter()
    }
    
    func runGame() {
        crash.isHidden = true
        removeMeteors()
        loadParameters()
        // launch meteorites
        run(meteorSpawnAction, withKey: "meteorSpawnAction")
        gameState = .onGoing
    }
    
    override func update(_ currentTime: TimeInterval) {
        if lastUpdateTime > 0 {
            dt = currentTime - lastUpdateTime
        } else {
            dt = 0
        }
        
        if self.gameState != .onGoing {
            lastScoreTime = currentTime
        }
        
        // score is calculated on elapsed time (x seconds = 1 point)
        if (currentTime - lastScoreTime) > secondPerScorePoint, gameState == .onGoing {
            score += 1
            lastScoreTime = currentTime
            self.gameDelegate?.refreshScore()
        }
        
        lastUpdateTime = currentTime
    }
    
    
    private func analyseActions(leftAction: Bool, rightAction: Bool) {
        if  gameState != .onGoing {
            return
        }
        if leftAction && rightAction {
            spaceShip.texture = shipNmlTexture
            spaceShip.size = shipNmlTexture!.size()
            return
        }
        
        if leftAction {
            spaceShip.texture = shipLeftTexture
            spaceShip.size = shipLeftTexture!.size()
            goLeft()
            return
        }
        if rightAction {
            spaceShip.texture = shipRightTexture
            spaceShip.size = shipRightTexture!.size()
            goRight()
            return
        }
    }
    
    
    private func goLeft() {
        
        let xPosition = spaceShip.position.x
        spaceShip.texture = shipLeftTexture
        spaceShip.run(SKAction.animate(with: [shipLeftTexture!], timePerFrame: 1))
        // spaceShip.size = scaleSize(spaceShip.texture.size(), by: spaceShipScale)
        if xPosition > spaceShip.size.width/2 + 120 {
            let newXPosition = xPosition - 120 //- velocity * 1//8
            slideTo(sprite: spaceShip, x: newXPosition)
        }
        //  spaceShip.run(SKAction.animate(with: [shipNmlTexture], timePerFrame: 1))
    }
    
    private func goRight() {
        let xPosition = spaceShip.position.x
        spaceShip.texture = shipRightTexture
        if xPosition < self.size.width - spaceShip.size.width/2 - 120 {
            let newXPosition = xPosition + 120 //- velocity * 1//8
            slideTo(sprite: spaceShip, x: newXPosition)
        }
    }
    
    
    override func didEvaluateActions() {
        deleteOutOFBoundsMeteors()
    }
    
    func gameHalt() {
        print("game halted")
        gameState = .halted
        gameDelegate?.collisionOccured()
    }
    
    func gameOver() {
        print("game over")
        gameState = .lost
        gameDelegate?.gameOver()
        removeAllActions()
        removeMeteors()
        NotificationCenter.default.removeObserver(self)
    }
    
    //===============================
    // MARK: - collision detection
    //===============================
    
    func didBegin(_ contact: SKPhysicsContact) {
        if case .onGoing = self.gameState {
            _ = self.animateCrash()
            checkLifes()
        }
    }
    
    
    func checkLifes() {
        print("Check Lifes !!!")
        stopMeteors()
        removeAction(forKey: "meteorSpawnAction")
        lifes -= 1
        if lifes == 0 {
            gameOver()
        } else {
            gameHalt()
        }
    }
    
    func animateCrash() -> Bool {
        stopSpaceShipAnimation()
        
        switch ParameterDataManager.sharedInstance.explosionType {
        case .animatedCrash:
            crash.position = spaceShip.position
            crash.zPosition = 1.0
            crash.isHidden = false
            let increase = SKAction.scale(to: 1.0, duration: 0.5)
            let decrease = SKAction.scale(to: 0.5, duration: 0.3)
            let sequence = [increase, decrease]
            crash.run(SKAction.sequence(sequence))
            crash.run(SKAction.wait(forDuration: 3.0))
            //run(asteroidCollisionSoundAction)
            //[SKAction group:@[SKAction1, SKAction2, SKAction3]];
            
        default:
            stopSpaceShipAnimation()
            explosion(pos: spaceShip.position)
            // run(asteroidCollisionSoundAction)
            
        }
        return true
    }
    
    
    func explosion(pos: CGPoint) {
        
        let emitterNode = SKEmitterNode(fileNamed: "ExplosionParticle.sks")
        emitterNode?.particlePosition = pos
        self.addChild(emitterNode!)
        
        self.run(SKAction.wait(forDuration: 2), completion: { emitterNode?.removeFromParent()})
    }
    
    
    //==================
    // MARK: - SpaceShip
    //==================
    
    public  func startSpaceShipAnimation() {
        if spaceShip.action(forKey: "spaceShipAnimation") == nil {
            spaceShip.run (SKAction.repeatForever(spaceShipAnimation), withKey: "spaceShipAnimation")
        }
    }
    
    public  func stopSpaceShipAnimation() {
        spaceShip.removeAllActions()
    }
    
    private  func slideTo(sprite: SKSpriteNode, x: CGFloat) {
        let actionSlide = SKAction.move(to: CGPoint(x: x, y: sprite.position.y), duration: 0.2)
        sprite.run(actionSlide)
    }
    
    //==================
    // MARK: - Meteors
    //==================
    
    private func spawnMeteors() {
        let i = Int(arc4random_uniform(5))
        let meteor = SKSpriteNode(imageNamed: "Games/SpaceshipGame/meteor_0\(i)")
        meteor.name = "meteor"
        
        meteor.position = CGPoint(
            x: CGFloat.random(
                min: 0 + meteor.size.width/2,
                max: size.width - meteor.size.height/2),
            y: size.height
        )
        
        let rotationSpeed = CGFloat.random(min: CGFloat(-2.5), max: CGFloat(2.5))
        
        // Add physics body for collision detection
        meteor.physicsBody?.isDynamic = true
        meteor.physicsBody = SKPhysicsBody(texture: meteor.texture!, size: meteor.size)
        meteor.physicsBody?.affectedByGravity = false
        meteor.physicsBody?.categoryBitMask = collisionMeteorCategory
        meteor.physicsBody?.contactTestBitMask = collisionSpaceShipCategory
        
        meteor.physicsBody?.collisionBitMask = 0x0
        
        addChild(meteor)
        
        let actionMoveDown = SKAction.moveBy(x: 0, y: CGFloat(-5 * meteorAccelerationFactor), duration: 0.01)
        
        let rotateAction = SKAction.rotate(byAngle: rotationSpeed * CGFloat.pi, duration: 4)
        meteor.run(SKAction.repeatForever(rotateAction))
        meteor.run(SKAction.repeatForever(actionMoveDown))
    }
    
    private func stopMeteors() {
        enumerateChildNodes(withName: "meteor") { node, _ in
            let meteor = node as! SKSpriteNode
            meteor.removeAllActions()
        }
    }
    private func removeMeteors() {
        for node in self.children {
            if node.name == "meteor" {
                node.removeFromParent()
            }
        }
    }
    
    private func deleteOutOFBoundsMeteors() {
        enumerateChildNodes(withName: "meteor") { node, _ in
            if node.position.y < 0 {
                node.removeFromParent()
            }
        }
    }
    
    //============================
    // MARK: - Notification Center
    //============================
    
    private func setupNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(loadParameters),
                                               name: Notification.Name(rawValue: L10n.Notif.Parameter.update),
                                               object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateData(_:)),
                                               name: Notification.Name(rawValue: L10n.Notif.Ble.dataReceived),
                                               object: nil)
        
    }
    
    
    @objc func updateData(_ notification: Notification) {
        var leftAction: Bool = false
        var rightAction: Bool = false
        
        switch ParameterDataManager.sharedInstance.sensorType {
        case .joystick:
            leftAction = SensorInputManager.sharedInstance.joystickInput.left
            rightAction = SensorInputManager.sharedInstance.joystickInput.right
        default:
            // The strength is in [0...1000] -> Have it fit into [0...100]
            let strengthValue1 = SensorInputManager.sharedInstance.musclesInput.muscle1 / 10
            let strengthValue2 = SensorInputManager.sharedInstance.musclesInput.muscle2 / 10
            leftAction = strengthValue2 > 50
            rightAction = strengthValue1 > 50
        }
        
        analyseActions(leftAction: leftAction, rightAction: rightAction)
    }
    
    
    //=======================
    // MARK: - touch handling
    //=======================
    
    func sceneTouched(touchLocation: CGPoint) {
        if  gameState == .onGoing && ParameterDataManager.sharedInstance.demoMode {
            slideTo(sprite: spaceShip, x: touchLocation.x)
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
    
    
    //  stars..
    
    func spaceStarEmitter(color: SKColor, starSpeedY: CGFloat, starsPerSecond: CGFloat, starScaleFactor: CGFloat) -> SKEmitterNode {
        
        // Determine the time a star is visible on screen
        let lifetime =  frame.size.height * UIScreen.main.scale / starSpeedY
        
        // Create the emitter node
        let emitterNode = SKEmitterNode()
        emitterNode.particleTexture = SKTexture(imageNamed: "Star.jpg")
        emitterNode.particleBirthRate = starsPerSecond
        emitterNode.particleColor = SKColor.lightGray
        emitterNode.particleSpeed = starSpeedY * -1
        emitterNode.particleScale = starScaleFactor
        emitterNode.particleColorBlendFactor = 1
        emitterNode.particleLifetime = lifetime
        
        // Position in the middle at top of the screen
        emitterNode.position = CGPoint(x: frame.size.width/2, y: frame.size.height)
        emitterNode.particlePositionRange = CGVector(dx: frame.size.width, dy: 0)
        
        // Fast forward the effect to start with a filled screen
        emitterNode.advanceSimulationTime(TimeInterval(lifetime))
        
        return emitterNode
        
    }
    
    
    @objc func loadParameters() {
        switch ParameterDataManager.sharedInstance.asteriodVelocity {
        case .average:
            meteorAccelerationFactor = 1.5
        case .fast:
            meteorAccelerationFactor = 2.0
        default:
            meteorAccelerationFactor = 1.0
        }
    }
}
