import SpriteKit
import SKTiled

public class CityBuilding {
    var costs: [ResourceTypes: Int]
    
    var width = 1
    var height = 1
    
    init(cost: [ResourceTypes: Int]) {
        self.costs = cost
    }
    
    func satisfiesConstraints(coords: CGPoint, newTileData: SKTilesetData, cityTerrain: [[CityTile]]) -> String {
        return "true"
    }
    
    func update(_ currentTime: TimeInterval) {}
}
