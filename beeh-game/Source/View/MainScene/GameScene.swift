//
//  GameScene.swift
//  beeh-game
//
//  Created by Thiago Henrique on 30/03/23.
//

import SpriteKit
import GameplayKit

//- MARK: Init Variables

class GameScene: SKScene {
    private let background: SKSpriteNode = SKSpriteNode(imageNamed: "background1")
    private let sheep: SKSpriteNode = {
        let atlas = SKTextureAtlas(named: "SheepWalk")
        return SKSpriteNode(texture: atlas.textureNamed("sheep_walk01"))
    }()

    let tree: SKSpriteNode = SKSpriteNode(imageNamed: "arvore1")

    let enemy: SKSpriteNode = SKSpriteNode(imageNamed: "lobinho")


    private lazy var joystick: Joystick = {
        let joystick = Joystick(
            size: CGSize(width: 100, height: 100),
            spriteToMove: sheep
        )
        joystick.moveSprite = sheepMove
        return joystick
    }()
    
    override func didMove(to view: SKView) {
        buildLayout()
        sheepMove()
        physicsSetup()
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
    }
    
    func addViewHierarchy() {
        addChild(background)
        addChild(sheep)
        addChild(joystick)
        addChild(tree)
        addChild(enemy)
    }
}

// - MARK: Functionalities

extension GameScene {
    override func update(_ currentTime: TimeInterval) {
        sheep.position.x += joystick.velocityX
        sheep.position.y += joystick.velocityY
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
        sheep.physicsBody = SKPhysicsBody(texture: sheep.texture!, size: sheep.size)
        sheep.physicsBody?.affectedByGravity = false
        sheep.physicsBody?.allowsRotation = false

        tree.physicsBody = SKPhysicsBody(texture: tree.texture!, size: tree.size)
        tree.physicsBody?.isDynamic = false

        enemy.physicsBody = SKPhysicsBody(texture: enemy.texture!, size: enemy.size)
        enemy.physicsBody?.isDynamic = false

        tree.physicsBody?.categoryBitMask = 0b0001
        enemy.physicsBody?.categoryBitMask = 0b0010

        sheep.physicsBody?.collisionBitMask = 0b0001

        sheep.name = "sheep_walk01"
        enemy.name = "lobinho"
        sheep.physicsBody?.contactTestBitMask = 0b0010
        self.physicsWorld.contactDelegate = self
    }
    
}

extension GameScene: SKPhysicsContactDelegate{
    func didBegin(_ contact:SKPhysicsContact){
        print("A:", contact.bodyA.node?.name ?? "no node")
        print("A:", contact.bodyB.node?.name ?? "no node")
        if contact.bodyB == enemy.physicsBody{
            print("Ovelha foi de arrasta pra cima")
            sheep.run(SKAction.sequence([
                SKAction.fadeOut(withDuration: 0.2),
                SKAction.fadeIn(withDuration: 0.2)
            ])
            )
        }
    }
}
