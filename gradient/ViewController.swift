//
//  ViewController.swift
//  I Love Hue-it
//
//  Created by Huit Blackmon on 8/11/22.
//

import UIKit
import SpriteKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
    
        setUpSteppers()
        updateGrid()
    
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        updateGrid()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateGrid()
    }
    
    
    @IBOutlet weak var difficultyStepper: UIStepper!
    @IBOutlet weak var gridSizeStepper: UIStepper!
    
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        updateGrid()
    }
    
    @IBOutlet weak var gameSceneView: SKView!
    
   
    func setUpSteppers() {
        gridSizeStepper.setDecrementImage(UIImage(systemName: "square"), for: .normal)
        gridSizeStepper.setIncrementImage(UIImage(systemName: "square.grid.2x2"), for: .normal)
        difficultyStepper.setDecrementImage(UIImage(systemName: "lightbulb"), for: .normal)
        difficultyStepper.setIncrementImage(UIImage(systemName: "lightbulb.fill"), for: .normal)
    }
    
    func updateGrid() {
        if let scene = SKScene(fileNamed: "GameScene") as? GameScene {
            scene.gridSize = Int(gridSizeStepper.value)
            scene.difficulty = Int(difficultyStepper.value)
            scene.isPreview = true
            scene.size = gameSceneView.bounds.size
    
            gameSceneView.presentScene(scene)
            scene.setUpBoard()
        }
    }
    
    
    @IBAction func unwindToHome(_ segue: UIStoryboardSegue) {
        self.navigationController?.hidesBarsOnSwipe = false
        self.navigationController?.navigationBar.isHidden = true
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        let destination = segue.destination as! GameViewController
        destination.gridSize = Int(gridSizeStepper.value)
        destination.difficulty = Int(difficultyStepper.value)
        
    }
    
    
    

}
