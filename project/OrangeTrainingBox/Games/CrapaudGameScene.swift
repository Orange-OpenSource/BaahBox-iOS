//
//  CrapaudGameScene.swift
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

struct GameConstants {
    static let toadJumpTime = Double(0.1)
    static let flyAppearTime = Double(0.3)
    static let flyDisappearTime = Double(0.3)
    static let toadMaxAngle = Double(1.5)
}

class CrapaudGameScene: SKScene, SKSceneDelegate {
    
    let dataManager = ParameterDataManager.sharedInstance
    
    var shouldStartGame = false
    var isGameStarted = false
    var playToadAnimation = false
    var visibleWidth: CGFloat = 0
    var hidenMargin: CGFloat = 0
    
    var gameDelegate: CrapaudGameInteractable!
    
    
    let crapaud = SKSpriteNode(imageNamed: Asset.Games.CrapaudGame.toad.name)
    let crapaudBottomPosition: CGPoint
    let crapaudLangue = SKSpriteNode()
    var isToadJumping = false
    var autoShoot = false
    var flyStayingTime: Double = 0
    var lastShootTime: DispatchTime = .now()
    
    let fly = SKSpriteNode(imageNamed: Asset.Games.CrapaudGame.fly.name)
    let flyMaxSize: CGSize
    var flyDistance: CGFloat = 0
    var flyAngle: CGFloat = 0
    var flyPosition = CGPoint()
    var flyCaughtAngle = CGFloat.pi
    var isFlyThere = false
    
    override init(size: CGSize) {
        crapaudBottomPosition = CGPoint(x: size.width/2, y: size.height/4)
        crapaud.anchorPoint = CGPoint(x: 0.5, y: 0)
        crapaud.texture = SKTexture (imageNamed: Asset.Games.CrapaudGame.toad.name)
        crapaud.position = crapaudBottomPosition
        crapaud.setScale(0)
        crapaud.zPosition = 1


        crapaudLangue.anchorPoint = CGPoint(x: 0.5, y: 0)
        crapaudLangue.position = crapaudBottomPosition
        crapaudLangue.setScale(0)
        crapaudLangue.zPosition = 0  //@@@

        flyMaxSize = fly.size
        
        super.init(size: size) //TODO: change the size according to texture !
        backgroundColor = Asset.Colors.greyGreen.color
        loadParameters()
        addChild(crapaud)
        addChild(crapaudLangue)
        addChild(fly)
        delegate = self
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented") // 6
    }
    
    private func createTongue(length: CGFloat) -> UIImage {
        guard let langueImage = UIImage(named: Asset.Games.CrapaudGame.tongue.name), length > 0 else {
            return UIImage()
        }
        let newWidth = langueImage.size.width
        let newHeight = length
        let newSize = CGSize(width: newWidth, height: newHeight)
    
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        langueImage.draw(in: CGRect(origin: CGPoint.zero, size: langueImage.size))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return newImage
    }
    override func willMove(from view: SKView) {
        super.willMove(from: view)
        print("Toad scene willMoveFromView")
        removeAllActions()
        for node in self.children {
            node.removeFromParent()
        }

        self.physicsWorld.contactDelegate = nil
        self.delegate = nil
        NotificationCenter.default.removeObserver(self)
    }
    
    override func didMove(to view: SKView) {
        crapaud.run(.scale(to: 0.75, duration: 1))
        setupNotificationCenter()
        startCrapaudAnimation()
        playToadAnimation = true
        flyAnimation()
//        run(.repeatForever(.sequence([
//            .wait(forDuration: gameConstants.flyAppearTime + flyStayingTime + gameConstants.flyDisappearTime + 2.1),
//            .run { [weak self] in self?.flyAnimation() },
//        ])))
    }
    
    // --------------- //
    // SKSceneDelegate //
    // --------------- //
    
//    override func didEvaluateActions() {
//        print("1 flyAngle \(flyAngle)  --  crapaudOrientation \(crapaud.zRotation)")
//    }
//
//    func didEvaluateActions(for scene: SKScene) {  //called after the animation in frame
////        print("2 flyAngle \(flyAngle)  --  crapaudOrientation \(crapaud.zRotation)")
//    }
    
