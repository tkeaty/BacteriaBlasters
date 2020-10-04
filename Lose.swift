//
//  Lose.swift
//
//  Created by Tommy Keaty on 3/3/18.
//  Copyright © 2018 Tommy Keaty. All rights reserved.
//

import Foundation
import SpriteKit

class LoseScreen: SKScene {
    
    override init(size: CGSize){
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        var background: SKSpriteNode
        background = SKSpriteNode(imageNamed: "Game over")
        background.setScale(3.0)
        
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        self.addChild(background)
    }
    
    func sceneTouched(touchLoc: CGPoint){
        flipScene()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        guard let touch = touches.first else{
            return
        }
        sceneTouched(touchLoc: touch.location(in:self))
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?){
        guard let touch = touches.first else{
            return
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>,
                               with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
    }
    
    func flipScene(){
        let block = SKAction.run {
            let myScene = StartScreen.init(size: self.size)
            myScene.scaleMode = self.scaleMode
            let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
            self.view?.presentScene(myScene, transition: reveal)
        }
        self.run(block)
    }
}
