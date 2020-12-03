import SpriteKit
import SKTiled

public class CityTile {
    /// Tile
    var tile: SKTile?
    var tileType: CityTileType = .GROUND
    
    /// Tile is in player modifiable spot
    var isEditable: Bool?
    
    /// Optional building on tile
    var building: CityBuilding?
    
    /// Try to init CityTile at tile, returns false if not a proper location
    func initTile(tile: SKTile, newTileData: SKTilesetData, cityTerrain: [[CityTile]]?, isEditable: Bool) -> String {
        self.tile = tile
        self.isEditable = isEditable
        return tileGetBuilding(prevTile: tile, newTileData: newTileData, cityTerrain: cityTerrain)
    }
    
    private func tileGetBuilding(prevTile: SKTile, newTileData: SKTilesetData, cityTerrain: [[CityTile]]?) -> String {
        let properties = newTileData.properties
        if properties["type"] != "ground" {
            // Tile is a building, which all have costs
            let creditsCost = properties["CREDITS"]!
            let metalCost = properties["METAL"]!
            let costs = [ResourceTypes.CREDITS: Int(creditsCost)!, ResourceTypes.METAL: Int(metalCost)!]
            
            var building: CityBuilding?
            var tileType: CityTileType?
            switch properties["type"] {
            case "road":
                tileType = .ROAD
                building = Road(cost: costs)
            case "residential":
                tileType = .RESIDENTIAL
                building = ResidentialBuilding(cost: costs, popRate: CGFloat(Double(properties["popRate"]!)!), popCap: Int(properties["popCap"]!)!)
            case "industrial":
                break
            case "military":
                break
            default:
                break
            }
            
            if let building = building {
                let message = building.satisfiesConstraints(coords: prevTile.tileCoord!, newTileData: newTileData, cityTerrain: cityTerrain!)
                if message == "true" {
                    self.building = building
                    self.tileType = tileType!
                    return "true"
                } else {
                    return message
                }
            }
        }
        return "true"
    }
}

enum CityTileType : String {
    case GROUND, ROAD, RESIDENTIAL, INDUSTRIAL, MILITARY
}

enum GroundTileType : String {
    case WATER, SAND, GRASS
}

