import SpriteKit
import SKTiled

/// User selects units and military building creates them
public class MilitaryBuilding: CityBuilding {
    var unitCreationQueue: [Units] = []
    var currentBuildTime: CGFloat = 0
    var currentlyBuildingUnit: Units?
    
    init(cost: [ResourceTypes: CGFloat], properties: Dictionary<String, String>) {
        super.init(cost: cost)
        
        let unit = Units()
        unit.unitType = .BRAWLER
        unitCreationQueue.append(unit)
        let unit2 = Units()
        unit2.unitType = .SNIPER
        unitCreationQueue.append(unit2)
    }
    
    func update(_ deltaTime: CGFloat) -> Units? {
        var newUnit: Units?
        if let currentlyBuildingUnit = currentlyBuildingUnit {
            currentBuildTime += deltaTime
            
            // Finished building unit
            if currentBuildTime >= currentlyBuildingUnit.buildTime {
                newUnit = currentlyBuildingUnit
                
                currentBuildTime = 0
                if unitCreationQueue.count > 0 {
                    self.currentlyBuildingUnit = unitCreationQueue.removeFirst()
                } else {
                    self.currentlyBuildingUnit = nil
                }
            }
        } else {
            if unitCreationQueue.count > 0 {
                currentlyBuildingUnit = unitCreationQueue.removeFirst()
            } else {
                currentlyBuildingUnit = nil
            }
        }

        return newUnit
    }
    
    /// Can place a road on any military tile next to a road tile
    override func satisfiesConstraints(coords: CGPoint, newTileData: SKTilesetData, cityTerrain: [[CityTile]]) -> String {
        // Check for appropriate tile
        let message = super.satisfiesConstraints(coords: coords, newTileData: newTileData, cityTerrain: cityTerrain)
        if message != "true" {
            return message
        }
        
        let x = Int(coords.x)
        let y = Int(coords.y)
        if cityTerrain[x + 1][y].building is Road || cityTerrain[x - 1][y].building is Road || cityTerrain[x][y + 1].building is Road || cityTerrain[x][y - 1].building is Road {
            return "true"
        } else {
            return "Must place building adjacent to a road"
        }
    }
    
    /// Displays whenever the user taps on the building
    override func customSKNodeLarge(size: CGSize) -> SKNode? {
        let customSKNode = SKNode()
        
        let popupBackgroundNode = SKShapeNode(rect: CGRect(center: CGPoint(x: 0, y: 0), size: CGSize(width: 600, height: 300)), cornerRadius: 10)
        popupBackgroundNode.name = "popLabelBackground"
        popupBackgroundNode.fillColor = .black
        popupBackgroundNode.alpha = 0.5
        popupBackgroundNode.position = CGPoint(x: 0, y: 0)
        popupBackgroundNode.zPosition = 10000
        customSKNode.addChild(popupBackgroundNode)

        /// The yPos the next node should be set at
        var yPos = popupBackgroundNode.frame.height / 2 - 30
        let titleLabelNode = SKLabelNode(fontNamed: "Montserrat-Bold")
        titleLabelNode.zPosition = 100000
        titleLabelNode.text = "Build units"
        titleLabelNode.fontSize = 20
        titleLabelNode.position = CGPoint(x: 0, y: yPos)
        customSKNode.addChild(titleLabelNode)
        
        // Left side is current queue
        yPos -= 15
        let queueTitleLabelNode = SKLabelNode(fontNamed: "Montserrat-Bold")
        queueTitleLabelNode.zPosition = 100000
        queueTitleLabelNode.text = "Queue"
        queueTitleLabelNode.fontSize = 20
        queueTitleLabelNode.position = CGPoint(x: -200, y: yPos)
        customSKNode.addChild(queueTitleLabelNode)
        
        yPos -= 15
        // Currently building
        if let currentlyBuildingUnit = currentlyBuildingUnit {
            yPos -= 15
            let unitQueueLabelNode = SKLabelNode(fontNamed: "Montserrat-Bold")
            unitQueueLabelNode.zPosition = 100000
            unitQueueLabelNode.text = currentlyBuildingUnit.unitType!.rawValue + ": \(Int(currentlyBuildingUnit.buildTime - currentBuildTime))"
            unitQueueLabelNode.fontSize = 14
            unitQueueLabelNode.position = CGPoint(x: -200, y: yPos)
            customSKNode.addChild(unitQueueLabelNode)
        }
        
        // In queue
        for unit in unitCreationQueue {
            yPos -= 15
            
            let unitQueueLabelNode = SKLabelNode(fontNamed: "Montserrat-Bold")
            unitQueueLabelNode.zPosition = 100000
            unitQueueLabelNode.text = unit.unitType?.rawValue
            unitQueueLabelNode.fontSize = 14
            unitQueueLabelNode.position = CGPoint(x: -200, y: yPos)
            customSKNode.addChild(unitQueueLabelNode)
        }
        
        // Middle is unit selection
        yPos = popupBackgroundNode.frame.height / 2 - 30
        yPos -= 15
        UnitType.allCases.forEach {
            yPos -= 60
            let texture = SKTexture(imageNamed: "\($0.rawValue.capitalized)Icon")
            let sprite = SKSpriteNode(texture: texture, size: CGSize(width: 50, height: 50))
            sprite.zPosition = 100000
            sprite.name = "BUTTON_BUILDING_POPUP \($0.rawValue)"
            sprite.position = CGPoint(x: 0, y: yPos)
            customSKNode.addChild(sprite)
        }
        
        // Right is unit info
        
        //currentCustomSKNode = customSKNode
        return customSKNode
    }
    
    /// Called whenever player presses on a button on custom SKNode
    override func userTouchedButton(hudNode: HudNode, button: SKNode, size: CGSize) {
        let unitNameStr = button.name!.replacingOccurrences(of: "BUTTON_BUILDING_POPUP ", with: "")
        
        if unitCreationQueue.count <= 10 {
            if let unitType = UnitType(rawValue: unitNameStr) {
                let unit = Units()
                unit.unitType = unitType
                unitCreationQueue.append(unit)
                Global.gameVars.shouldUpdateCityHudNode = true
            }
        } else {
            hudNode.inlineErrorMessage(errorMessage: "Maximum of 10 units in the queue")
        }
        
        /*
        var yPos = 121.35
        yPos -= 15
        let detailsLabelNode = SKLabelNode(fontNamed: "Montserrat-Bold")
        detailsLabelNode.zPosition = 100000
        detailsLabelNode.text = "Details"
        detailsLabelNode.fontSize = 20
        detailsLabelNode.position = CGPoint(x: 200, y: yPos)
        currentCustomSKNode.addChild(detailsLabelNode)
         */
    }
}
