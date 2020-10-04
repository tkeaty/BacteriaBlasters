//
//  StartScreen.swift
//
//  Created by Tommy Keaty on 2/8/18.
//  Copyright © 2018 Tommy Keaty. All rights reserved.
//

import Foundation
import SpriteKit

class StartScreen: SKScene {
    
    let titleLabel = SKLabelNode(fontNamed: "Dimitri")
    let instructionLabel = SKLabelNode(fontNamed: "Dimitri")
    var instructionRect = CGRect()
    let startButtonLabel = SKLabelNode(fontNamed: "Dimitri")
    var buttonRect = CGRect()
    var bounds = CGRect(x:0,y:0,width:0,height:0)
    var txt1: [SKTexture] = []
    var txt2: [SKTexture] = []
    var txt3: [SKTexture] = []
    var txt4: [SKTexture] = []
    var time: TimeInterval
    var times = [0.0,0.0,0.0,0.0]
    
    override init(size: CGSize){
        time = 0.0
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        var background: SKSpriteNode
        background = SKSpriteNode(imageNamed: "bodybackground")
        background.setScale(3.0)
        
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        background.zPosition = -1
        bounds = background.frame
        self.addChild(background)
        
        let maxAspRatio: CGFloat = 16.0/9.0
        let playableHeight = size.width/maxAspRatio
        let playableMargin = (size.height-playableHeight)/2.0
        let playableRect = CGRect(x:0, y: playableMargin, width: size.width, height: playableHeight)
        
        titleLabel.text = "Bacteria Blasters"
        titleLabel.color = SKColor.green
        titleLabel.setScale(2.5)
        titleLabel.zPosition = 50
        titleLabel.position = CGPoint(x: playableRect.size.width/2, y: playableRect.size.height/2 + 200)
        addChild(titleLabel)
        
        let shape = SKShapeNode()
        let path = CGMutablePath()
        buttonRect = CGRect(x: playableRect.size.width/2-150, y: playableRect.size.height/2 - 210, width: 300, height: 75)
        path.addRect(buttonRect)
        shape.path = path
        shape.strokeColor = SKColor.blue
        shape.lineWidth = 10.0
        addChild(shape)
        
        txt1.append(SKTexture(imageNamed: "Bacteria1"))
        txt2.append(SKTexture(imageNamed: "Bacteria3"))
        txt3.append(SKTexture(imageNamed: "Bacteria4"))
        txt4.append(SKTexture(imageNamed: "Bacteria5"))
        
        for i in 1...2{
            txt1.append(SKTexture(imageNamed: "Bacteria1M\(i)"))
            txt2.append(SKTexture(imageNamed: "Bacteria3M\(i)"))
            txt3.append(SKTexture(imageNamed: "Bacteria4M\(i)"))
            txt4.append(SKTexture(imageNamed: "Bacteria5M\(i)"))
        }
        
        startButtonLabel.text = "START"
        startButtonLabel.color = SKColor.green
        startButtonLabel.setScale(2.0)
        startButtonLabel.position = CGPoint(x: playableRect.size.width/2,
                                            y: playableRect.size.height/2-200)
        addChild(startButtonLabel)
        spawn3()
        spawn1()
        spawn2()
        spawn4()
    }
    
    func sceneTouched(touchLoc: CGPoint){
        if buttonRect.contains(touchLoc){
            flipScene()
        }
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
            let myScene = InstructionScene.init(size: self.size)
            myScene.scaleMode = self.scaleMode
            let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
            self.view?.presentScene(myScene, transition: reveal)
        }
        self.run(block)
    }
    
    func spawn1(){
        let bacteria = SKSpriteNode(imageNamed: "Bacteria1")
        bacteria.position = titleLabel.position + CGPoint(x: -700, y: 0)
        bacteria.run(SKAction.repeatForever(SKAction.animate(with: txt1, timePerFrame: 0.1)))
        addChild(bacteria)
    }
    
    func spawn2(){
        let bacteria = SKSpriteNode(imageNamed: "Bacteria3")
        bacteria.position = titleLabel.position + CGPoint(x: 600, y: 200)
        bacteria.run(SKAction.repeatForever(SKAction.animate(with: txt2, timePerFrame: 0.1)))
        addChild(bacteria)
    }
    
    func spawn3(){
        let bacteria = SKSpriteNode(imageNamed: "Bacteria4")
        bacteria.position = titleLabel.position + CGPoint(x: 0, y: 200)
        bacteria.run(SKAction.repeatForever(SKAction.animate(with: txt3, timePerFrame: 0.1)))
        addChild(bacteria)
    }
    
    func spawn4(){
        let bacteria = SKSpriteNode(imageNamed: "Bacteria5")
        bacteria.position = titleLabel.position + CGPoint(x: 50, y: -300)
        let movit = SKAction.move(by: CGVector(dx: 400, dy: 0), duration: 3)
        let movseq = SKAction.sequence([movit,movit.reversed()])
        bacteria.run(SKAction.repeatForever(SKAction.animate(with: txt4, timePerFrame: 0.1)))
        bacteria.run(SKAction.repeatForever(movseq))
        addChild(bacteria)
    }
}
