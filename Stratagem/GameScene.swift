//
//  GameScene.swift
//  Stratagem
//
//  Created by 90306997 on 10/20/20.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {

    // These vars will be used to refrence labels
    var metalCount: SKLabelNode?
    
    
    // PlayerVars instantiates the Variables class which holds the variables
    var playerVars = Variables()
    
    // Runs when scene loaded, used to init things
    override func sceneDidLoad() {
        
        // Sets label vars to respective labels
        self.metalCount = self.childNode(withName: "//metalCountLabel") as? SKLabelNode
        
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        playerVars.gameResources.metal += 1
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
    }
    
    func touchUp(atPoint pos : CGPoint) {
        
    }
    
    
    // The following functions just trigger functions listed above
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    
    // Called before each frame is rendered
    override func update(_ currentTime: TimeInterval) {
        // Seting all labels to refelect var values
        metalCount?.text = "Metal: " + String(playerVars.gameResources.metal)
    }
}
