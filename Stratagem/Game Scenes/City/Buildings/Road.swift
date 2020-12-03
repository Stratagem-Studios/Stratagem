import SpriteKit
import SKTiled

public class Road: CityBuilding {
    
    /// Can place a road on any grass tile
    override func satisfiesConstraints(coords: CGPoint, newTileData: SKTilesetData, cityTerrain: [[CityTile]]) -> String {
        if cityTerrain[Int(coords.x)][Int(coords.y)].tile!.tileData.properties["name"] == "grass" {
            return "true"
        }
        
        return "false"
    }
}
