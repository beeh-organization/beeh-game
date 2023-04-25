//
//  Wolf.swift
//  beeh-game
//
//  Created by Thiago Henrique on 24/04/23.
//

import Foundation
import SpriteKit

class Wolf: SKSpriteNode {
    init() {
        let wolfTexture = SKTexture(imageNamed: "wolf_atack01")
        super.init(
            texture: wolfTexture,
            color: .clear,
            size: wolfTexture.size()
        )
        setupWolf()
    }
    
    required init?(coder aDecoder: NSCoder) { nil }
    
    func setupWolf() {
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 200, height: 400))
        self.physicsBody?.isDynamic = false
        self.physicsBody?.contactTestBitMask = self.bitMask
        self.size.width *= 0.2
        self.size.height *= 0.2
        self.name = "lobinho"
    }
    
}

extension Wolf: EnemyProtocol {
    func atackAction() {
        run(
            SKAction.repeatForever(
                SKAction.animate(
                    with: SKTextureAtlas(named: "WolfAtack").textureNames.map(SKTexture.init(imageNamed:)),
                    timePerFrame: 1/4,
                    resize: false,
                    restore: true
                )
            )
        )
    }
    
    var duration: TimeInterval {
        get { return 10 }
    }
    
    var damage: Int {
        return 10
    }
}
