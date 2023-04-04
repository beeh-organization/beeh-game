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
        
        joystick.position = CGPoint(x: view.frame.maxX * 0.1, y:  view.frame.maxY * 0.15)
    }
    
    func addViewHierarchy() {
        addChild(background)
        addChild(sheep)
        addChild(joystick)
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
    
}
