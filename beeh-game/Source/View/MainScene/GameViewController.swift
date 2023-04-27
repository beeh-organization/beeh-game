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
import AVFoundation

class GameViewController: UIViewController {
    var audioPlayer: AVAudioPlayer!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            let scene = GameScene(size: view.bounds.size)
            view.presentScene(scene)
            view.ignoresSiblingOrder = true
            view.showsFPS = false
            view.showsNodeCount = false
        }
        backgroundSound()
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    func backgroundSound(){
          let pathSounds = Bundle.main.path(forResource: "beehmusic", ofType: "m4a")!
          let url = URL(fileURLWithPath: pathSounds)
          do
          {
              audioPlayer = try AVAudioPlayer(contentsOf: url)
              audioPlayer.volume = 0.15
              audioPlayer.numberOfLoops = -1
              audioPlayer?.play()
          } catch {
              print(error)
          }
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
