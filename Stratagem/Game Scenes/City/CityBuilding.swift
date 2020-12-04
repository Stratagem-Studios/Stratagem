import SpriteKit
import SKTiled

public class CityBuilding {
    var costs: [ResourceTypes: CGFloat]
    
    var width = 1
    var height = 1
    
    init(cost: [ResourceTypes: CGFloat]) {
        self.costs = cost
    }
    
    func satisfiesConstraints(coords: CGPoint, newTileData: SKTilesetData, cityTerrain: [[CityTile]]) -> String {
        return "true"
    }
    
    func update(_ currentTime: TimeInterval) {}
}
