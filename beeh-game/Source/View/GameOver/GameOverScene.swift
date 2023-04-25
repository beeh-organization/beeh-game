

import SpriteKit

class ButtonNode: SKSpriteNode {
    var onTap: (() -> Void)?
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        onTap?()
    }

    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
        self.isUserInteractionEnabled = true
    }

    required init?(coder aDecoder: NSCoder) { nil }
}

class GameOverScene: SKScene {
    var label2 = SKLabelNode(fontNamed: "Chalkduster")

    init(size: CGSize, won:Bool) {
        super.init(size: size)
    }

    override func didMove(to view: SKView) {
        let backgroundGameOver: SKSpriteNode = SKSpriteNode(imageNamed: "background1")
        let message = "Score"

        backgroundGameOver.size = CGSize(width: view.frame.width, height: view.frame.height)
        backgroundGameOver.anchorPoint = CGPoint.zero
        
        label2.fontSize = 80
        label2.fontColor = SKColor.black
        label2.position = CGPoint(x: size.width/2, y: size.height/2 - 100)
        label2.zPosition = 2
        addChild(label2)

        let label = SKLabelNode(fontNamed: "Chalkduster")
        label.text = message
        label.fontSize = 80
        label.fontColor = SKColor.black
        label.position = CGPoint(x: size.width/2, y: size.height/2)
        label.zPosition = 2
        addChild(label)
        addChild(backgroundGameOver)

        let button = ButtonNode(
            texture: nil,
            color: .white,
            size: CGSize(width: 150, height: 50)
        )

        button.position.x = label.position.x
        button.position.y = label.position.y - 150
        button.zPosition = 3

        addChild(button)

        let reveal = SKTransition.fade(withDuration: 1)
        let scene = GameScene(size: size)
        button.onTap = { [weak self] in
            self?.view?.presentScene(scene, transition: reveal)
        }
    }


    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

