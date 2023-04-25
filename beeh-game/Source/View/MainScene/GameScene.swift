//
//  GameScene.swift
//  beeh-game
//
//  Created by Thiago Henrique on 30/03/23.
//

import SpriteKit
import GameplayKit
import HorizontalProgressBar

//- MARK: Init Variables

class GameScene: SKScene {
    var capturedLambs: [SKNode] = [SKNode]()
    var cam: SKCameraNode = SKCameraNode()
    private let border: SKSpriteNode = SKSpriteNode()
    private let background: SKSpriteNode = SKSpriteNode(imageNamed: "background1")
    private(set) var increaseColdTimer: Timer!
    private(set) var generateLambTimer: Timer!
    var wolfs: Set<Wolf> = Set<Wolf>()
    let tree: SKSpriteNode = SKSpriteNode(imageNamed: "arvore1")
    let accessories: [Accessory] = [Scarf()]
    var enemySpeed = 1.0
    var enemyFrequency = 15.0
    
    enum Sheep: UInt32{
        case bitmask = 4
    }
    
    enum Obstable: UInt32{
        case bitmask = 1
    }
    enum Lamb: UInt32{
        case bitmask = 6
    }
    
    enum Border: UInt32{
        case bitmask = 8
    }
    
    private let sheep: SKSpriteNode = {
        let atlas = SKTextureAtlas(named: "SheepWalk")
        let sheep = SKSpriteNode(texture: atlas.textureNamed("sheep_walk01"))
        return sheep
    }()
    
    private lazy var joystick: Joystick = {
        let joystick = Joystick(
            size: CGSize(width: 100, height: 100),
            spriteToMove: sheep
        )
        joystick.moveSprite = sheepMove
        return joystick
    }()
    
    private lazy var progressBar: HorizontalProgressBar = {
        let progressBar = HorizontalProgressBar(
            isAscending: false,
            size: CGSize(width: 400, height: 32)
        )
        progressBar.factor = 2 - calculateColdResistance()
        progressBar.zPosition = 1
        return progressBar
    }()
    
    private func cameraSetup() {
        cam.zPosition = 10
        cam.position = CGPoint(x: size.width/2, y: size.height/2)
        camera = cam
    }
    
    override func didMove(to view: SKView) {
        buildLayout()
    }
    
    func configureTimers() {
        increaseColdTimer = Timer.scheduledTimer(
            timeInterval: 1,
            target: self,
            selector: #selector(increaseCold),
            userInfo: nil,
            repeats: true
        )
        generateLambTimer = Timer.scheduledTimer(
            timeInterval: 3.0,
            target: self,
            selector: #selector(generateLamb),
            userInfo: nil,
            repeats: true
        )
    }
}

// - MARK: Setup

extension GameScene: ViewCoding {
    func addionalConfiguration() {
        sheepMove()
        physicsSetup()
        progressBar.initializeBarValue()
        configureTimers()
        cameraSetup()
        levelsSetup()
        enemiesSetup()
    }
    
    func setupConstraints() {
        guard let view = view else { return }
        border.anchorPoint = CGPoint.zero
        border.zPosition = -1
        
        background.anchorPoint = CGPoint.zero
        background.zPosition = -1
        
        sheep.position = CGPoint(x: view.frame.midX, y:  view.frame.midY + 200)
        sheep.size.width *= 0.3
        sheep.size.height *= 0.3
        
        tree.position = CGPoint(x: frame.maxX * 0.9, y: frame.maxY * 0.20)
        tree.size.width *= 0.2
        tree.size.height *= 0.2
    
        joystick.position = CGPoint(x: -size.width * 0.37, y: -size.height * 0.35)
        progressBar.position = CGPoint(x: size.width * 0.30, y: size.height * 0.42)
    }
    
    func addViewHierarchy() {
        addChild(background)
        addChild(sheep)
        addChild(tree)
        addChild(cam)
        cam.addChild(joystick)
        cam.addChild(progressBar)
        addChild(border)
    }
}

// - MARK: Functionalities

extension GameScene {
    override func update(_ currentTime: TimeInterval) {
        sheep.position.x += joystick.velocityX
        sheep.position.y += joystick.velocityY
        cam.position = sheep.position
        verifyDistanceToEnemies()
    }
    
    func sheepMove() {
        sheep.run(
            SKAction.repeatForever(
                SKAction.animate(
                    with: SKTextureAtlas(named: "SheepWalk").textureNames.map(SKTexture.init(imageNamed:)),
                    timePerFrame: 1/4,
                    resize: false,
                    restore: true
                )
            )
        )
    }
    
    func physicsSetup() {
        border.physicsBody = SKPhysicsBody(edgeLoopFrom: background.frame)
        border.physicsBody?.isDynamic = false
        
        sheep.physicsBody = SKPhysicsBody(rectangleOf: sheep.size)
        sheep.physicsBody?.affectedByGravity = false
        sheep.physicsBody?.allowsRotation = false
        
        tree.physicsBody = SKPhysicsBody(texture: tree.texture!, size: tree.size)
        tree.physicsBody?.isDynamic = false
        
        tree.physicsBody?.categoryBitMask = Obstable.bitmask.rawValue
        border.physicsBody?.categoryBitMask = Obstable.bitmask.rawValue
        sheep.physicsBody?.collisionBitMask = Obstable.bitmask.rawValue
        
        sheep.name = "sheep_walk01"
        
        self.physicsWorld.contactDelegate = self
    }
    
