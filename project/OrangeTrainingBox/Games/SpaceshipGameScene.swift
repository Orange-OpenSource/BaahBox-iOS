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

class SpaceshipGameScene: SKScene, GameScene, SKPhysicsContactDelegate {
    
    weak var title: UILabel?
    weak var subtitle: UILabel?
    weak var feedback: UILabel?
    weak var scoreLabel: UILabel?
    weak var button: UIButtonBordered?
    weak var gameSceneDelegate: GameSceneDelegate?
    
    var shipNmlTexture: SKTexture?
    var shipRightTexture: SKTexture?
    var shipLeftTexture: SKTexture?
    
    var spaceShip =  SKSpriteNode(imageNamed: Asset.Games.SpaceshipGame.spaceshipNml.name)
    let spaceShipScale: CGFloat = 0.75
    var spaceShipInitialPosition = CGPoint(x: 0, y: 0)
    
    var spaceShipAnimation = SKAction()
    
    var meteorAccelerationFactor: Double = 1.0
    var meteorSpawnAction = SKAction()
    
    var lastUpdateTime: TimeInterval = 0
    var dt: TimeInterval = 0
    let secondPerScorePoint: TimeInterval = 1.0
    var score: Int = 0
    var lifes: Int = 0
    var lastScoreTime: TimeInterval = 0
    let waitOneSecAction = SKAction.wait(forDuration: 1.0)

    
    
    var isGameOnGoing: Bool {
        if case .onGoing = self.state {
            return true
        }
        return false
    }
    
    var state: GameState {
        didSet {
            switch state {
            case .notStarted:
                //setNavigationBarHidden(true, animated: true)
                configureLabelsForStart()
                score = 0
                lifes = ParameterDataManager.sharedInstance.numberOfSpaceShips
                startSpaceShipAnimation()
                configureSpritesForStart()
                configureSpaceShipCollisionEffects()
                
            case .onGoing:
                stopSpaceShipAnimation()
                configureLabelsForPlay()
                //  setNavigationBarHidden(true, animated: true)
                refreshScore()
                
            case .halted:
                stopSpaceShipAnimation()
                scoreLabel?.isHidden  = false
                button?.isHidden = true
                refreshScore()
            
            case .ended:
                configureLabelsForGameOver()
                refreshScore()
                lifes = ParameterDataManager.sharedInstance.numberOfSpaceShips
            }
            
            gameSceneDelegate?.onChanged(state: state)
        }
    }
    
      let asteroidCollisionSoundAction = SKAction.playSoundFileNamed( "SNCRASH1.wav", waitForCompletion: false)
    var crash = SKSpriteNode(imageNamed: Asset.Games.SpaceshipGame.crash.name)
    var crashAnimation = SKAction()
    
    
    
    // =============
    // MARK: - init
    // =============
    