    func update(_ currentTime: TimeInterval, for scene: SKScene) {
//        print("3 flyAngle \(flyAngle)  --  crapaudOrientation \(crapaud.zRotation)")
        isFlyThere = /*(hypot(fly.position.x - flyPosition.x, fly.position.y - flyPosition.y) < 0.1) &&*/ (fly.xScale > 0.99)
        isToadJumping = (crapaud.position.y - crapaudBottomPosition.y) > 1
        if abs(-crapaud.zRotation - flyAngle) < 0.011 && flyAngle != flyCaughtAngle && isFlyThere && !isToadJumping && autoShoot {
            print("-----> FLY 1! ")
            shootTongue(angle: flyAngle)
            flyCaughtAngle = flyAngle
        }
    }
    
    
    // ------- //
    // Actions //
    // ------- //
    
    private func startCrapaudAnimation() {
        crapaud.removeAllActions()
        print("-----> toad init! ")
        crapaud.run(.sequence([
            initToadAnimations,
            toadBlinkAnimation
//            .run {self.autoShoot = true},
//            .group([
////                rotateAnimation,
//                toadBlinkAnimation
//            ])
        ]))
    }
    
//    private var rotateAnimation: SKAction {
//        return .repeatForever(.sequence([
//            .rotate(byAngle: CGFloat.pi/4, duration: 1),
//            .rotate(byAngle: -CGFloat.pi/2, duration: 2),
//            .rotate(byAngle: CGFloat.pi/4, duration: 1)
//        ]))
//    }
    
    private var toadBlinkAnimation: SKAction {
        return .repeatForever(.sequence([
            .wait(forDuration:2.5),
            .setTexture(SKTexture(imageNamed: Asset.Games.CrapaudGame.toadBlink.name)),
            .wait(forDuration: 0.1),
            .setTexture(SKTexture(imageNamed: Asset.Games.CrapaudGame.toad.name)),
            .wait(forDuration: 0.3),
            .setTexture(SKTexture(imageNamed: Asset.Games.CrapaudGame.toadBlink.name)),
            .wait(forDuration: 0.1),
            .setTexture(SKTexture(imageNamed: Asset.Games.CrapaudGame.toad.name))
        ]))
    }
    
    func startGame () {
        shouldStartGame = true
        playToadAnimation = false
        crapaud.removeAllActions()
        print("-----> toad init! ")
        crapaud.run(initToadAnimations) { [weak self] in self?.flyRestart() }
        crapaud.run(toadBlinkAnimation)
    }
    
    func stopGame() {
        isGameStarted = false
        playToadAnimation = false
        shouldStartGame = false
        startCrapaudAnimation()
    }
    
    func disableGame() {
        stopGame()
        fly.removeAllActions()
        crapaud.removeAllActions()
    }
    
    private var initToadAnimations: SKAction {
        return .sequence([
            .setTexture(SKTexture(imageNamed: Asset.Games.CrapaudGame.toad.name)),
            .group([
                .rotate(toAngle: 0, duration: 1, shortestUnitArc: true),
                .move(to: crapaudBottomPosition, duration: 1),
                .scale(to: 0.75, duration: 1)
            ])
        ])
    }
    

