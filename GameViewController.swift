//
//  GameViewController.swift
//
//  Created by Tommy Keaty on 12/22/17.
//  Copyright (c) 2017 Tommy Keaty. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let scene = StartScreen(size:CGSize(width: 2048, height: 1536))
        let skView = self.view as! SKView
        scene.scaleMode = .aspectFill
        skView.presentScene(scene)
    }
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
}
