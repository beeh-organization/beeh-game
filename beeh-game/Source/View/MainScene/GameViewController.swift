//
//  GameViewController.swift
//  beeh-game
//
//  Created by Thiago Henrique on 30/03/23.
//

import UIKit
import SpriteKit
import GameplayKit
import SwiftUI

class GameViewController: UIViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            let scene = GameScene(size: view.bounds.size)
            view.presentScene(scene)
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
    

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}


struct GameSpriteView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> GameViewController {
        let vc = GameViewController()
        return vc
    }

    func updateUIViewController(_ uiViewController: GameViewController, context: Context) {

    }

    typealias UIViewControllerType = GameViewController


}
