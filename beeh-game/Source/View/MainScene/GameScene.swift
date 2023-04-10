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
    private let background: SKSpriteNode = SKSpriteNode(imageNamed: "background1")
    private let sheep: SKSpriteNode = {
        let atlas = SKTextureAtlas(named: "SheepWalk")
        return SKSpriteNode(texture: atlas.textureNamed("sheep_walk01"))
    }()

    let tree: SKSpriteNode = SKSpriteNode(imageNamed: "arvore1")
    let enemy: SKSpriteNode = SKSpriteNode(imageNamed: "lobinho")

    enum Sheep: UInt32{
        case bitmask = 4
    }

    enum Enemy: UInt32{
        case bitmask = 2
    }

    enum Obstable: UInt32{
        case bitmask = 1
    }
    enum Lamb: UInt32{
        case bitmask = 6
    }

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
        progressBar.zPosition = 1
        return progressBar
    }()
    
    override func didMove(to view: SKView) {
        buildLayout()
        sheepMove()
        physicsSetup()
        progressBar.initializeBarValue()
        Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(firedTimer), userInfo: nil, repeats: true)
    }
}

// - MARK: Setup

extension GameScene: ViewCoding {
    func setupConstraints() {
        guard let view = view else { return }
        background.anchorPoint = CGPoint.zero
        background.zPosition = -1
        
        sheep.position = CGPoint(x: view.frame.midX, y:  view.frame.midY + 200)
        sheep.size.width *= 0.25
        sheep.size.height *= 0.25

        tree.position = CGPoint(x: frame.maxX * 0.9, y: frame.maxY * 0.20)
        tree.size.width *= 0.2
        tree.size.height *= 0.2

        enemy.position = CGPoint(x: frame.maxX * 0.20, y: frame.maxY * 0.9)
        enemy.size.width *= 0.2
        enemy.size.height *= 0.2
        
        joystick.position = CGPoint(x: view.frame.maxX * 0.1, y:  view.frame.maxY * 0.15)
        progressBar.position = CGPoint(x: view.frame.maxX * 0.82, y:  view.frame.maxY * 0.92)
    }
    
    func addViewHierarchy() {
        addChild(background)
        addChild(sheep)
        addChild(joystick)
        addChild(tree)
        addChild(enemy)
        addChild(progressBar)
    }
}

// - MARK: Functionalities

extension GameScene {
    override func update(_ currentTime: TimeInterval) {
        sheep.position.x += joystick.velocityX
        sheep.position.y += joystick.velocityY
    }

    func setLambPhyisics(_ lamb: SKSpriteNode) {
        lamb.physicsBody = SKPhysicsBody(rectangleOf: lamb.size)
        lamb.physicsBody?.isDynamic = false
        lamb.name = "Lamb"
        sheep.physicsBody?.contactTestBitMask += Lamb.bitmask.rawValue
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
        sheep.physicsBody = SKPhysicsBody(rectangleOf: sheep.size)
        sheep.physicsBody?.affectedByGravity = false
        sheep.physicsBody?.allowsRotation = false

        tree.physicsBody = SKPhysicsBody(texture: tree.texture!, size: tree.size)
        tree.physicsBody?.isDynamic = false

        enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
        enemy.physicsBody?.isDynamic = false

        tree.physicsBody?.categoryBitMask = Obstable.bitmask.rawValue
        enemy.physicsBody?.categoryBitMask = Enemy.bitmask.rawValue

        sheep.physicsBody?.collisionBitMask = Obstable.bitmask.rawValue

        sheep.name = "sheep_walk01"
        enemy.name = "lobinho"

        sheep.physicsBody?.contactTestBitMask = Enemy.bitmask.rawValue

        self.physicsWorld.contactDelegate = self
    }

    @objc func firedTimer() {
        let lamb: SKSpriteNode = SKSpriteNode(imageNamed: "Lamb")
        let Xcordinate = Int.random(in: 100...Int(UIScreen.main.bounds.width))
        let Ycordinate = Int.random(in: 100...Int(UIScreen.main.bounds.height))
        lamb.position = CGPoint(x: Xcordinate, y: Ycordinate)
        lamb.size.width *= 0.05
        lamb.size.height *= 0.05
        setLambPhyisics(lamb)
        addChild(lamb)
    }
}

extension GameScene: SKPhysicsContactDelegate{
    func didBegin(_ contact:SKPhysicsContact){
        if contact.bodyB == enemy.physicsBody {
            sheep.run(SKAction.sequence([
                SKAction.fadeOut(withDuration: 0.2),
                SKAction.fadeIn(withDuration: 0.2)
            ])
            )
        }

        if contact.bodyB.node?.name == "Lamb" {
            for child in children {
                if child.physicsBody == contact.bodyB.node?.physicsBody {
                    child.removeFromParent()
                    capturedLambs.append(child)
                    print(capturedLambs.count)
                }
            }
        }
    }
}
