import SpriteKit
import SKTiled

/// User selects units and military building creates them
public class MilitaryBuilding: CityBuilding {
    var unitCreationQueue = Queue<blah unit>()
    
    init(cost: [ResourceTypes: CGFloat], properties: Dictionary<String, String>) {
        super.init(cost: cost)
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
    
    override func update(_ deltaTime: CGFloat) {
        <#code#>
    }
    
    /// Displays whenever the user taps on the building
    override func customSKNode() -> SKNode? {
        let customSKNode = SKNode()
        return SKLabelNode(text: "fjasldfjl;asdjf ;lsadjfl;ksadjf")
    }
}
