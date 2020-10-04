///
//  GameScene.swift
//
//  Created by Tommy Keaty on 12/22/17.
//  Copyright (c) 2017 Tommy Keaty. All rights reserved.
//
import SpriteKit

class Level3: SKScene {
    var lastUpdateTime: TimeInterval = 0
    var dt: TimeInterval = 0
    let player = Player()
    let dpad = SKSpriteNode(imageNamed: "dPad")
    let rpad = SKSpriteNode(imageNamed: "dPad")
    let playerMovePPS = 500.0
    var velocity = CGPoint.zero
    var playableRect: CGRect
    var lastTouchLoc = CGPoint.zero
    let playerRadPerSec: CGFloat = 4.0*π
    var invincible: Bool
    let bacteriaMovePPS: CGFloat = 525.0
    var lives = 3
    var gameOver = false
    let cameraNode = SKCameraNode()
    let cameraMovePPS: CGFloat = 300.0
    var roundBacteria: [SKSpriteNode] = []
    var bacteriaHP: [CGFloat] = []
    var bacteriaSpawnTime: [Double] = []
    var bacteriaInds: [SKSpriteNode: Int] = [:]
    var background = SKSpriteNode()
    let bulletMovePPS: CGFloat = 2000.0
    var bottomLeft: CGPoint
    var topRight: CGPoint
    let divideAnimation: SKAction
    var dpadRadius: CGFloat
    let bacteriaAnimation: SKAction
    let bacteriaDie: SKAction
    let bulletAnimation: SKAction
    var kills = 0
    let killsLabel = SKLabelNode(fontNamed: "Dimitri")
    let livesLabel = SKLabelNode(fontNamed: "Dimitri")
    let lifeGuy0 = SKSpriteNode(imageNamed: "littledude")
    let lifeGuy1 = SKSpriteNode(imageNamed: "littledude")
    let lifeGuy2 = SKSpriteNode(imageNamed: "littledude")
    var squareSize: CGRect
    var bacteriaCount = 0
    var bacteriaArr: [SKSpriteNode]
    var lastSpawn: TimeInterval
    var lastPlasmid: TimeInterval
    let bLimit = 12
    let round = 30
    var spawnCount = 0
    var invincibleTime: TimeInterval
    
    
    override func didMove(to view: SKView) {
        
        background = backgroundNode()
        background.anchorPoint = CGPoint.zero
        background.position = CGPoint.zero
        background.name = "background"
        player.zPosition = 100
        player.setScale(0.5)
        player.zRotation = player.zRotation
        background.zPosition = -1
        dpad.alpha = 0.15
        dpad.color = SKColor.cyan
        dpad.colorBlendFactor = 0.5
        dpad.setScale(1.75)
        dpad.zPosition = 200
        dpadRadius = dpad.frame.height/2
        rpad.alpha = 0.15
        rpad.color = SKColor.cyan
        rpad.colorBlendFactor = 0.5
        rpad.setScale(1.75)
        rpad.zPosition = 200
        physicsWorld.gravity = CGVector(dx: 0.0, dy: 0.0)
        addChild(cameraNode)
        camera = cameraNode
        
        bottomLeft = CGPoint(x: background.frame.width/4, y: background.frame.height/4)
        topRight = CGPoint(x: background.frame.width, y: background.frame.height)
        topRight = topRight - bottomLeft
        
        playableRect = CGRect(x: background.frame.width/4, y: background.frame.height/4, width: background.frame.width/2, height: background.frame.height/2)
        
        cameraNode.position = CGPoint(x: playableRect.width, y: playableRect.height)
        player.position = CGPoint(x: playableRect.width, y: playableRect.height)
        
        background.physicsBody = SKPhysicsBody(edgeLoopFrom: playableRect)
        background.physicsBody?.friction = 0
        rpad.position = player.position + CGPoint(x: 500, y: -200)
        dpad.position = player.position + CGPoint(x: -500, y: -200)
        
        killsLabel.zPosition = 80
        killsLabel.text = "Bacteria Left: 0"
        killsLabel.color = SKColor.blue
        killsLabel.setScale(2.5)
        killsLabel.horizontalAlignmentMode = .left
        killsLabel.verticalAlignmentMode = .bottom
        killsLabel.position = CGPoint(
            x: 30,
            y: background.frame.height/2 - 30)
        
        livesLabel.zPosition = 80
        livesLabel.text = "Lives:"
        livesLabel.color = SKColor.blue
        livesLabel.setScale(2.5)
        livesLabel.horizontalAlignmentMode = .left
        livesLabel.verticalAlignmentMode = .top
        livesLabel.position = CGPoint(
            x: 30,
            y: background.frame.height/2 + 30)
        lifeGuy0.zPosition = 80
        lifeGuy1.zPosition = 80
        lifeGuy2.zPosition = 80
        lifeGuy0.position = livesLabel.position + CGPoint(x: 200, y: -10)
        lifeGuy1.position = lifeGuy0.position + CGPoint(x: 80, y: -10)
        lifeGuy2.position = lifeGuy1.position + CGPoint(x: 80, y: -10)
        lifeGuy2.setScale(0.5)
        lifeGuy0.setScale(0.5)
        lifeGuy1.setScale(0.5)
        addChild(killsLabel)
        addChild(livesLabel)
        addChild(lifeGuy0)
        addChild(lifeGuy2)
        addChild(lifeGuy1)
        
        addChild(dpad)
        addChild(rpad)
        addChild(player)
        addChild(background)
        debugDrawPlayableArea()
        physicsWorld.gravity = CGVector(dx: 0.0, dy: 0.0)
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.frame.width/2 - 60)
        
