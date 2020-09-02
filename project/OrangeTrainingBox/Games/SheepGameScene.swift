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

//
//  SheepGameScene.swift
//  3DHandz
//
//  Created by Frederique Pinson on 21/08/2018.
//  Copyright © 2018 Orange. All rights reserved.
//

import SpriteKit

class SheepGameScene: SKScene, GameScene, ParametersDefaultable {
    
    weak var title: UILabel?
    weak var subtitle: UILabel?
    weak var feedback: UILabel?
    weak var scoreLabel: UILabel?
    weak var button: UIButtonBordered?
    weak var gameSceneDelegate: GameSceneDelegate?
    
    let happySheep = SKSpriteNode(imageNamed: Asset.Games.SheepGame.bigSheep.name)
    let sheep = SKSpriteNode(imageNamed:  Asset.Games.SheepGame.sheep1.name)
    let fence = SKSpriteNode(imageNamed: Asset.Games.SheepGame.sheepGate.name)
    let ground = SKSpriteNode(imageNamed: Asset.Games.SheepGame.sheepGround.name)
    let bang = SKSpriteNode(imageNamed: Asset.Games.SheepGame.sheepBang.name)
    
    var sheepWalkingTexture: SKTexture?
    var sheepBumpTexture: SKTexture?
    var sheepJumpTexture: SKTexture?
    var sheepGameOverTexture: SKTexture?
    
    let walkingSheepAnimation: SKAction
    let gameWonAnimation: SKAction
    
    var gameObjective : Int = 1
    var successfullJumps: Int = 0
    var hasSheepStartedJumping = false
    var nbDisplayedFences : Int = 0
    var strengthValue : Int = 0
    
    var lastUpdateTime: TimeInterval = 0
    var dt: TimeInterval = 0
    var velocity = CGPoint.zero
    var threshold : Int = 0
    var speedRate : Int = 1
    var maxHeigthJump: CGFloat
    let groundPosition = CGPoint(x: 0, y: 768.0)
    // AKA CGPoint(x: size.width/2 - ground.size.width/2, y: size.height/2 - size.height/8)
    
