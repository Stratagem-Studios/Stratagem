import SpriteKit
import GameplayKit
import UIKit
import CloudKit
import CoreData

class GameScene: SKScene {
    
    // Refrences the viewcontroller
    //var viewController = GameViewController()
    
    // Popup used to get username
    let alert = UIAlertController(title: "Alert Title", message: "Alert Message", preferredStyle: .alert)

    // Refernces the TileMapNode
    var playerGameMap: SKTileMapNode?
    // These vars will be used to reference labels
    var metalCountLabel: SKLabelNode?
    var goldCountLabel: SKLabelNode?
    var usernameLabel: SKLabelNode?
    
    // This var keeps track of the most recent frame's time
    private var lastUpdateTime : TimeInterval = 0
    
    
    // PlayerVars instantiates the GameVariables class which holds the variables for in-game use
    // Materials follow this pattern
    // [enum, cooldownMax, timerLive, actual count]
    var playerVars = GameVariables()
    
    // This var holds a refrence to the content view
    var contentView: ContentView?
    
    // Runs when scene loaded, used to init things
    override func sceneDidLoad() {
        
        // References the TileNode
        self.playerGameMap = self.childNode(withName: "//gameMap") as? SKTileMapNode
        
        // Sets label vars to respective labels and puts them in an array
        self.metalCountLabel = self.childNode(withName: "//metalCountLabel") as? SKLabelNode
        self.goldCountLabel = self.childNode(withName: "//goldCountLabel") as? SKLabelNode
        self.usernameLabel = self.childNode(withName: "//usernameLabel") as? SKLabelNode
        let labelArray = [metalCountLabel, goldCountLabel]
        
    }
    func touchDown(atPoint pos : CGPoint) {
        
        
//        // Sets up alert
//        let alert = UIAlertController(title: "Input Username", message: "do it", preferredStyle: UIAlertController.Style.alert)
//        alert.addTextField()
//
//        // Sets up alert action
//        let action = UIAlertAction(title: "Ok", style: .default) { action in
//            // Handle when button is clicked
//            self.playerVars.username = alert.textFields![0].text!
//            self.usernameLabel?.text = self.playerVars.username
//        }
//        alert.addAction(action)
//
//        // Runs alert
//        if let vc = self.scene?.view?.window?.rootViewController {
//            vc.present(alert, animated: true, completion: nil)
//        }
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
        metalCountLabel?.text = "Metal: " + String(playerVars.gameResources[0].resourceQuantity)
        goldCountLabel?.text = "Gold: " + String(playerVars.gameResources[1].resourceQuantity)
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
    
    func setContentView(tempContentView: ContentView){
        contentView = tempContentView
    }
    
    
    // =========================================================================================
    // Cloud Data code
    
    // Cloud data containers
    let publicDatabase = CKContainer(identifier: "iCloud.stratagem").publicCloudDatabase;
    let privateDatabase = CKContainer(identifier: "iCloud.stratagem").privateCloudDatabase;

    
    // Eventually will direct data func flow
    func dataPull(){
        setInitialUserData()
    }
    

    
    
    // Called at the begening of app load, will read preset user data
    func setInitialUserData() {
        // Cloud data serach parameters
        // This sets the predicate to only show results that exist (hence true)
        let pred = NSPredicate(value: true)
        
        // Sets up descriptor to arrange the data
        let sort = NSSortDescriptor(key: "testIndex", ascending: true)
        
        // Defines the container to pull from using pred restrictions
        let query = CKQuery(recordType: "PermanentUserData", predicate: pred)
        
        // Sets up a sorter to sort through the data
        query.sortDescriptors = [sort]

        // Pulls data from container
        let operation = CKQueryOperation(query: query)
        
        // Sets up a few more restrictions on which data will be pulled
        operation.desiredKeys = ["username"]

        // Records pulled data into local data
        operation.recordFetchedBlock = { record in
            if record.isEqual("Changed Later") {
                print("empty")
            }
            print (record.recordID)
            print (record["username"]!)
         }

        // Closes the query, alerts us if any errors
         operation.queryCompletionBlock = {(cursor, error) in
            DispatchQueue.main.async {
            if error == nil {
            } else {
                    print(error!.localizedDescription)
                }
            }
         }
        
        // Actually triggers the operation that was setup
        privateDatabase.add(operation)
        
        
        
    }
}
