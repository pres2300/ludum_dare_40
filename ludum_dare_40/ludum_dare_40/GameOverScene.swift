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
    let score: Int
    let playArea: CGRect
    
    init(size: CGSize, score: Int, playArea: CGRect) {
        self.score = score
        self.playArea = playArea
        super.init(size: size)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented!")
    }
    
    override func didMove(to view: SKView) {
        backgroundColor = SKColor.white
        
        let scoreLabel = SKLabelNode(fontNamed: "North to South")
        scoreLabel.text = "Final score: \(score)"
        scoreLabel.fontColor = SKColor.black
        scoreLabel.fontSize = 75
        scoreLabel.zPosition = 100
        scoreLabel.horizontalAlignmentMode = .center
        scoreLabel.verticalAlignmentMode = .top
        scoreLabel.position = CGPoint(
            x: playArea.maxX/2,
            y: playArea.maxY-120)
        addChild(scoreLabel)
        
        let gameOverLabel = SKLabelNode(fontNamed: "North to South")
        
        gameOverLabel.text = "Game over."
        gameOverLabel.fontColor = SKColor.black
        gameOverLabel.fontSize = 100
        gameOverLabel.zPosition = 150
        gameOverLabel.horizontalAlignmentMode = .center
        gameOverLabel.verticalAlignmentMode = .center
        gameOverLabel.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(gameOverLabel)
        
        let wait = SKAction.wait(forDuration: 5.0)
        let block = SKAction.run {
            let myScene = MainMenuScene(size: self.size)
            myScene.scaleMode = self.scaleMode
            let reveal = SKTransition.doorsCloseHorizontal(withDuration: 0.5)
            self.view?.presentScene(myScene, transition: reveal)
        }
        
        self.run(SKAction.sequence([wait, block]))
    }
}