    override init(size: CGSize) {
        score = 0
        state = .notStarted
       
        super.init(size: size)
        loadParameters()
        loadTextures()
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
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func configure(title: UILabel, subtitle: UILabel, feedback: UILabel?, score: UILabel?,  button: UIButtonBordered, delegate: GameSceneDelegate) {
        self.title = title
        self.subtitle = subtitle
        self.button = button
        self.feedback = feedback
        self.scoreLabel = score
        self.gameSceneDelegate = delegate
        configureLabelsForStart()
    }
    
    
    // ===============
    // MARK: - SKView
    // ===============
    
    override func willMove(from view: SKView) {
        super.willMove(from: view)
        removeAllActions()
        removeAllChildren()
        self.physicsWorld.contactDelegate = nil
        unloadTextures()
        unsetNotifications()
    }
    
    
    override func didMove(to view: SKView) {
        backgroundColor = Asset.Colors.blueGreen.color
        state = .notStarted
        loadTextures()
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
        
        let starEmitterNodes = setStarEmitterNodes() // à effacer lors du didMove ?
        for emitterNode in starEmitterNodes {
            self.addChild(emitterNode)
        }
    }
    
    
    func configureSpritesForStart() {
        spaceShip.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        // spaceShip.texture = shipRightTexture//SKTexture (imageNamed: Asset.Games.SpaceshipGame.spaceshipNml.name)
        spaceShip.setScale(spaceShipScale)
        spaceShipInitialPosition = CGPoint(x: size.width/2, y: size.height/4 + spaceShip.size.height)
        spaceShip.position = spaceShipInitialPosition
        spaceShip.setScale(spaceShipScale)
        spaceShip.name = "ship"
    }
    
    func configureSpaceShipCollisionEffects() {
        let collisionSize = spaceShip.size//CGSize(width: spaceShip.size.width * spaceShipScale, height: spaceShip.size.height * spaceShipScale)
        
        // Add physics body for collision detection
        spaceShip.physicsBody?.isDynamic = true
        spaceShip.physicsBody = SKPhysicsBody(texture: spaceShip.texture!, size: collisionSize)
        spaceShip.physicsBody?.affectedByGravity = false
        spaceShip.physicsBody?.categoryBitMask = collisionSpaceShipCategory
        spaceShip.physicsBody?.contactTestBitMask = collisionMeteorCategory
        
        spaceShip.physicsBody?.collisionBitMask = 0x0
    }
    
    
    
    // ============================
    // MARK: - User's interactions
    // ============================
    
    func onButtonPressed() {
        button?.setTitle(L10n.Game.go, for: .normal)
        switch state {
            
        case .notStarted:
            initializeGame()
            runGame()
            
        case .onGoing:
            gameOver()
        
        case .halted:
            initializeGame()
            runGame()
            
        case .ended:
            initializeGame()
            runGame()
        }
    }
    
    
    // ==============================
    // MARK: - Game logic
    // ==============================
    
    
    func gameHalt() {
        state = .halted
        animateCrash()
        self.run(SKAction.wait(forDuration: 1), completion: { self.runGame()})
    }
    
    func gameOver() {
        self.state = .ended(Score(won:false, total: self.score))
        removeAllActions()
        removeMeteors()
        unsetNotifications()
    }
    
    func initializeGame() {
        score = 0
        loadParameters()
        spaceShip.position = spaceShipInitialPosition
        setupNotifications()
    }
    
    func runGame() {
        crash.isHidden = true
        removeMeteors()
        launchMeteorRain()
        state = .onGoing
    }
    
    
    // ===================
    // MARK: - Game loop
    // ===================
    
    override func update(_ currentTime: TimeInterval) {
        if lastUpdateTime > 0 {
            dt = currentTime - lastUpdateTime
        } else {
            dt = 0
        }
        if !isGameOnGoing {
            lastScoreTime = currentTime
        }
        
        // score is calculated on elapsed time (x seconds = 1 point)
        if (currentTime - lastScoreTime) > secondPerScorePoint, isGameOnGoing {
            score += 1
            lastScoreTime = currentTime
            refreshScore()
        }
        
        lastUpdateTime = currentTime
    }
    
    
    override func didEvaluateActions() {
        deleteOutOFBoundsMeteors()
    }
    
    
    
    
    // ======================
    // MARK: - sprite moves
    // ======================
    
    private func analyseActions(leftAction: Bool, rightAction: Bool) {
        //        if  gameState != .onGoing {
        //            return
        //        }
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
    
    private  func slideTo(sprite: SKSpriteNode, x: CGFloat) {
        let actionSlide = SKAction.move(to: CGPoint(x: x, y: sprite.position.y), duration: 0.2)
        sprite.run(actionSlide)
    }
    
    
    
    // ==============================
    // MARK: - Labels configuration
    // ==============================
    
    ////    private func showScore() {
    ////        guard let scene = scene else { return }
    ////        scoreLabel.text = "Score: \(scene.score)"
    ////    }
    ////
    func refreshScore() {
        guard scene != nil else { return }
        configureScoreLabel(with: score )
        //   gameSceneDelegate.showLifeViews()
    }
    
    func configureLabelsForPlay() {
        title?.isHidden = true
        subtitle?.isHidden = true
        button?.isHidden = false
        button?.setTitle(L10n.Game.stop, for: .normal)
        scoreLabel?.isHidden  = false
    }
    
    func configureScoreLabel(with score: Int) {
        scoreLabel?.text = "Score: \(score)"
    }
    
    func configureLabelsForStart() {
        title?.text = L10n.Game.Space.Text.first
        switch ParameterDataManager.sharedInstance.sensorType {
        case .joystick:
            subtitle?.text = L10n.Game.Space.Text.secondJoystick
        default:
            subtitle?.text = L10n.Game.Space.Text.secondMuscle
        }
        button?.isHidden = false
        button?.setTitle(L10n.Game.start, for: .normal)
        //stopButton.isHidden = true
        scoreLabel?.isHidden = true
        configureScoreLabel(with: 0)
    }
    
    
    func configureLabelsForGameOver() {
        button?.setTitle(L10n.Game.reStart, for: .normal)
        button?.isHidden = false
    }
    
    
    // =================
    // MARK: - Textures
    // =================
    
    func loadTextures() {
        shipNmlTexture = SKTexture(imageNamed:
            Asset.Games.SpaceshipGame.spaceshipNml.name)
        shipRightTexture = SKTexture(imageNamed:
            Asset.Games.SpaceshipGame.spaceshipRight.name)
        shipLeftTexture =  SKTexture(imageNamed:
            Asset.Games.SpaceshipGame.spaceshipLeft.name)
    }
    
    func unloadTextures() {
        shipNmlTexture = nil
        shipRightTexture = nil
        shipLeftTexture =  nil
    }
    
    
    
    
    //====================
    // MARK: - collision
    //====================
    
    func didBegin(_ contact: SKPhysicsContact) {
        if isGameOnGoing {
            animateCrash()
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
    
    func animateCrash() {
        
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
           // run(asteroidCollisionSoundAction)
           // [SKAction group:@[SKAction1, SKAction2, SKAction3]];
            
        default:
            stopSpaceShipAnimation()
            explosion(pos: spaceShip.position)
            // run(asteroidCollisionSoundAction)
        }
    }
    
    
    func explosion(pos: CGPoint) {
        
        let emitterNode = SKEmitterNode(fileNamed: "ExplosionParticle.sks")
        emitterNode?.particlePosition = pos
        self.addChild(emitterNode!)
        
        self.run(SKAction.wait(forDuration: 2), completion: { emitterNode?.removeFromParent()})
    }
    
    
    //====================
    // MARK: - SpaceShip
    //====================
    
    public  func startSpaceShipAnimation() {
        if spaceShip.action(forKey: "spaceShipAnimation") == nil {
            spaceShip.run (SKAction.repeatForever(spaceShipAnimation), withKey: "spaceShipAnimation")
        }
    }
    
    public  func stopSpaceShipAnimation() {
        spaceShip.removeAllActions()
    }
    
    
    //==================
    // MARK: - Meteors
    //==================
    
    func launchMeteorRain() {
        run(meteorSpawnAction, withKey: "meteorSpawnAction")
    }
    
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
    
    
    // =========================
    // MARK: - data processing
    // =========================
    
    @objc func updateData(_ notification: Notification) {
        guard isGameOnGoing  && !ParameterDataManager.sharedInstance.demoMode else {
            return
        }
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
    
    
    //==========================
    // MARK: - Background Stars animation
    //==========================
    
    func setStarEmitterNodes() -> [SKEmitterNode] {
        let starEmitterNodeFront = spaceStarEmitter(color: SKColor.lightGray, starSpeedY: 50, starsPerSecond: 1, starScaleFactor: 0.2)
        starEmitterNodeFront.zPosition = -10
        
        let starEmitterNodeMid = spaceStarEmitter(color: SKColor.gray, starSpeedY: 30, starsPerSecond: 2, starScaleFactor: 0.1)
        starEmitterNodeMid.zPosition = -11
        
        let starEmitterNodeBack = spaceStarEmitter(color: SKColor.darkGray, starSpeedY: 15, starsPerSecond: 4, starScaleFactor: 0.05)
        starEmitterNodeBack.zPosition = -12
        
        return [starEmitterNodeFront,starEmitterNodeMid, starEmitterNodeBack]
    }
    
    
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
    
    
    
    //========================
    // MARK: - touch handling
    //========================
    
    func sceneTouched(touchLocation: CGPoint) {
        guard isGameOnGoing && ParameterDataManager.sharedInstance.demoMode else {
            return
        }
        slideTo(sprite: spaceShip, x: touchLocation.x)
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
    
    
    //============================
    // MARK: - Notification Center
    //============================
    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(loadParameters),
                                               name: Notification.Name(rawValue: L10n.Notif.Parameter.update),
                                               object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateData(_:)),
                                               name: Notification.Name(rawValue: L10n.Notif.Ble.dataReceived),
                                               object: nil)
    }
    
    private func unsetNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
    // ===================
    // MARK: - Parameters
    // ===================
    
    @objc func loadParameters() {
        lifes = ParameterDataManager.sharedInstance.numberOfSpaceShips
        
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
