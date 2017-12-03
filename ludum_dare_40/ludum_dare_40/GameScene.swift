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
    var touched: Bool = false
    
    override func didMove(to view: SKView) {
        backgroundColor = SKColor.white
        
        player.position = CGPoint(x: 400, y: 400)
        player.zPosition = 100
        addChild(player)
    }
    
    override func update(_ currentTime: TimeInterval) {
        if(touched) {
            touched = true
            playerJump()
            print("Touched screen")
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !touched {
            touched = true
        }
    }
    
    func playerJump() {
        let actionUp = SKAction.moveBy(x: 0.0, y: player.size.height*2, duration: 0.5)
        let actionDown = actionUp.reversed()
        
        player.run(SKAction.sequence([actionUp, actionDown]))
        
        touched = false
    }
}
