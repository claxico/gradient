//
//  Tile.swift
//  I Love Hue-it
//
//  Created by Huit Blackmon on 8/2/22.
//

import Foundation
import GameKit
import SpriteKit


class Tile: SKShapeNode {
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    var isPickedUp = false
    var isCorner = false
    
    var currentPos: (Int, Int) = (0, 0)
    var finalPos: (Int, Int) = (0, 0)
    
    
    
}
