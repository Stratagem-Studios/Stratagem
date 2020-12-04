import SpriteKit
import SKTiled

public class ResidentialBuilding: CityBuilding {
    /// Each building contributes to the global pop rate and cap
    var popRate: CGFloat
    var popCap: Int
    
    init(cost: [ResourceTypes: CGFloat], properties: Dictionary<String, String>) {
        self.popRate = CGFloat(Double(properties["popRate"]!)!)
        self.popCap = Int(properties["popCap"]!)!
        super.init(cost: cost)
    }
    
    /// Can place a road on any grass tile next to a road tile
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
