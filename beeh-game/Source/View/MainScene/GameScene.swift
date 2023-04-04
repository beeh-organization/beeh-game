//
//  GameScene.swift
//  beeh-game
//
//  Created by Thiago Henrique on 30/03/23.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    private let background: SKSpriteNode = SKSpriteNode(imageNamed: "background1")
    private let sheep: SKSpriteNode = {
        let atlas = SKTextureAtlas(named: "SheepWalk")
        return SKSpriteNode(texture: atlas.textureNamed("sheep_walk1"))
    }()

    override func didMove(to view: SKView) {
        buildLayout()
    }
}

extension GameScene: ViewCoding {
    func setupConstraints() {
        guard let view = view else { return }
//        background.position = CGPoint(x: size.width/2, y: size.height/2) //TODO - Mapa infinito
        background.anchorPoint = CGPoint.zero
        background.zPosition = -1
        
        sheep.position = CGPoint(x: view.frame.midX, y:  view.frame.midY + 200)
        sheep.size.width *= 0.25
        sheep.size.height *= 0.25
    }
    
    func addViewHierarchy() {
        addChild(background)
        addChild(sheep)
    }
}