    var isGameOnGoing: Bool {
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
                successfullJumps = 0
                nbDisplayedFences = 0
                configureLabelsForStart()
                configureSpritesForStart()
                
            case .onGoing:
                break
                
            case .halted: // should not occur in this game
                break
                
            case .ended(let Score):
                if Score.total >= 0 {
                    gameOver()
                }
                else if Score.total == -1 {
                    bang.isHidden = false
                    configureLabelsForCollision()
                    }
            }
        }
    }
    
    // MARK: - init
    
    override init(size: CGSize) {
        
        gameWonAnimation = createAnimationFromImages(imageNames: [Asset.Games.SheepGame.bigSheep2.name, Asset.Games.SheepGame.bigSheep.name], timing: 0.1)
        walkingSheepAnimation = createAnimationFromImages(imageNames: [Asset.Games.SheepGame.sheep1.name, Asset.Games.SheepGame.sheep2.name], timing: 0.1)
        maxHeigthJump = 0.0
        state = .notStarted
        super.init(size: size)
        loadParameters()
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
    
    
    // MARK: - SKView
    override func willMove(from view: SKView) {
        super.willMove(from: view)
        removeAllActions()
        for node in self.children {
            node.removeFromParent()
        }
        unloadTextures()
        unsetNotifications()
    }
    
    override func didMove(to view: SKView) {
        backgroundColor = Asset.Colors.pinky.color
        state = .notStarted
        
        addChild(sheep)
        addChild(fence)
        addChild(ground)
        addChild(bang)
        addChild(happySheep)
        maxHeigthJump = size.height - sheep.size.height - groundPosition.y
        startWalkingSheepAnimation()
        loadTextures()
        setupNotificationCenter()
    }
    
    func loadTextures() {
        sheepWalkingTexture = SKTexture (imageNamed: Asset.Games.SheepGame.sheep1.name)
        sheepBumpTexture = SKTexture(imageNamed: Asset.Games.SheepGame.sheepBump.name)
        sheepJumpTexture = SKTexture(imageNamed: Asset.Games.SheepGame.sheepJump.name)
        sheepGameOverTexture = SKTexture(imageNamed: Asset.Games.SheepGame.bigSheep.name)
    }
    
    func unloadTextures() {
        sheepWalkingTexture = nil
        sheepBumpTexture = nil
        sheepJumpTexture = nil
        sheepGameOverTexture = nil
    }
    
    func configureSpritesForStart() {
        ground.anchorPoint = CGPoint.zero
        ground.position = groundPosition
        ground.size.width = size.width
        ground.isHidden = false
        
        fence.anchorPoint = CGPoint.zero
        fence.position = CGPoint(x: size.width, y: ground.position.y)
        fence.zPosition = -1
        fence.isHidden = false
        
        happySheep.anchorPoint = CGPoint(x:0.0, y:1.0)
        happySheep.isHidden = true
        happySheep.position = CGPoint(x: size.width/2 - happySheep.size.width/2, y: size.height)// ground.position.y)
        hideHappySheep()
        
        sheep.anchorPoint = CGPoint.zero
        sheep.position = CGPoint(x: size.width/2 - sheep.size.width/2, y: ground.position.y )
        sheep.zPosition = -2
        sheep.isHidden = false
        
        bang.anchorPoint = CGPoint.zero
        bang.position = CGPoint.zero
        bang.isHidden = true
    }
    
    
    // MARK: - User's interactions
    func onButtonPressed() {
        button?.setTitle(L10n.Game.go, for: .normal)
        startGame()
    }
    
    
    func startGame() {
        configureSpritesForStart()
        hasSheepStartedJumping = false
        successfullJumps = 0
        nbDisplayedFences = 0
        startWalkingSheepAnimation()
        state = .onGoing
    }
    
    // MARK: - Game loop
    
    override func update(_ currentTime: TimeInterval) {
        if lastUpdateTime > 0 {
            dt = currentTime - lastUpdateTime
        } else {
            dt = 0
        }
        lastUpdateTime = currentTime
        
        if !isGameOnGoing {
            return
        }
        if isSheepOnGround() {
            startWalkingSheepAnimation()
        } else {
            stopWalkingSheepAnimation()
            sheep.texture = sheepJumpTexture
        }
        if isThereCollision() {
            showCollision()
            state = .ended(Score(won: false, total: -1))
        } else {
            moveFence()
            checkSheepAndFencePositions()
            checkDisplayedFences()
        }
    }
    
    
    private func isThereCollision() -> Bool {
        return fence.frame.intersects(sheep.frame)
    }
    
    private func showCollision() {
        stopWalkingSheepAnimation()
        sheep.texture = sheepBumpTexture
        bang.position = CGPoint (x: sheep.position.x + 350,
                                 y: sheep.position.y + 400)
    }
    
    func checkDisplayedFences() {
        if nbDisplayedFences == gameObjective {
            print("GAME OVER : \(successfullJumps)")
         state = .ended(Score(won: true, total: successfullJumps))
        }
    }
    func checkSheepAndFencePositions() {
        if isSheepOnGround() {
            if isSheepBeyondTheFence() && hasSheepStartedJumping {
                successfullJumps += 1
//                if successfullJumps == gameObjective {
//                    state = .ended(Score(won: true, total: successfullJumps))
//                } else {
                    configureScoreLabel(with: successfullJumps)
                    configureLabelsForWalking()
                //}
            } else {
                configureLabelsForWalking()
            }
            hasSheepStartedJumping = false
        }
        else {
            hasSheepStartedJumping = true
            configureLabelsForJumpInProgress()
        }
    }
    
    func moveFence() {
        ensureFenceIsWithinBounds()
        //if nbDisplayedFences < gameObjective {
            fence.position.x -= CGFloat(2 * speedRate)
        //}
        
    }
    private func ensureFenceIsWithinBounds() {
        if fence.position.x <= 2.0 {
            fence.position.x = size.width - 5
            nbDisplayedFences += 1
        }
    }
    
    func isSheepOnGround() -> Bool {
        return sheep.position.y == groundPosition.y
    }
    
    func isSheepBeyondTheFence() -> Bool {
        return  fence.position.x < size.width/2 - sheep.size.width/2
    }
    
    
    func gameOver () {
        stopWalkingSheepAnimation()
        sheep.isHidden = true
        bang.isHidden = true
        ground.isHidden = true
        fence.isHidden = true
        showHappySheep()
        configureLabelsForGameOver()
    }
    
    func showHappySheep() {
        happySheep.isHidden = false
        happySheep.size.height = (happySheep.texture?.size().height)! * 1.2
        happySheep.size.width = (happySheep.texture?.size().width)! * 1.2
        happySheep.position = CGPoint(x:(happySheep.texture?.size().width)! * 0.5, y: size.height)
        
        happySheep.anchorPoint  = CGPoint(x: 0.5 , y: 1.0)
        happySheep.run(gameWonAnimation)
        happySheep.run(SKAction.wait(forDuration: 3.0))
        startGameWonAnimation()
    }
    
    func hideHappySheep() {
        happySheep.isHidden = true
        stopGameWonAnimation() // should be in another scene
    }
    
    
    
    
    // MARK: - data processing
    
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
        guard isGameOnGoing  && !ParameterDataManager.sharedInstance.demoMode else {
            return
        }
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
            if heightConstraint < 0 { heightConstraint = 0 }
            let jumpheightWithConstraint = groundPosition.y + (maxHeigthJump * heightConstraint)
            jumpTo(sprite: sheep, height: jumpheightWithConstraint)
        }
    }
    
    // MARK: - Labels configuration
    
    func configureScoreLabel(with score: Int) {
        switch score {
        case 0:
            scoreLabel?.text = gameObjective == 1 ? L10n.Game.Sheep.Score.Start.one:
                L10n.Game.Sheep.Score.Start.many(gameObjective)
        case 1:
            scoreLabel?.text = L10n.Game.Sheep.Score.Pending.one(gameObjective)
        default:
            scoreLabel?.text = L10n.Game.Sheep.Score.Pending.many(score, gameObjective)
        }
    }
    
    func configureLabelsForStart() {
        title?.text = L10n.Game.Sheep.Text.Jump.first
        switch ParameterDataManager.sharedInstance.sensorType {
        case .joystick:
            subtitle?.text = L10n.Game.Sheep.Text.Jump.secondJoystick
        default:
            subtitle?.text = L10n.Game.Sheep.Text.Jump.second
        }
        button?.setTitle(L10n.Game.start, for: .normal)
        button?.isHidden = false
        configureScoreLabel(with: 0)
    }
    
    
    func configureLabelsForWalking() {
        scoreLabel?.isHidden = false
        title?.isHidden  = true
        subtitle?.isHidden  = true
        button?.isHidden = true
    }
    
    func configureLabelsForJumpInProgress() {
        scoreLabel?.isHidden = false
        title?.isHidden = false
        title?.text = L10n.Game.hop
        subtitle?.isHidden = true
        button?.isHidden = true
    }
    
    func configureLabelsForCollision() {
        title?.isHidden = true
        subtitle?.isHidden = true
        scoreLabel?.isHidden = true
        button?.setTitle(L10n.Game.reStart, for: .normal)
        button?.isHidden = false
        
    }
    
    func configureLabelsForGameOver() {
        
        if successfullJumps == gameObjective {
            title?.text = L10n.Game.congrats
            subtitle?.text = L10n.Game.Sheep.Score.Result.win
        } else {
          title?.text = L10n.Game.oops
          subtitle?.text = L10n.Game.Sheep.Score.Result.notEnough(successfullJumps, gameObjective)
        }
        configureScoreLabel(with: 0)
        scoreLabel?.isHidden = true
        title?.isHidden = false
        subtitle?.isHidden = false
        button?.setTitle(L10n.Game.reStart, for: .normal)
        button?.isHidden = false
    }
    
    // MARK: - sprite moves
    
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
    
    func getNewPosition(from position : CGPoint) -> CGFloat {
        
        let heightConstraint = CGFloat (300 * hardnessCoeff)
        var newPosition = position.y - heightConstraint
        
        if newPosition < ground.position.y {
            newPosition = ground.position.y
        }
        return newPosition
    }
    
    
    // MARK: - Animations
    func startWalkingSheepAnimation() {
        if sheep.action(forKey: "walkingSheepAnimation") == nil {
            sheep.run(
                SKAction.repeatForever(walkingSheepAnimation),
                withKey: "walkingSheepAnimation")
        }
    }
    
    func stopWalkingSheepAnimation() {
        if sheep.action(forKey: "walkingSheepAnimation") != nil {
            sheep.removeAction(forKey: "walkingSheepAnimation")
        }
    }
    
    
    func startGameWonAnimation() {
        if happySheep.action(forKey: "gameWonAnimation") == nil {
            happySheep.run(
                SKAction.repeatForever(SKAction.sequence([SKAction.wait(forDuration: 3.0), gameWonAnimation])),
                withKey: "gameWonAnimation")
        }
    }
    
    func stopGameWonAnimation() {
        if sheep.action(forKey: "gameWonAnimation") != nil {
            happySheep.removeAction(forKey: "gameWonAnimation")
        }
    }
    
    
    
    // MARK: - helpers
    
    private func ensureSheepIsWithinBounds(_ location: CGPoint) -> CGPoint {
        var position  = location
        if position.y < groundPosition.y  {
            position.y = groundPosition.y
        }
        else if position.y > size.height - sheep.size.height   {
            position.y = size.height - sheep.size.height
        }
        return position
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
    
    private func unsetNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    
    // MARK: - touch handling
    
    func sceneTouched(touchLocation: CGPoint) {
        guard isGameOnGoing && ParameterDataManager.sharedInstance.demoMode else {
            return
        }
        let  position = ensureSheepIsWithinBounds(touchLocation)
        if !(fence.frame.intersects(sheep.frame)) && position.y > ground.position.y  {
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
    
    
    // MARK: - Parameters
    
    @objc func loadParameters () {
        threshold = ParameterDataManager.sharedInstance.threshold
        gameObjective = ParameterDataManager.sharedInstance.numberOfFences
        
        switch ParameterDataManager.sharedInstance.fenceVelocity {
        case .slow:
            speedRate = 1
        case .average:
            speedRate = 2
        default:
            speedRate = 3
        }
        // needed ??
        if !isGameOnGoing {
            configureScoreLabel(with: 0)
        }
    }
}
