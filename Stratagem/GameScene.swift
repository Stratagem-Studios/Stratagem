import SpriteKit
import GameplayKit
import UIKit

class GameScene: SKScene {

    // These vars will be used to reference labels
    var metalCount: SKLabelNode?
    var goldCount: SKLabelNode?
    
    // This var keeps track of the most recent frame's time
    private var lastUpdateTime : TimeInterval = 0
    
    // PlayerVars instantiates the Variables class which holds the variables
    // Materials follow this pattern
    // [enum, cooldownMax, timerLive, actual count]
    var playerVars = Variables()
    
    // Runs when scene loaded, used to init things
    override func sceneDidLoad() {
        
        // Sets label vars to respective labels and puts them in an array
        self.metalCount = self.childNode(withName: "//metalCountLabel") as? SKLabelNode
        self.goldCount = self.childNode(withName: "//goldCountLabel") as? SKLabelNode
        let labelArray = [metalCount, goldCount]
        
        
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
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
        
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update & set lastUpdateTime for next frame
        let dt = currentTime - self.lastUpdateTime
        self.lastUpdateTime = currentTime
        
        // Update resources
        updateResources(deltaTime: dt)
        
        // Seting all labels to refelect var values
        metalCount?.text = "Metal: " + String(playerVars.gameResources[0].resourceQuantity)
        goldCount?.text = "Gold: " + String(playerVars.gameResources[1].resourceQuantity)
    }
        
        
    func updateResources(deltaTime: Double)  {
        for i in 0...1 {
            let currentMaxTimer = playerVars.gameResources[i].resourceMaxTimer
            playerVars.gameResources[i].resourceLiveTimer -= deltaTime
            if playerVars.gameResources[i].resourceLiveTimer < 0 {
                playerVars.gameResources[i].resourceLiveTimer = currentMaxTimer
                playerVars.gameResources[i].resourceQuantity += 1
            }
        }

    }
    
}