    func setupCamera() {
        guard let camera = camera, let view = view else { return }
        let zeroDistance = SKRange(constantValue: 0)
        let sheepConstraint = SKConstraint.distance(zeroDistance,
                                                    // 1
                                                    to: sheep)
        let xInset = min(view.bounds.width/2 * camera.xScale,
                         background.frame.width/2)
        let yInset = min(view.bounds.height/2 * camera.yScale,
                         background.frame.height/2)
        // 2
        let constraintRect = background.frame.insetBy(dx: xInset,
                                                      // 3
                                                      dy: yInset)
        let xRange = SKRange(lowerLimit: constraintRect.minX,
                             upperLimit: constraintRect.maxX)
        let yRange = SKRange(lowerLimit: constraintRect.minY,
                             upperLimit: constraintRect.maxY)
        let edgeConstraint = SKConstraint.positionX(xRange, y: yRange)
        edgeConstraint.referenceNode = background
        // 4
        camera.constraints = [sheepConstraint, edgeConstraint]
    }
    
    @objc func generateLamb() {
        func setLambPhyisics(_ lamb: SKSpriteNode) {
            lamb.physicsBody = SKPhysicsBody(rectangleOf: lamb.size)
            lamb.physicsBody?.isDynamic = false
            lamb.name = "Lamb"
            sheep.physicsBody?.contactTestBitMask += Lamb.bitmask.rawValue
        }
        
        let lamb: SKSpriteNode = SKSpriteNode(imageNamed: "Lamb")
        let Xcordinate = Int.random(in: 0...Int(background.frame.width))
        let Ycordinate = Int.random(in: 0...Int(background.frame.height))
        lamb.position = CGPoint(x: Xcordinate, y: Ycordinate)
        lamb.size.width *= 0.05
        lamb.size.height *= 0.05
        setLambPhyisics(lamb)
        addChild(lamb)
    }
    
    func calculateColdResistance() -> CGFloat {
        var coldResistance = 0.0
        accessories.forEach { coldResistance += $0.resistance }
        return coldResistance
    }
    
    func levelsSetup() {
        run(
            SKAction.repeat(
                SKAction.sequence([
                    SKAction.run(updateLevel),
                    SKAction.wait(forDuration: 10)
                ]),
                count: 5
            )
        )
    }
    
    @objc func increaseCold() {
        progressBar.updateBarState()
       if progressBar.progressValue == 0 {
            let loseAction = SKAction.run() { [weak self] in
                guard let self = self else { return }
                let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
                let gameOverScene = GameOverScene(size: self.size, won: false)
                gameOverScene.label2.text = "\(capturedLambs.count)"
                self.view?.presentScene(gameOverScene, transition: reveal)
            }
            sheep.run(SKAction.sequence([loseAction]))

        }
    }
    
    func updateLevel() {
        progressBar.factor += 2.5
        enemySpeed += 1
        enemyFrequency -= 2
    }
    
    func enemiesSetup() {
        run(
            SKAction.repeatForever(
                SKAction.sequence([
                    SKAction.run(generateWolf),
                    SKAction.wait(forDuration: enemyFrequency)
                ])
            )
        )
    }
    
    private func generateWolf() {
        let node = Wolf()
        node.position = CGPoint(
            x: sheep.position.x + CGFloat(Int.random(in: 500..<800)),
            y: sheep.position.y + CGFloat(Int.random(in: 500..<800))
        )
        sheep.physicsBody?.contactTestBitMask += node.bitMask
        wolfs.insert(node)
        addChild(node)
    }
    
    private func verifyDistanceToEnemies() {
        for enemy in wolfs {
            let distanceToSheep = enemy.position.distance(point: sheep.position)
            if distanceToSheep < 1000 {
                let dx = enemy.position.x - sheep.position.x
                let dy = enemy.position.y - sheep.position.y
                let angle = atan2(dy, dx)
                let cos = cos(angle)
                let sin = sin(angle)
            
                enemy.position.x -= cos * (enemySpeed + (distanceToSheep < 600 ? 5 : 0 ))
                enemy.position.y -= sin * (enemySpeed + (distanceToSheep < 600 ? 5 : 0 ))
                
                if !enemy.hasActions() { enemy.atackAction() }
            }
        }
    }

}

extension GameScene: SKPhysicsContactDelegate{
    func didBegin(_ contact:SKPhysicsContact){
        if let wolf = contact.bodyB.node as? Wolf {
            sheep.run(
                SKAction.sequence([
                    SKAction.fadeOut(withDuration: 0.2),
                    SKAction.fadeIn(withDuration: 0.2)
                ])
            )
            progressBar.updateBarState(with: progressBar.progressValue - wolf.damage)
            wolf.removeFromParent()
        }
        
        if contact.bodyB.node?.name == "Lamb" {
            for child in children {
                if child.physicsBody == contact.bodyB.node?.physicsBody {
                    child.removeFromParent()
                    capturedLambs.append(child)
                    progressBar.updateBarState(with: progressBar.progressValue + 8)
                    print(capturedLambs.count)
                }
            }
        }
    }
}