    // ---------- //
    // Animations //
    // ---------- //
    private func flyAnimation() {
        guard let view = view else {
            return
        }
        isGameStarted = shouldStartGame
        autoShoot = (ParameterDataManager.sharedInstance.shootingType == .automatic) && isGameStarted
        flyStayingTime = Double(ParameterDataManager.sharedInstance.flySteadyTime)
        visibleWidth = size.height * view.bounds.width / view.bounds.height
        hidenMargin = (size.width - visibleWidth) / 2
        flyDistance = CGFloat.random(min: size.height / 3, max: 17 * size.height / 24)
        let angleMax = CGFloat(limitedAsin(Double((visibleWidth / 2 - flyMaxSize.width) / flyDistance), angleLimit: GameConstants.toadMaxAngle - 0.1))
        flyAngle = CGFloat.random(min: -angleMax, max: angleMax)
        let stopPosition = CGPoint(
            x: CGFloat.random(
                min: hidenMargin + flyMaxSize.width,
                max: hidenMargin + visibleWidth - flyMaxSize.width),
            y: size.height + flyMaxSize.height
        )
        flyPosition = CGPoint(
            x: crapaudBottomPosition.x + sin(flyAngle) * flyDistance,
            y: crapaudBottomPosition.y + cos(flyAngle) * flyDistance)
        
        fly.run(.sequence([
            .scale(to: 0, duration: 0),
            .move(to: flyPosition, duration: 0),
            .scale(to: 1, duration: GameConstants.flyAppearTime),
            .run { self.turnToad() },
            .wait(forDuration: flyStayingTime),
            .group([
                .move(to: stopPosition, duration: GameConstants.flyDisappearTime),
                .scale(to: 0, duration: GameConstants.flyDisappearTime)
            ]),
            .wait(forDuration: 0.1)
            ])) { [weak self] in self?.flyAnimation() }
    }
    
    private func limitedAsin(_ value: Double, angleLimit: Double = Double.pi/2) -> Double {
        guard value < 1 else {
            return angleLimit
        }
        guard value > -1 else {
            return -angleLimit
        }
        let angle = asin(value)
        return max(min(angle, angleLimit), -angleLimit)
    }
    
    private func turnToad() {
        if !playToadAnimation {
            return
        }
        let turnSpeed = CGFloat.pi/8
        let waitBeforeTurn = 0.4
        let waitBeforeShoot = 0.2
        let toadAngle = -crapaud.zRotation
        let maxTime = flyStayingTime - waitBeforeTurn
        let maxAngle = CGFloat(maxTime) * turnSpeed
        let maxAngle2 = CGFloat(maxTime + 0.2) * turnSpeed
        let angleToTurn = flyAngle - toadAngle
        print("@@@ toadAngle: \(toadAngle), flyAngle: \(flyAngle), maxAngle: \(maxAngle), angleToTurn: \(angleToTurn), maxTime: \(maxTime)")
        if abs(angleToTurn) > maxAngle { // wont reach the fly but turns
            crapaud.run(.sequence([
                .wait(forDuration: waitBeforeTurn),
                .rotate(byAngle: angleToTurn < 0 ? maxAngle2 : -maxAngle2, duration: maxTime)
            ]))
        } else {
            let turnTime = TimeInterval(abs(angleToTurn) / turnSpeed)
            print("@@@ turnTime: \(turnTime)")
            crapaud.run(.sequence([
                .wait(forDuration: waitBeforeTurn),
                .rotate(toAngle: -flyAngle, duration: turnTime, shortestUnitArc: true),
                .wait(forDuration: waitBeforeShoot),
                .run { self.shootTongue(angle: self.flyAngle)}
            ]))
        }
    }
    
    private func turnLeft() {
        crapaud.zRotation = min(crapaud.zRotation + 0.02, CGFloat(GameConstants.toadMaxAngle))
    }
    
    private func turnRight() {
        crapaud.zRotation = max(crapaud.zRotation - 0.02, CGFloat(-GameConstants.toadMaxAngle))
    }
    
    private func shootTongue(angle: CGFloat) {
        let jumpLength = flyDistance/3
        let adjustedLangueImage = createTongue(length: flyDistance - jumpLength)
        crapaudLangue.size = adjustedLangueImage.size
        let tongueTexture = SKTexture(image: adjustedLangueImage)
        crapaudLangue.texture = tongueTexture
        crapaudLangue.setScale(1)
        crapaudLangue.zRotation = -angle
//        crapaudLangue.physicsBody = SKPhysicsBody(texture: tongueTexture, size: tongueTexture.size())
        let jump1 = CGVector(dx: sin(angle) * jumpLength, dy: cos(angle) * jumpLength)
        let jump2 = CGVector(dx: -jump1.dx, dy: -jump1.dy)
        
        let jumpUp = SKAction.move(by: jump1, duration: GameConstants.toadJumpTime)
        let jumpDown = SKAction.move(by: jump2, duration: GameConstants.toadJumpTime)
        crapaud.run(.sequence([jumpUp, jumpDown]))
        crapaudLangue.run(.sequence([jumpUp, jumpDown, .scale(to: 0, duration: GameConstants.toadJumpTime)]))
        if abs(angle - flyAngle) < 0.05 && isFlyThere {
            if isGameStarted {
                flyCaught()
            } else {
                flyRestart()
            }
        }
    }
    
