//
//  GameScene.swift
//  Stratagem
//
//  Created by 90306997 on 10/20/20.
//

import SpriteKit
import GameplayKit
import UIKit
import CloudKit

class GameScene: SKScene {

    // These vars will be used to refrence labels
    var metalCount: SKLabelNode?
    var goldCount: SKLabelNode?
    
    // This var keeps track of the most recent frame's time
    private var lastUpdateTime : TimeInterval = 0
    
    // PlayerVars instantiates the Variables class which holds the variables
    // Materials follow this pattern
    // [enum, cooldownMax, timerLive, actual count]
    var playerVars = GameVariables()
    
    // Runs when scene loaded, used to init things
    override func sceneDidLoad() {
        
        // Sets up initial user data
        dataPull()
        
        // Sets label vars to respective labels and puts them in an array
        self.metalCount = self.childNode(withName: "//" + "metalCountLabel") as? SKLabelNode
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
    
    
    
    
    
    // Cloud Data function
    
    // Eventually will direct data func flow
    func dataPull(){
        setInitialUserData()
    }
    
    // Called at the begening of app load, will read preset user data
    func setInitialUserData() {
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
        operation.resultsLimit = 50

        // Records pulled data into local data
        operation.recordFetchedBlock = { record in
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
        
        // Actually triggers the operation we have setup
        CKContainer(identifier: "iCloud.stratagem").publicCloudDatabase.add(operation)
        
    }
    
}



