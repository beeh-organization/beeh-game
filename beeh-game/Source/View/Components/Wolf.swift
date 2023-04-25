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
        setupLifeTime()
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
    
    func setupLifeTime() {
        run(
            SKAction.repeat(
                SKAction.sequence([
                    SKAction.wait(forDuration: self.duration),
                    SKAction.repeat(
                        SKAction.sequence([
                            SKAction.fadeOut(withDuration: 0.2),
                            SKAction.fadeIn(withDuration: 0.2),
                        ]),
                        count: 3
                    ),
                    SKAction.run(disapear)
                ]),
                count: 1
            )
        )
    }
    
    func disapear() {
        self.removeFromParent()
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
        return 10
    }
    
    var damage: CGFloat {
        return 10
    }
}
