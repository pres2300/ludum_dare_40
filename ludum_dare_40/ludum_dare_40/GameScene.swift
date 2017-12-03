//
//  GameScene.swift
//  ludum_dare_40
//
//  Created by Jacob Preston on 12/3/17.
//  Copyright © 2017 Jacob Preston. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    let player = SKSpriteNode(imageNamed: "player")
    let upArrow = SKSpriteNode(imageNamed: "up")
    let downArrow = SKSpriteNode(imageNamed: "down")
    let playArea: CGRect
    var touched: Bool = false
    var moving: Bool = false
    var scale: CGFloat = 0.25
    var touchLocation = CGPoint()
    var enemySpeed: TimeInterval = 4.0
    var lastSpeedIncrease: TimeInterval = 0.0
    let speedIncreaseInterval: TimeInterval = 15.0
    let speedIncreaseIncrement: TimeInterval = 0.85 // The lower the number, the faster the enemy moves
    var enemySpawnRate: TimeInterval = 2.0
    var invincible: Bool = false
    var lives: Int = 11
    var enemyExists: Bool = false
    
    // Player actions
    let actionUp = SKAction.moveBy(x: 0.0, y: 400, duration: 0.1)
    let actionDown = SKAction.moveBy(x: 0.0, y: -400, duration: 0.1)
    
    override init(size: CGSize) {
        let maxAspectRatio:CGFloat = 16.0/9.0
        let playableHeight = size.width / maxAspectRatio
        let playableMargin = (size.height-playableHeight)/2.0
        playArea = CGRect(x: 0, y: playableMargin,
                              width: size.width,
                              height: playableHeight)
        
        super.init(size: size)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func didMove(to view: SKView) {
        backgroundColor = SKColor.white
        
        player.zPosition = 100
        player.setScale(scale)
        player.position = CGPoint(x: 400, y: size.height/2)
        addChild(player)
        
        upArrow.zPosition = 1
        upArrow.position = CGPoint(x: 7*(size.width/8), y: size.height/2)
        addChild(upArrow)
        
        downArrow.zPosition = 1
        downArrow.position = CGPoint(x: size.width/8, y: size.height/2)
        addChild(downArrow)
    }
    
    override func update(_ currentTime: TimeInterval) {
        if 0 >= lives {
            let block = SKAction.run {
                let myScene = GameOverScene(size: self.size)
                myScene.scaleMode = self.scaleMode
                let reveal = SKTransition.fade(withDuration: 1.5)
                self.view?.presentScene(myScene, transition: reveal)
            }
            self.run(block)
        }
        
        if !enemyExists {
            enemyExists = true
            spawnEnemy()
        }
        
        if touched && !moving {
            
            if touchLocation.x > size.width/2 {
                playerJump()
            }
            else {
                playerDuck()
            }
        }
        
        if currentTime - lastSpeedIncrease > speedIncreaseInterval {
            lastSpeedIncrease = currentTime
            if enemySpeed > 0.1 {
                enemySpeed = enemySpeed*0.75
            }
        }
    }
    
    override func didEvaluateActions() {
        checkCollisions()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        touchLocation = touch.location(in: self)
        touched = true
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        touched = false
        moving = false
        let actionReturn = SKAction.move(to: CGPoint(x: 400, y: size.height/2), duration: 0.1)
        
        player.run(actionReturn)
    }
    
    func checkCollisions() {
        if invincible {
            return
        }
        var hitEnemies: [SKSpriteNode] = []
        enumerateChildNodes(withName: "enemy") { node, _ in
            let enemy = node as! SKSpriteNode
            if enemy.frame.intersects(self.player.frame) {
                hitEnemies.append(enemy)
            }
        }
        for _ in hitEnemies {
            playerHit()
        }
    }
    
    func playerJump() {
        moving = true
        player.run(actionUp)
    }
    
    func playerDuck() {
        moving = true
        player.run(actionDown)
    }
    
    func playerHit() {
        invincible = true
        
        let growAction = SKAction.scale(by: 1.2, duration: 0.25)
        
        let blinkTimes = 10.0
        let duration = 1.0
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
        
        let groupActions = SKAction.group([growAction, blinkAction])
        
        lives -= 1
        
        player.run(SKAction.sequence([groupActions, setHidden]))
    }
    
    func spawnEnemy() {
        let enemy = SKSpriteNode(imageNamed: "enemy")
        let topOrBot = arc4random() % 2
        var yPosition = CGFloat()
        enemy.zPosition = 50
        
        if topOrBot > 0 {
            yPosition = playArea.maxY - enemy.size.height/2
        }
        else {
            yPosition = playArea.minY + enemy.size.height/2
        }
        enemy.name = "enemy"
        enemy.position = CGPoint(
            x: playArea.maxX + enemy.size.width/2,
            y: yPosition)
        addChild(enemy)
        
        let actionMove = SKAction.moveBy(x: -(size.width + enemy.size.width), y: 0, duration: enemySpeed)
        let actionRemove = SKAction.removeFromParent()
        let setEnemyExists = SKAction.run() { [weak self] in
            self?.enemyExists = false
        }
        enemy.run(SKAction.sequence([actionMove, actionRemove, setEnemyExists]))
    }
}
