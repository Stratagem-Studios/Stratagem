import SpriteKit
import SKTiled

/// Industrial buildings can produce and consume materials
public class IndustrialBuilding: CityBuilding {
    // If building is disabled, don't consume/produce
    var enabled = true
    
    // resources used / sec
    var consumes: [ResourceTypes: CGFloat]
    var produces: [ResourceTypes: CGFloat]
    
    init(cost: [ResourceTypes: CGFloat], properties: Dictionary<String, String>) {
        var consumes: [ResourceTypes: CGFloat] = [:]
        var produces: [ResourceTypes: CGFloat] = [:]
        ResourceTypes.allCases.forEach {
            if let consumesValue = properties["CONSUMES " + $0.rawValue] {
                consumes[$0] = CGFloat(Float(consumesValue)!)
            }
            
            if let producesValue = properties["PRODUCES " + $0.rawValue] {
                produces[$0] = CGFloat(Float(producesValue)!)
            }
        }
        self.consumes = consumes
        self.produces = produces
        
        super.init(cost: cost)
    }
    
    /// Can place a building next to a road and check restriction
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
}
