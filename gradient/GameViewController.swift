//
//  GameViewController.swift
//  I Love Hue-it
//
//  Created by Huit Blackmon on 8/2/22.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {

        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.isTranslucent = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        winlabel.isHidden = true
        movesLabel.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        newGame()
    }
    
    var gridSize: Int = 5
    var difficulty: Int = 1
    
    
    @IBAction func swipedRight(_ sender: Any) {
        
        
        print("hello")
    }
    
    @IBOutlet weak var gameSceneView: SKView!

    @IBAction func newGameButtonPressed(_ sender: Any) {
        newGame()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func newGame() {
        winlabel.isHidden = true
        movesLabel.isHidden = true

        if let scene = SKScene(fileNamed: "GameScene") as? GameScene {
            scene.gridSize = gridSize
            scene.difficulty = difficulty
            scene.parentViewController = self
            gameSceneView.presentScene(scene)
        
        }
    }
    
    @IBOutlet weak var movesLabel: UILabel!
    
    @IBOutlet weak var winlabel: UILabel!
    
    func gameOver(moves: Int, time: Int) {
        winlabel.isHidden = false
        movesLabel.isHidden = false
        movesLabel.text = "moves: \(moves)"
        
    }
    
    
    
}




