import SpriteKit
import GameplayKit
import UIKit
import CoreData

class GameScene: SKScene {
    
    // Vars to hold refs to gamescene objects
    var sceneCamera: SKCameraNode?
    var gameMap: SKTileMapNode?
    var metalCountLabel: SKLabelNode?
    var goldCountLabel: SKLabelNode?
    var usernameLabel: SKLabelNode?
    
    // This var keeps track of the most recent frame's time
    private var lastUpdateTime : TimeInterval = 0
    
    // Holds gameboard
    var gameBoard: GameBoard?
    
    // PlayerVars instantiates the GameVariables class which holds the variables for in-game use
    // Materials follow this pattern
    // [enum, timerMax, timerLive, actual count]
    var playerVars = GameVariables(gameType: GameTypes.standard)
    
    // This var holds a reference to the content view
    var contentView: ContentView?
    
    // Runs when scene loaded, used to init things
    override func sceneDidLoad() {
        
        // Sets all gamescene objects to refs
        self.gameMap = (self.childNode(withName: "//GameMap") as! SKTileMapNode)
        self.sceneCamera = self.childNode(withName: "//SceneCamera") as? SKCameraNode
        self.metalCountLabel = self.childNode(withName: "//MetalCountLabel") as? SKLabelNode
        self.goldCountLabel = self.childNode(withName: "//GoldCountLabel") as? SKLabelNode
        self.usernameLabel = self.childNode(withName: "//UsernameLabel") as? SKLabelNode
        
        gameBoard = GameBoard(tileMapNode: self.childNode(withName: "//GameMap") as! SKTileMapNode)
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
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
          return
        }

        let location = touch.location(in: self)
        let previousLocation = touch.previousLocation(in: self)
        sceneCamera!.position.x -= location.x - previousLocation.x
        sceneCamera!.position.y -= location.y - previousLocation.y
        
        if abs(sceneCamera!.position.x) >= 500.0 {
            if sceneCamera!.position.x > 0 {
                sceneCamera!.position.x = 500
            } else {
                sceneCamera!.position.x = -500
            }
        }
        if abs(sceneCamera!.position.y) >= 650{
            if sceneCamera!.position.y > 0 {
                sceneCamera!.position.y = 650
            } else {
                sceneCamera!.position.y = -650
            }
        }
        
        
    }
    
    func handleTapFrom(recognizer: UITapGestureRecognizer) {
        // Detects and reports the tapped tile
        
        if recognizer.state != .ended {
            return
        }

        let recognizorLocation = recognizer.location(in: recognizer.view!)
        let location = self.convertPoint(fromView: recognizorLocation)

        guard let map = gameMap else {
            fatalError("Map not loaded")
        }

        let column = map.tileColumnIndex(fromPosition: location)
        let row = map.tileRowIndex(fromPosition: location)
        let tile = map.tileDefinition(atColumn: column, row: row)
        
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
