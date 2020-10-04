//
//  InstructionScene.swift
//
//  Created by Tommy Keaty on 3/6/18.
//  Copyright © 2018 Tommy Keaty. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit

class InstructionScene: SKScene {
    
    let textLabel = UILabel()
    var touches = 0
    let text2 = "\n\nHumanity had no hope for survival due to the overprescription of our antibiotics until Dr. Shrink. E. Dink developed a technology to shrink people down to microscopic size to combat infection themselves."
    
    let text3 = "\n\nAce the Living Antibiotic leads the world’s most accomplished Anti-Infection Task Force into the firefight against the most urgent of infections."
    
    let text4 = "\nYou will control Ace on his exploration into the patient Johnny Johnson. Johnny was recently on a trip to New York city and became gravely infected after eating gum he found stuck to some handrails, thinking it was candy. Can you save this young boy?"
    
    let text5 = "\n\n Gameplay: Use the left dpad to move and the right dpad to shoot. The bacteria will periodically spawn and divide, it's your job to blast them away!"
    
    let text6 = "\nIf a bacteria runs over a resistance plasmid (circle of DNA), it will absorb it and become invincible for a short duration! YOU CANNOT leave the Landing Zone (blue rectangle) otherwise you will not be able to be extracted by Dr. Dink upon mission completion. "
    
    let text7 = "\n\nThere are three infections you must eradicate in order to save the patient. Ready to go? Just tap the screen"
    
    override init(size: CGSize){
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        var background: SKSpriteNode
        background = SKSpriteNode(imageNamed: "redground")
        background.setScale(10.0)
        
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        self.addChild(background)
        
        textLabel.font = UIFont(name: "Free Pixel", size: 22.0)
        textLabel.text = "\nIn the year 2072, microbes have evolved stronger and stronger to a point where standard antibiotics cannot defeat the bacterial resistance alone. For the past 20 years, doctors have fought a losing battle against infection, the population left in shambles."
        
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        textLabel.numberOfLines = 50
        textLabel.frame = CGRect(x: screenWidth*0.05, y: screenHeight*0.05, width: screenWidth*0.90, height: screenHeight*0.90)
        textLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        textLabel.textColor = UIColor.white
        textLabel.sizeToFit()
        
        
        self.view?.addSubview(textLabel)
    }
    
    func sceneTouched(touchLoc: CGPoint){
        
        if touches == 0{
            textLabel.text = text2
            touches += 1
        }
        else if touches == 1{
            textLabel.text = text3
            touches += 1
        }
        else if touches == 2{
            textLabel.text = text4
            touches += 1
        }
        else if touches == 3{
            textLabel.text = text5
            touches += 1
        }
        else if touches == 4{
            textLabel.text = text6
            touches += 1
        }
        else if touches == 5{
            textLabel.text = text7
            touches += 1
        }
        else{
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
            let myScene = LevelTransition.init(size: self.size)
            myScene.scaleMode = self.scaleMode
            self.textLabel.removeFromSuperview()
            let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
            self.view?.presentScene(myScene, transition: reveal)
        }
        self.run(block)
    }
}
