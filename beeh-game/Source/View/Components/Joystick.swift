//
//  Joystick.swift
//  beeh-game
//
//  Created by Thiago Henrique on 04/04/23.
//

import Foundation
import SpriteKit

class Joystick: SKNode {
    private var joystickBack: SKSpriteNode!
    private var joystickButton: SKSpriteNode!
    
    private var joystickInUse = false
    private var size: CGSize!
    
    var spriteToMove: SKSpriteNode!
    var moveSprite: (() -> Void)? = nil
    
    var velocityX: CGFloat = 0.0
    var velocityY: CGFloat = 0.0
    
    init(size: CGSize, spriteToMove: SKSpriteNode) {
        self.size = size
        self.spriteToMove = spriteToMove
        
        super.init()
        
        self.isUserInteractionEnabled = true
        self.joystickButton = SKSpriteNode(texture: SKTexture(image: UIImage(named: "jStick")!), size:  CGSize(width: size.width/2, height: size.height/2))
        self.joystickBack = SKSpriteNode(texture: SKTexture(image: UIImage(named: "jSubstrate")!), size: size)
        buildLayout()
    }
    
    required init?(coder aDecoder: NSCoder) { nil }
}

extension Joystick: ViewCoding {
    func setupConstraints() {
        joystickBack.size.width *= 1.5
        joystickBack.size.height *= 1.5
     
        joystickButton.size.width *= 1.5
        joystickButton.size.height *= 1.5
        joystickButton.position = joystickBack.position
        joystickButton.zPosition = 1
    }
    
    func addViewHierarchy() {
        addChild(joystickBack)
        addChild(joystickButton)
    }
}

extension Joystick {
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            touchesMoved(touch: t)
        }
    }
    
    func touchesMoved(touch: UITouch) {
        let location = touch.location(in: self)
        if joystickInUse {
            let vector = CGVector(dx: location.x - joystickBack.position.x , dy: location.y - joystickBack.position.y)
            let angle = atan2(vector.dy, vector.dx)
            let distanceFromCenter = CGFloat(joystickBack.size.height/2)
            
            let distanceX = CGFloat(sin(angle - CGFloat(Double.pi/2)) * distanceFromCenter)
            let distanceY = CGFloat(cos(angle - CGFloat(Double.pi/2)) * distanceFromCenter)
            
            if joystickBack.frame.contains(location) {
                joystickButton.position = location
            } else {
                joystickButton.position = CGPoint(x: joystickBack.position.x - distanceX, y: joystickBack.position.y + distanceY)
            }
            
            velocityX = (joystickButton.position.x - joystickBack.position.x)/5
            velocityY = (joystickButton.position.y - joystickBack.position.y)/5
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            if joystickButton.frame.contains(location) {
                joystickInUse = true
                moveSprite?()
                return
            }
            joystickInUse = false
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if joystickInUse { movementOver() }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if joystickInUse { movementOver() }
    }
    
    func movementOver() {
        let moveBack = SKAction.move(to: CGPoint(x: joystickBack.position.x, y: joystickBack.position.y), duration: 0.1)
        moveBack.timingMode = .linear
        joystickButton.run(moveBack)
        joystickInUse = false
        velocityX = 0
        velocityY = 0
        spriteToMove.removeAllActions()
    }
}
