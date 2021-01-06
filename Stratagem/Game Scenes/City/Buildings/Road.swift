import SpriteKit
import SKTiled

public class Road: CityBuilding {
    /// Stores the gid of the road on this tile
    var globalID: Int = 91
    
    init(cost: [ResourceTypes: CGFloat], properties: Dictionary<String, String>) {
        super.init(cost: cost)
    }
    
    /// Should be called whenever a road tile is destroyed/built
    func updateRoadGID(city: City, currentCoords: CGPoint) {
        // Check for road tiles adjacent to current road tile
        let coordUpperLeft = CGPoint(x: currentCoords.x - 1, y: currentCoords.y)
        let coordUpperRight = CGPoint(x: currentCoords.x, y: currentCoords.y - 1)
        let coordLowerRight = CGPoint(x: currentCoords.x + 1, y: currentCoords.y)
        let coordLowerLeft = CGPoint(x: currentCoords.x, y: currentCoords.y + 1)
        let coordsAdjacent = [coordUpperLeft, coordUpperRight, coordLowerRight, coordLowerLeft]
        
        var newRoadTileName = "roadtile"
        for coordAdjacent in coordsAdjacent {
            if city.cityTerrain[Int(coordAdjacent.x)][Int(coordAdjacent.y)].building is Road {
                newRoadTileName.append("1")
            } else {
                newRoadTileName.append("0")
            }
        }
        
        // Get the GID of the new road tile
        globalID = city.tilemap.getTileData(named: newRoadTileName).first!.globalID
    }
    
    /// Can place a road on any grass tile next to a road tile
    override func satisfiesConstraints(coords: CGPoint, newTileData: SKTilesetData, cityTerrain: [[CityTile]]) -> String {
        // Check for appropriate tile
        let message = super.satisfiesConstraints(coords: coords, newTileData: newTileData, cityTerrain: cityTerrain)
        if message == "true" {
            return "true"
        } else {
            // Allow if it's on a road tile
            if cityTerrain[Int(coords.x)][Int(coords.y)].building is Road {
                return "true"
            } else {
                return message
            }
        }
    }
}
