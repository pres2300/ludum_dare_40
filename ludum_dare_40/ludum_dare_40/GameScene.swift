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
    let playArea: CGRect
    var touched: Bool = false
    var moving: Bool = false
    var scale: CGFloat = 0.25
    var touchLocation = CGPoint()
    
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
        
        run(SKAction.repeatForever(
            SKAction.sequence([SKAction.run() { [weak self] in
                self?.spawnEnemy()
                },
                SKAction.wait(forDuration: 2.0)])))
    }
    
    override func update(_ currentTime: TimeInterval) {
        if touched && !moving {
            
            if touchLocation.x > size.width/2 {
                playerJump()
            }
            else {
                playerDuck()
            }
        }
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
    
    func playerJump() {
        moving = true
        player.run(actionUp)
    }
    
    func playerDuck() {
        moving = true
        player.run(actionDown)
    }
    
    func spawnEnemy() {
        let enemy = SKSpriteNode(imageNamed: "enemy")
        enemy.name = "enemy"
        enemy.position = CGPoint(
            x: playArea.maxX + enemy.size.width/2,
            y: CGFloat.random(
                min: playArea.minY + enemy.size.height/2,
                max: playArea.maxY - enemy.size.height/2))
        addChild(enemy)
        
        let actionMove = SKAction.moveBy(x: -(size.width + enemy.size.width), y: 0, duration: 2.0)
        let actionRemove = SKAction.removeFromParent()
        enemy.run(SKAction.sequence([actionMove, actionRemove]))
    }
}
