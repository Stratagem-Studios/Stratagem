import SpriteKit
import SKTiled

public class CityBuilding {
    var costs: [ResourceTypes: CGFloat]
    
    var width = 1
    var height = 1
    
    init(cost: [ResourceTypes: CGFloat]) {
        self.costs = cost
    }
    
    // Default constraint is if there's a specific tile the building needs to be on
    func satisfiesConstraints(coords: CGPoint, newTileData: SKTilesetData, cityTerrain: [[CityTile]]) -> String {
        let x = Int(coords.x)
        let y = Int(coords.y)
        
        if let onTileStr = newTileData.properties["onTile"] {
            let currentTileName = cityTerrain[x][y].tile!.tileData.properties["name"]!
            
            let onTileArr = onTileStr.trimmingCharacters(in: CharacterSet(charactersIn: "[]")).components(separatedBy:", ")
            
            for onTile in onTileArr {
                if onTile == currentTileName {
                    return "true"
                }
            }
            
            return "Can't place on \(currentTileName)"
        }
        return "true"
    }
    
    func update(_ currentTime: TimeInterval) {}
    
    /// Displays whenever the user taps on the building
    func customSKNode() -> SKNode? {
        return nil
    }
}
