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

    override func didMove(to view: SKView) {
        buildLayout()
    }
}

extension GameScene: ViewCoding {
    func setupConstraints() {
//        background.position = CGPoint(x: size.width/2, y: size.height/2) //TODO - Mapa infinito
        background.anchorPoint = CGPoint.zero
        background.zPosition = -1
    }
    
    func addViewHierarchy() {
        addChild(background)
    }
}
