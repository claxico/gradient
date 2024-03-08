//
//  GameScene.swift
//  I Love Hue-it
//
//  Created by Huit Blackmon on 8/2/22.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {

    private var tile: Tile?
    private var tiles: [Tile] = []
    
    var gridSize: Int = 10
    var isPreview: Bool = false
    var difficulty: Int = 1
    
    var difficultyFactor = 0
    
    var parentViewController = GameViewController()
    
    private var moves = 0
    private var startTime: Date = Date()
    
    var tileWidth: CGFloat = 0
    var tileHeight: CGFloat = 0
    
    private var pickedUpTile: Tile?
    
    private var winLabel: SKLabelNode?
    
    var colorClosures = [ {(gridSize: Int, row: Int, col: Int) -> CGFloat in return CGFloat(row) / CGFloat(gridSize)},
                         {(gridSize: Int, row: Int, col: Int) -> CGFloat in return CGFloat(col) / CGFloat(gridSize)},
                         {(gridSize: Int, row: Int, col: Int) -> CGFloat in return CGFloat(gridSize - row - 1) / CGFloat(gridSize - 1)},
                         {(gridSize: Int, row: Int, col: Int) -> CGFloat in return CGFloat(gridSize - col - 1) / CGFloat(gridSize - 1)},
                         {(gridSize: Int, row: Int, col: Int) -> CGFloat in return CGFloat(row + col) / CGFloat((gridSize-1) * 2)},
                          ]

    
    var redClosure = {(gridSize: Int, row: Int, col: Int) -> CGFloat in return CGFloat((gridSize-1) * 2 - row - col) / CGFloat((gridSize-1)*2)}
    var greenClosure = {(gridSize: Int, row: Int, col: Int) -> CGFloat in return CGFloat( (gridSize-1) - abs((row + col) - (gridSize-1))) / CGFloat( (gridSize-1))}

    var blueClosure = {(gridSize: Int, row: Int, col: Int) -> CGFloat in return CGFloat(row + col) / CGFloat((gridSize-1) * 2)}
    
  
    override func didMove(to view: SKView) {
        
        self.backgroundColor = UIColor(named: "My Background Color")!
        
        if isPreview {
            setUpBoard()
        } else {
            colorClosures.shuffle()
            redClosure = colorClosures.popLast()!
            greenClosure = colorClosures.popLast()!
            blueClosure = colorClosures.popLast()!
            
            if difficulty > 1 {
                difficultyFactor = Int.random(in: 0..<gridSize*difficulty-gridSize)
            }
    
            setUpBoard()
            scrambleBoard()
            moves = 0
            startTime = Date()
        }
    
    }

    func touchDown(atPoint pos : CGPoint) {

    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
    }
    
    func touchUp(atPoint pos : CGPoint) {
        
        if gameIsOver() {
            return
        }
        
        for tile in tiles {
            if tile.contains(pos) {
                if let pickedUpTile = pickedUpTile {
                    switchTiles(tile, and: pickedUpTile, animated: true)
                    putDown(pickedUpTile)
                } else {
                    pickUp(tile)
                }
                    
            }
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    func addTile(row: Int, col: Int) {
        
        let d = difficultyFactor
        
        let red = redClosure(gridSize * difficulty, row + d, col + d)
        let green = greenClosure(gridSize * difficulty, row + d, col + d)
        let blue = blueClosure(gridSize * difficulty, row + d, col + d)
        
        if let tile = self.tile?.copy() as? Tile {
            
            tile.currentPos = (row, col)
            tile.finalPos = (row, col)
            
            tile.lineWidth = 0
            tile.fillColor = UIColor.init(red: red, green: green, blue: blue, alpha: 1)
        
            tile.position.x = CGFloat(tileWidth / 2 + tileWidth * CGFloat(col))
            tile.position.y = CGFloat(tileHeight / 2 + tileHeight * CGFloat(row))
            tiles.append(tile)
            self.addChild(tile)
            
            
            if [0, gridSize - 1].contains(row) && [0, gridSize - 1].contains(col) {
                tile.isCorner = true
    
            }
        }
    }
    
    func pickUp(_ tile: Tile) {
        
        if tile.isCorner {
            
            self.removeChildren(in: [tile])
            self.addChild(tile)
            
            let action = SKAction.scale(by: 1.1, duration: 0.1)
            tile.run(SKAction.sequence([action, action.reversed()]))
            return
        }
        
        pickedUpTile = tile
        
        tile.run(SKAction.scale(by: 1.2, duration: 0.05))
        self.removeChildren(in: [tile])
        self.addChild(tile)
        tile.isPickedUp = true
    }
    
    func putDown(_ tile: Tile) {
        
        pickedUpTile = nil
        
        tile.run(SKAction.scale(by: 1/1.2, duration: 0.05))
        tile.isPickedUp = false
        
    }
    
    func switchTiles(_ tile1: Tile, and tile2: Tile, animated: Bool) {
        
        if (tile1 == tile2) || (tile1.isCorner || tile2.isCorner) {
            return
        }
        
        self.removeChildren(in: [tile1, tile2])
        self.addChild(tile1)
        self.addChild(tile2)
        
        if animated {
            tile1.run(SKAction.move(to: tile2.position, duration: 0.25))
            tile2.run(SKAction.move(to: tile1.position, duration: 0.25))
        } else {
            (tile1.position, tile2.position) = (tile2.position, tile1.position)
        }
        
        (tile1.currentPos, tile2.currentPos) = (tile2.currentPos, tile1.currentPos)
        
        moves += 1
    
        
        if gameIsOver() {
            let endTime = Date()
            let interval = Int(endTime.timeIntervalSince(startTime))
            
            parentViewController.gameOver(moves: moves, time: interval)
            
        }
        
        return
    }
    
    func setUpBoard() {
        
        if !isPreview {
            tileWidth = self.size.width / CGFloat(gridSize)
            tileHeight = self.size.height / CGFloat(gridSize)
        }
        
        tileWidth = self.size.width / CGFloat(gridSize)
        tileHeight = self.size.height / CGFloat(gridSize)
        

        self.tile = Tile.init(rectOf: CGSize.init(width: tileWidth, height: tileHeight))
        
        for row in 0..<gridSize {
            for col in 0..<gridSize {
                addTile(row: row, col: col)
            }
        }
    
        self.winLabel = SKLabelNode.init(text: "moves: \(moves)")
        
        if let winLabel = self.winLabel {
            
            winLabel.fontColor = .black
            winLabel.position.x = self.size.width / 2
            winLabel.position.y = self.size.height / 2
            winLabel.fontSize = self.size.width / 5
            winLabel.fontColor = .white
            winLabel.fontName = "Menlo"

        }
    }
    
    func scrambleBoard() {
        
        for tile in tiles {
            let tile2 = tiles.randomElement()!
            
            switchTiles(tile, and: tile2, animated: false)
        }
    }
    
    func gameIsOver() -> Bool {
        
        for tile in tiles {
            if tile.currentPos != tile.finalPos {
                return false
            }
        }
        
        return true
        
    }
}