        run(SKAction.repeatForever(
            SKAction.sequence([SKAction.run() { [weak self] in
                self?.spawnBullet()
                },
                               SKAction.wait(forDuration: 0.3)])))
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        if currentTime - lastSpawn > 1.5 && bacteriaCount < bLimit && spawnCount < round{
            lastSpawn = currentTime
            spawnBacteria()
            spawnCount += 1
        }
        
        if currentTime - lastPlasmid > 8{
            lastPlasmid = currentTime
            spawnPlasmid()
        }
        
        bacteriaArr = getBacteria()
        bacteriaCount = bacteriaArr.count
        
        boundsCheck()
        moveCamera()
        player.move(target: velocity)
        moveBacteria()
        moveBullet()
        
        killsLabel.text = "Bacteria Left: \(round-spawnCount)"
        
        if lastUpdateTime > 0{
            dt = currentTime - lastUpdateTime
        }
        else{
            dt = 0
        }
        
        lastUpdateTime = currentTime
        
        if spawnCount == round && bacteriaCount == 0 && !gameOver{
            gameOver = true
            stopAll()
            player.texture = SKTexture(imageNamed: "littledude")
            let transitionScene = WinScreen(size: size)
            transitionScene.scaleMode = scaleMode
            let reveal = SKTransition.fade(withDuration: 3.0)
            reveal.pausesOutgoingScene = false
            view?.presentScene(transitionScene, transition: reveal)
            let flipit = SKAction.run() { [weak self] in
                self?.view?.presentScene(transitionScene, transition: reveal)
            }
            let winna = SKAction.run() { [weak self] in
                self?.player.run(SKAction.scale(to: 3.0, duration: 3.0))
            }
            run(SKAction.sequence([winna,SKAction.wait(forDuration: 3.0),flipit]))
        }
        if lives < 0 && !gameOver{
            gameOver = true
            stopAll()
            let transitionScene = LoseScreen(size: size)
            transitionScene.scaleMode = scaleMode
            let reveal = SKTransition.fade(withDuration: 3.0)
            reveal.pausesOutgoingScene = false
            view?.presentScene(transitionScene, transition: reveal)
            let flipit = SKAction.run() { [weak self] in
                self?.view?.presentScene(transitionScene, transition: reveal)
            }
            let winna = SKAction.run() { [weak self] in
                self?.player.run(SKAction.rotate(byAngle: 12*π, duration: 6))
            }
            run(SKAction.sequence([winna,SKAction.wait(forDuration: 6.0),flipit]))
        }
    }
    
    func setupWorldPhysics() {
        background.physicsBody =
            SKPhysicsBody(edgeLoopFrom: playableRect)
    }
    
    func moveplayerToward(location: CGPoint){
        let offset = location - dpad.position
        let direction = offset.normalized()
        velocity = direction*CGFloat(playerMovePPS)
        
    }
    
    func sceneTouched(touchLoc: CGPoint){
        if dpad.frame.contains(touchLoc){
            moveplayerToward(location: touchLoc)
        }
        else{
            let offset = touchLoc - rpad.position
            if rpad.frame.contains(touchLoc){
                rotate(sprite: player, direction: offset, radPerSec: playerRadPerSec)
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        guard let touch = touches.first else{
            return
        }
        for touchLoc in touches{
            sceneTouched(touchLoc: touchLoc.location(in:self))
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?){
        guard let touch = touches.first else{
            return
        }
        for touchLoc in touches{
            sceneTouched(touchLoc: touchLoc.location(in:self))
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>,
                               with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        velocity = CGPoint.zero
    }
    
    
    func boundsCheck(){
        
        if player.position.x < bottomLeft.x{
            player.position.x = bottomLeft.x
            velocity.x = 0
        }
        if player.position.x > background.frame.width{
            player.position.x = background.frame.width
            velocity.x = 0
        }
        if player.position.y < bottomLeft.y{
            player.position.y = bottomLeft.y
            velocity.y = 0
        }
        if player.position.y > background.frame.height{
            player.position.y = background.frame.height
            velocity.y = 0
        }
    }
    
    
    
    override init(size: CGSize){
        let maxAspRatio: CGFloat = 16.0/9.0
        let playableHeight = size.width/maxAspRatio
        let playableMargin = (size.height-playableHeight)/2.0
        playableRect = CGRect(x:0, y: playableMargin, width: size.width, height: playableHeight)
        squareSize = playableRect
        var textures:[SKTexture] = []
        for i in 1...5 {
            textures.append(SKTexture(imageNamed: "Bacteria5D\(i)"))
        }
        divideAnimation = SKAction.animate(with: textures, timePerFrame: 0.2)
        invincible = false
        bottomLeft = CGPoint(x: playableRect.minX, y: playableRect.minY)
        topRight = CGPoint(x: playableRect.maxX, y: playableRect.maxY)
        dpadRadius = 0.0
        textures = []
        for i in 0...1{
            textures.append(SKTexture(imageNamed: "blast\(i)"))
        }
        bulletAnimation = SKAction.animate(with: textures, timePerFrame: 0.1)
        textures = []
        var dextures: [SKTexture] = []
        textures.append(SKTexture(imageNamed: "Bacteria5"))
        for i in 1...2{
            textures.append(SKTexture(imageNamed: "Bacteria5M\(i)"))
            dextures.append(SKTexture(imageNamed: "Bacteria5K\(i)"))
        }
        dextures.append(SKTexture(imageNamed: "Bacteria5K3"))
        bacteriaAnimation = SKAction.animate(with: textures, timePerFrame: 0.1)
        bacteriaDie = SKAction.animate(with: dextures, timePerFrame: 0.1)
        bacteriaArr = []
        lastSpawn = 0.0
        lastPlasmid = 0.0
        invincibleTime = 0.0
        
        super.init(size: size)
    }
    
    required init(coder aDecoder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
    
    func rotate(sprite: SKSpriteNode, direction: CGPoint, radPerSec: CGFloat){
        sprite.zRotation = direction.angle + π/2
    }
    
    func startAnimation(sprite: SKSpriteNode){
        if sprite.action(forKey: "animation") == nil{
            let remove = SKAction.removeFromParent()
            let sequence = SKAction.sequence([divideAnimation,remove])
            let x1 = sprite.position.x + 50
            let x2 = sprite.position.x - 50
            let pos1 = CGPoint(x: x1, y: sprite.position.y)
            let pos2 = CGPoint(x: x2, y: sprite.position.y)
            
            sprite.run(sequence)
            multiplyBacteria(position: pos1)
            multiplyBacteria(position: pos2)
        }
    }
    
    func stopAnimation(sprite: SKSpriteNode){
        sprite.removeAction(forKey: "animation")
    }
    
    func multiplyBacteria(position: CGPoint){
        let bacteria = SKSpriteNode(imageNamed: "Bacteria5")
        kills += 1
        bacteria.name = "childBacteria"
        bacteria.position = position
        bacteria.zPosition = 50
        bacteria.setScale(0)
        roundBacteria.append(bacteria)
        bacteriaHP.append(100)
        bacteria.setScale(0.0)
        bacteriaSpawnTime.append(lastUpdateTime)
        bacteriaInds[bacteria] = roundBacteria.count-1
        addChild(bacteria)
        bacteria.run(SKAction.repeatForever(bacteriaAnimation))
        bacteria.run(SKAction.sequence([SKAction.wait(forDuration: 1.0),SKAction.scale(to: 0.7, duration: 0.2)]))
    }
    
    func resist(bacteria: SKSpriteNode){
        bacteria.zPosition = 51
        let stopResisting = SKAction.run() { [weak self] in
            bacteria.zPosition = 50
        }
        let resistSequence = SKAction.sequence([SKAction.scale(to: 1.0, duration: 0.75),SKAction.scale(to: 0.7, duration: 0.75)])
        let resisting = SKAction.repeat(resistSequence, count: 6)
        bacteria.run(SKAction.sequence([resisting,stopResisting]))
    }
    
    func debugDrawPlayableArea() {
        let shape = SKShapeNode()
        let path = CGMutablePath()
        path.addRect(playableRect)
        shape.path = path
        shape.strokeColor = SKColor.blue
        shape.lineWidth = 4.0
        addChild(shape)
    }
    
    func spawnBacteria(){
        let bacteria = SKSpriteNode(imageNamed: "Bacteria5")
        bacteria.name = "bacteria"
        bacteria.position = CGPoint(
            x: CGFloat.random(min: playableRect.minX, max: playableRect.maxX),
            y: CGFloat.random(min: playableRect.minY, max: playableRect.maxY))
        bacteria.zPosition = 50
        bacteria.setScale(0)
        roundBacteria.append(bacteria)
        bacteriaHP.append(100)
        bacteriaSpawnTime.append(lastUpdateTime)
        bacteriaInds[bacteria] = roundBacteria.count-1
        if spawnCount == 0{
            let spawnDelay = SKAction.run() { [weak self] in
                self?.addChild(bacteria)
            }
            run(SKAction.sequence([SKAction.wait(forDuration: 3.0),spawnDelay]))
        }
        else if !bacteria.frame.intersects(player.frame){
            addChild(bacteria)
        }
        bacteria.zRotation = -π/16.0
        bacteria.setScale(0.7)
        bacteria.run(SKAction.repeatForever(bacteriaAnimation))
    }
    
    func spawnBullet(){
        run(SKAction.playSoundFileNamed("blaster.wav",
                                        waitForCompletion: false))
        let bullet = SKSpriteNode(imageNamed: "blast0")
        bullet.name = "bullet"
        bullet.position = CGPoint(x:player.position.x,y:player.position.y)
        bullet.zPosition = 10
        bullet.zRotation = player.zRotation - π/2
        bullet.setScale(0.3)
        bullet.run(SKAction.repeatForever(bulletAnimation))
        addChild(bullet)
    }
    
    func spawnPlasmid(){
        let plasmid = SKSpriteNode(imageNamed: "plasmid")
        plasmid.name = "plasmid"
        plasmid.zPosition = 5
        plasmid.setScale(0.1)
        let rotate = SKAction.rotate(byAngle: π, duration: 3.0)
        plasmid.run(SKAction.sequence([SKAction.repeat(rotate, count: 3),SKAction.removeFromParent()]))
        plasmid.position = CGPoint(
            x: CGFloat.random(min: playableRect.minX, max: playableRect.maxX),
            y: CGFloat.random(min: playableRect.minY, max: playableRect.maxY))
        addChild(plasmid)
    }
    
    func playerHit(enemy: SKSpriteNode){
        invincible = true
        let blinkTimes = 10.0
        let duration = 3.0
        let blinkAction = SKAction.customAction(withDuration: duration) { node, elapsedTime in
            let slice = duration / blinkTimes
            let remainder = Double(elapsedTime).truncatingRemainder(
                dividingBy: slice)
            node.isHidden = remainder > slice / 2
        }
        let setHidden = SKAction.run() { [weak self] in
            self?.player.isHidden = false
            self?.invincible = false
        }
        player.run(SKAction.sequence([blinkAction, setHidden]))
        lives -= 1
        print(lives)
        
        if lives == 2{
            lifeGuy2.setScale(0.0)
        }
        else if lives == 1{
            lifeGuy1.setScale(0.0)
        }
        else if lives == 0{
            lifeGuy0.setScale(0.0)
        }
    }
    
    func checkCollisions(){
        
        var shotbacteria: [SKSpriteNode] = []
        let plasmids = getPlasmids()
        let bullets = getBullets()
        
        
        for bact in bacteriaArr{
            
            let bwidth = bact.frame.width
            let bheight = bact.frame.height
            
            if bact.name == "childBacteria"{
                
                if bact.zPosition != 51{
                    for bullet in bullets{
                        if bullet.frame.intersects(bact.frame.insetBy(dx: 0.35*bwidth, dy: 0.35*bheight)){
                            shotbacteria.append(bact)
                            bullet.removeAllActions()
                            bullet.removeFromParent()
                        }
                    }
                }
                
                for plasmid in plasmids{
                    if plasmid.frame.intersects(bact.frame.insetBy(dx: 0.35*bwidth, dy: 0.35*bheight)) && bact.zPosition != 51{
                        resist(bacteria: bact)
                        plasmid.run(SKAction.sequence([SKAction.scale(to: 0.0, duration: 0.2),SKAction.removeFromParent()]))
                    }
                }
                
                if player.frame.intersects(bact.frame.insetBy(dx: 0.35*bwidth, dy: 0.35*bheight)) && !invincible{
                    self.playerHit(enemy: bact)
                }
            }
            else{
                
                if bact.zPosition != 51{
                    for bullet in bullets{
                        if bullet.frame.intersects(bact.frame.insetBy(dx: 0.35*bwidth, dy: 0.35*bheight)){
                            shotbacteria.append(bact)
                            bullet.removeAllActions()
                            bullet.removeFromParent()
                        }
                    }
                }
                
                for plasmid in plasmids{
                    if plasmid.frame.intersects(bact.frame.insetBy(dx: 0.35*bwidth, dy: 0.35*bheight)) && bact.zPosition != 51{
                        resist(bacteria: bact)
                        plasmid.run(SKAction.sequence([SKAction.scale(to: 0.0, duration: 0.2),SKAction.removeFromParent()]))
                    }
                }
                
                if player.frame.intersects(bact.frame.insetBy(dx: 0.35*bwidth, dy: 0.35*bheight)) && !invincible{
                    self.playerHit(enemy: bact)
                }
            }
        }
        
        for bact in shotbacteria{
            shot(sprite: bact)
        }
        
    }
    
    func getBacteria() -> [SKSpriteNode]{
        var bacterias: [SKSpriteNode] = []
        enumerateChildNodes(withName: "bacteria") {node, _ in
            let bacteria = node as! SKSpriteNode
            bacterias.append(bacteria)
        }
        enumerateChildNodes(withName: "childBacteria") {node, _ in
            let bacteria = node as! SKSpriteNode
            bacterias.append(bacteria)
        }
        return bacterias
    }
    
    func getBullets() -> [SKSpriteNode]{
        var bullets: [SKSpriteNode] = []
        enumerateChildNodes(withName: "bullet"){node, _ in
            let bullet = node as! SKSpriteNode
            bullets.append(bullet)
        }
        return bullets
    }
    
    func getPlasmids() -> [SKSpriteNode]{
        var plasmids: [SKSpriteNode] = []
        enumerateChildNodes(withName: "plasmid"){node, _ in
            let plasmid = node as! SKSpriteNode
            plasmids.append(plasmid)
        }
        return plasmids
    }
    
    func shot(sprite: SKSpriteNode){
        let index = bacteriaInds[sprite]
        let hp = bacteriaHP[index!]
        if hp > 50{
            run(SKAction.playSoundFileNamed("plop.wav",
                                            waitForCompletion: false))
            bacteriaHP[index!] -= 50
            sprite.removeAllActions()
            let pix: [SKTexture] = [SKTexture(imageNamed: "Bacteria5"),SKTexture(imageNamed: "Bacteria5K1"),SKTexture(imageNamed: "Bacteria5")]
            let anim = SKAction.animate(with: pix, timePerFrame: 0.1)
            sprite.run(SKAction.sequence([anim,SKAction.repeatForever(bacteriaAnimation)]))
        }
        else if sprite.zPosition != 24{
            run(SKAction.playSoundFileNamed("bubbles.wav",
                                            waitForCompletion: false))
            bacteriaHP[index!] = 0
            kills -= 1
            print(String(kills))
            sprite.removeAllActions()
            sprite.zPosition = 24
            sprite.run(SKAction.sequence([bacteriaDie,SKAction.removeFromParent()]))
        }
    }
    
    override func didEvaluateActions() {
        checkCollisions()
    }
    
    func blink(sprite: SKSpriteNode){
        let blinkTime = 10.0
        let duration = 3.0
        sprite.run(SKAction.customAction(withDuration: duration){node, elapsedTime in
            let slice = duration/blinkTime
            let remainder = Double(elapsedTime).truncatingRemainder(dividingBy: slice)
            node.isHidden = remainder > slice/2
        })
    }
    
    func moveBacteria(){
        let direction = player.position
        
        for bact in bacteriaArr{
            
            let randomNum:UInt32 = arc4random_uniform(200)
            let index = bacteriaInds[bact]
            if randomNum == 3 && (bacteriaSpawnTime[index!] + 5.0) < lastUpdateTime{
                startAnimation(sprite: bact)
            }
            else{
                let actionDuration = 0.3
                let targetVect = direction - bact.position
                let normVect = targetVect.normalized()
                var movePoint = normVect*bacteriaMovePPS*CGFloat(self.dt)
                if bact.zPosition == 51{
                    movePoint = normVect*500.0*CGFloat(self.dt)
                }
                let moveVect = CGVector(dx: movePoint.x, dy: movePoint.y)
                
                let moveAction = SKAction.move(by: moveVect, duration: actionDuration)
                bact.run(moveAction)
            }
        }
    }
    
    func moveBullet(){
        
        enumerateChildNodes(withName: "bullet"){node, stop in
            
            let position = node.position
            if !(self.background.frame.contains(position)){
                print("remove")
                node.removeFromParent()
            }
                
            else{
                let y = sin(node.zRotation)
                let x = cos(node.zRotation)
                let movePoint = CGPoint(x: x, y: y)*self.bulletMovePPS*CGFloat(self.dt)
                node.position += movePoint
            }
        }
    }
    
    func backgroundNode() -> SKSpriteNode{
        
        let backgroundNode = SKSpriteNode()
        backgroundNode.anchorPoint = CGPoint.zero
        backgroundNode.name = "background"
        
        let b1 = SKSpriteNode(imageNamed: "bodybackground")
        b1.anchorPoint = CGPoint.zero
        b1.position = CGPoint(x:0, y:0)
        squareSize = b1.frame
        
        let b2 = SKSpriteNode(imageNamed: "bodybackground")
        b2.anchorPoint = CGPoint.zero
        b2.position = CGPoint(x:b1.size.width, y:0)
        
        let b3 = SKSpriteNode(imageNamed: "bodybackground")
        b3.anchorPoint = CGPoint.zero
        b3.position = CGPoint(x:0, y:b1.size.height)
        
        let b4 = SKSpriteNode(imageNamed: "bodybackground")
        b4.anchorPoint = CGPoint.zero
        b4.position = CGPoint(x:b1.size.width, y:b1.size.height)
        
        backgroundNode.addChild(b1)
        backgroundNode.addChild(b2)
        backgroundNode.addChild(b3)
        backgroundNode.addChild(b4)
        
        backgroundNode.size = CGSize(width: b1.size.width*2, height: b1.size.height*2)
        
        return backgroundNode
    }
    
    
    func moveCamera(){
        
        cameraNode.position = player.position
        rpad.position = player.position + CGPoint(x: 500, y: -200)
        dpad.position = player.position + CGPoint(x: -500, y: -200)
        killsLabel.position = player.position + CGPoint(x: -900, y: -500)
        livesLabel.position = player.position + CGPoint(x: -900, y: 500)
        lifeGuy0.position = livesLabel.position + CGPoint(x: 300, y: -35)
        lifeGuy1.position = lifeGuy0.position + CGPoint(x: 80, y: 0)
        lifeGuy2.position = lifeGuy1.position + CGPoint(x: 80, y: 0)
        
    }
    
    func stopAll(){
        for bacteria in bacteriaArr{
            bacteria.removeAllActions()
        }
    }
}


