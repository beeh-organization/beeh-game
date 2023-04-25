//
//  Enemy.swift
//  beeh-game
//
//  Created by Thiago Henrique on 24/04/23.
//

import Foundation

protocol EnemyProtocol: Hashable {
    var duration: TimeInterval { get }
    var damage: CGFloat { get }
    var bitMask: UInt32 { get }
    func atackAction()
}

extension EnemyProtocol {
    var bitMask: UInt32 { return 2 }
}
