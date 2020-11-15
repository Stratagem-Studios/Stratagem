import SpriteKit
import GameplayKit
import UIKit
import CoreData

class GameScene: SKScene {
    
    // These vars will be used to refrence labels
    var metalCountLabel: SKLabelNode?
    var goldCountLabel: SKLabelNode?
    var usernameLabel: SKLabelNode?
    
    // This var keeps track of the most recent frame's time
    private var lastUpdateTime : TimeInterval = 0
    
    
    // PlayerVars instantiates the GameVariables class which holds the variables for in-game use
    // Materials follow this pattern
    // [enum, timerMax, timerLive, actual count]
    var playerVars = GameVariables()
    
    // This var holds a refrence to the content view
    var contentView: ContentView?
    
    // Runs when scene loaded, used to init things
    override func sceneDidLoad() {
        
        // Sets label vars to respective labels and puts them in an array
        self.metalCountLabel = self.childNode(withName: "//metalCountLabel") as? SKLabelNode
        self.goldCountLabel = self.childNode(withName: "//goldCountLabel") as? SKLabelNode
        self.usernameLabel = self.childNode(withName: "//usernameLabel") as? SKLabelNode
        
        // Sets all labels in proper positions
        
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
        metalCountLabel?.text = "Metal: " + String(playerVars.gameResources[0].quantity)
        goldCountLabel?.text = "Gold: " + String(playerVars.gameResources[1].quantity)
    }
        
        
    func updateResources(deltaTime: Double)  {
        for i in 0...1 {
            let currentMaxTimer = playerVars.gameResources[i].timerMax
            playerVars.gameResources[i].timerLive -= deltaTime
            if playerVars.gameResources[i].timerLive < 0 {
                let excessTime = -playerVars.gameResources[i].timerLive
                playerVars.gameResources[i].timerLive = currentMaxTimer - excessTime
                playerVars.gameResources[i].quantity += 1
            }
        }
    }
    
}
