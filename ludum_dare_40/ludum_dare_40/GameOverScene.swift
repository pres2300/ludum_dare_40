//
//  GameOverScene.swift
//  ludum_dare_40
//
//  Created by Jacob Preston on 12/3/17.
//  Copyright © 2017 Jacob Preston. All rights reserved.
//

import Foundation
import SpriteKit

class GameOverScene: SKScene {
    override func didMove(to view: SKView) {
        backgroundColor = SKColor.white
        
        let gameOverLabel = SKLabelNode(fontNamed: "North to South")
        
        gameOverLabel.text = "Game over."
        gameOverLabel.fontColor = SKColor.black
        gameOverLabel.fontSize = 100
        gameOverLabel.zPosition = 150
        gameOverLabel.horizontalAlignmentMode = .center
        gameOverLabel.verticalAlignmentMode = .center
        gameOverLabel.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(gameOverLabel)
        
        let wait = SKAction.wait(forDuration: 3.0)
        let block = SKAction.run {
            let myScene = MainMenuScene(size: self.size)
            myScene.scaleMode = self.scaleMode
            let reveal = SKTransition.doorsCloseHorizontal(withDuration: 0.5)
            self.view?.presentScene(myScene, transition: reveal)
        }
        
        self.run(SKAction.sequence([wait, block]))
    }
}
