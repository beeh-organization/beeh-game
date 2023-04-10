//
//  LambModel.swift
//  beeh-game
//
//  Created by Ana Caroline Sampaio Nogueira on 05/04/23.
//

import Foundation
import SpriteKit

struct Lamb: Identifiable {
    var id: UUID = UUID()
    var node: SKNode
    var age: Age
}

enum Age: Int {
    case veryNew = 0
    case new = 1
    case old = 2
    case veryOld = 3
    case death = 4
}
