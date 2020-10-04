//
//  Player.swift
//
//  Created by Tommy Keaty on 1/8/18.
//  Copyright © 2018 Tommy Keaty. All rights reserved.
//

import Foundation
import SpriteKit

enum PlayerSettings {
    static let playerSpeed: CGFloat = 280.0
}

class Player: SKSpriteNode {
    required init?(coder aDecoder: NSCoder) {
        fatalError("Use init()")
    }
    
    init() {
        let texture = SKTexture(imageNamed: "blueplayer0")
        super.init(texture: texture, color: .white,
                   size: texture.size())
        name = "Player"
        zPosition = 50
        
        physicsBody = SKPhysicsBody(circleOfRadius: size.width/2)
        physicsBody?.restitution = 0.0
        physicsBody?.linearDamping = 0.0
        physicsBody?.friction = 0
        physicsBody?.allowsRotation = false
        physicsBody?.velocity = CGVector(dx: 0.0, dy: 0.0)
    }
    
    func move(target: CGPoint) {
        guard let physicsBody = physicsBody else { return }
        
        let newVelocity = target
        print("playerVelocity: \(newVelocity.x)")
        physicsBody.velocity = CGVector(dx: newVelocity.x, dy: newVelocity.y)
        physicsBody.angularVelocity = 0
    }
}