    private func flyRestart() {
        fly.removeAllActions()
        fly.run(.sequence([
            .wait(forDuration: GameConstants.toadJumpTime),
            .scale(to: 0, duration: 0.03),
            .wait(forDuration: 0.1)
            ])) {
                [weak self] in
                self?.flyAnimation()
        }
    }
    
    private func flyCaught() {
        fly.removeAllActions()
        let endPosition = gameDelegate.nextScoreFlyCenterScenePosition
        fly.run(.sequence([
            .wait(forDuration: GameConstants.toadJumpTime),
            .scale(to: 0, duration: 0.03),
            .move(to: crapaudBottomPosition, duration: 0),
            .scale(to: 1, duration: 0.03),
            .move(to: endPosition, duration: 0.5),
            .wait(forDuration: 0.1)
            ])) {
                [weak self] in
                if self?.isGameStarted ?? false {
                    self?.gameDelegate.flyCaught()
                }
                self?.flyAnimation()
        }
    }
    
    // MARK: - touch handling
    //======================================
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        analyseTouches(touches)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        analyseTouches(touches)
    }
    
    private func analyseTouches(_ touches: Set<UITouch>) {
        var touchesLocal = touches
        var leftAction = false
        var rightAction = false
        guard let touch1 = touchesLocal.popFirst() else {
            return
        }
        let touchLocation1 = touch1.location(in: self)
        if let touch2 = touchesLocal.popFirst() {
            let touchLocation2 = touch2.location(in: self)
            leftAction = touchLocation1.x < crapaudBottomPosition.x  || touchLocation2.x < crapaudBottomPosition.x
            rightAction = touchLocation1.x > crapaudBottomPosition.x  || touchLocation2.x > crapaudBottomPosition.x
        } else {
            leftAction = touchLocation1.x < crapaudBottomPosition.x
            rightAction = touchLocation1.x > crapaudBottomPosition.x
        }
        analyseActions(leftAction: leftAction, rightAction: rightAction)
    }
    
    private func analyseActions(leftAction: Bool, rightAction: Bool) {
        if !isGameStarted {
            return
        }
        if leftAction && rightAction {
            let currentTime = DispatchTime.now()
            let shootInterval = Double(currentTime.uptimeNanoseconds - lastShootTime.uptimeNanoseconds) / 1_000_000_000
            if !isToadJumping && !autoShoot && shootInterval > 3 * GameConstants.toadJumpTime {
                lastShootTime = currentTime
                print("-----> FLY 2! ")
                shootTongue(angle: -crapaud.zRotation)
            }
            return
        }
        if leftAction && !isToadJumping {
            turnLeft()
            return
        }
        if rightAction && !isToadJumping {
            turnRight()
            return
        }
    }
    // MARK: - Notification Center
    
    private func setupNotificationCenter() {
        
        // Parameter update
        NotificationCenter.default.addObserver(self, selector: #selector(loadParameters),
                                               name: NSNotification.Name(rawValue: L10n.Notif.Parameter.update),
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
            if SensorInputManager.sharedInstance.joystickInput.up {
                leftAction = true
                rightAction = true
            } else {
                leftAction = SensorInputManager.sharedInstance.joystickInput.left
                rightAction = SensorInputManager.sharedInstance.joystickInput.right
            }
        default:
            // The strength is in [0...1000] -> Have it fit into [0...100]
            let strengthValue1 = SensorInputManager.sharedInstance.musclesInput.muscle1 / 10
            let strengthValue2 = SensorInputManager.sharedInstance.musclesInput.muscle2 / 10
            leftAction = strengthValue2 > 50
            rightAction = strengthValue1 > 50
        }
        analyseActions(leftAction: leftAction, rightAction: rightAction)
    }
    
    
    @objc func loadParameters () {

    }

}
