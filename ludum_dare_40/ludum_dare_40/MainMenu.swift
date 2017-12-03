//
//  MainMenu.swift
//  ludum_dare_40
//
//  Created by Jacob Preston on 12/3/17.
//  Copyright © 2017 Jacob Preston. All rights reserved.
//

import Foundation
import SpriteKit

class MainMenuScene: SKScene {
    override func didMove(to view: SKView) {
        backgroundColor = SKColor.white
        
        let welcomeLabel = SKLabelNode(fontNamed: "North to South")
        
        welcomeLabel.text = "Welcome.  Tap to start."
        welcomeLabel.fontColor = SKColor.black
        welcomeLabel.fontSize = 100
        welcomeLabel.zPosition = 150
        welcomeLabel.horizontalAlignmentMode = .center
        welcomeLabel.verticalAlignmentMode = .center
        welcomeLabel.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(welcomeLabel)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>,
                               with event: UIEvent?) {
        sceneTapped()
    }
    
    func sceneTapped() {
        let block = SKAction.run {
            let myScene = GameScene(size: self.size)
            myScene.scaleMode = self.scaleMode
            let reveal = SKTransition.doorsOpenHorizontal(withDuration: 1.5)
            self.view?.presentScene(myScene, transition: reveal)
        }
        
        self.run(block)
    }
}
