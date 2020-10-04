//
//  LevelTransition3.swift
//
//  Created by Tommy Keaty on 3/6/18.
//  Copyright © 2018 Tommy Keaty. All rights reserved.
//

import Foundation
import SpriteKit

class LevelTransition3: SKScene {
    
    let waveLabel = SKLabelNode(fontNamed: "Dimitri")
    let text1 = SKLabelNode(fontNamed: "Dimitri")
    let text2 = SKLabelNode(fontNamed: "Dimitri")
    let text3 = SKLabelNode(fontNamed: "Dimitri")
    let text4 = SKLabelNode(fontNamed: "Dimitri")
    var touches = 0
    
    override init(size: CGSize){
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder) has not been implemented")
    }
    
    
    override func didMove(to view: SKView) {
        var background: SKSpriteNode
        background = SKSpriteNode(imageNamed: "redground")
        var bacteriaFrame: SKSpriteNode
        bacteriaFrame = SKSpriteNode(imageNamed: "frame")
        let bacteria = SKSpriteNode(imageNamed: "Bacteria5")
        
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        background.zPosition = -1
        background.setScale(10.0)
        
        bacteriaFrame.position = CGPoint(x: size.width/2+50, y: size.height/2-100)
        bacteriaFrame.zPosition = 50
        bacteriaFrame.zRotation = π/2
        bacteriaFrame.setScale(3.75)
        
        bacteria.position = bacteriaFrame.position - CGPoint(x: 450, y: -30)
        bacteria.zPosition = 51
        bacteria.setScale(3.0)
        
        let up = SKAction.move(by: CGVector(dx: 0, dy: 10), duration: 0.2)
        let right = SKAction.move(by: CGVector(dx: 10, dy: 0), duration: 0.2)
        let sequence = SKAction.sequence([up,right.reversed(),right,up.reversed()])
        bacteria.run(SKAction.repeatForever(sequence))
        addChild(bacteria)
        
        waveLabel.text = "Wave 3"
        waveLabel.color = SKColor.green
        waveLabel.setScale(2.5)
        waveLabel.position = CGPoint(x: size.width/2 - size.width/3, y: size.height - size.width/7)
        waveLabel.zPosition = 1
        
        text1.text = "Strepococcus"
        text1.color = SKColor.green
        text1.setScale(2.5)
        text1.position = CGPoint(x: size.width/2 + size.width/7, y: size.height - size.width/4)
        text1.zPosition = 1
        
        text2.text = "Highly Resistant"
        text2.color = SKColor.green
        text2.setScale(2.5)
        text2.position = text1.position - CGPoint(x: 0, y: size.width/10)
        text2.zPosition = 1
        
        text3.text = "Very fast"
        text3.color = SKColor.green
        text3.setScale(2.5)
        text3.position = text2.position - CGPoint(x: 0, y: size.width/10)
        text3.zPosition = 1
        
        text4.text = "Brain infection"
        text4.color = SKColor.green
        text4.setScale(2.5)
        text4.position = text3.position - CGPoint(x: 0, y: size.width/10)
        text4.zPosition = 1
        
        addChild(bacteriaFrame)
        addChild(waveLabel)
        addChild(background)
    }
    
    func sceneTouched(touchLoc: CGPoint){
        if(touches == 0){
            addChild(text1)
            touches += 1
        }
        else if(touches == 1){
            addChild(text2)
            touches += 1
        }
        else if(touches == 2){
            addChild(text3)
            touches += 1
        }
        else if(touches == 3){
            addChild(text4)
            touches += 1
        }
        else if(touches == 4){
            flipScene()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        guard let touch = touches.first else{
            return
        }
        sceneTouched(touchLoc: touch.location(in:self))
    }
    
    override func touchesEnded(_ touches: Set<UITouch>,
                               with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
    }
    
    
    func flipScene(){
        let block = SKAction.run {
            let myScene = Level3.init(size: self.size)
            myScene.scaleMode = self.scaleMode
            let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
            self.view?.presentScene(myScene, transition: reveal)
        }
        self.run(block)
    }
}
