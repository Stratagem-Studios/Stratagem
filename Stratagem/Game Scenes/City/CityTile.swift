import SpriteKit
import SKTiled

public class CityTile {
    /// Tile
    var tile: SKTile?
    
    /// Tile is in player modifiable spot
    var isEditable: Bool?
    
    /// Optional building on tile
    var building: CityBuilding?
    
    /// Try to init CityTile at tile, returns false if not a proper location
    func initTile(tile: SKTile, cityTerrain: [[CityTile]]?, isEditable: Bool) -> Bool {
        self.tile = tile
        self.isEditable = isEditable
        return tileGetBuilding(tile: tile, cityTerrain: cityTerrain)
    }
    
    private func tileGetBuilding(tile: SKTile, cityTerrain: [[CityTile]]?) -> Bool {
        let properties = tile.tileData.properties
        if properties["type"] != "ground" {
            // Tile is a building, which all have costs
            let creditsCost = properties["CREDITS"]!
            let metalCost = properties["METAL"]!
            
            var building: CityBuilding?
            switch properties["type"] {
            case "road":
                building = Road(cost: [.CREDITS: Int(creditsCost)!, .METAL: Int(metalCost)!])
            case "residential":
                break
            case "industrial":
                break
            case "military":
                break
            default:
                break
            }
            
            if let building = building {
                if building.satisfiesConstraints(cityTerrain: cityTerrain!) {
                    self.building = building
                    return true
                } else {
                    return false
                }
            }
        }
        return true
    }
}

enum CityTileType : String {
    case GROUND, BUILDING
}

enum GroundTileType : String {
    case WATER, SAND, GRASS
}

