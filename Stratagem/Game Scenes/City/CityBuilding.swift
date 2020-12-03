import SpriteKit
import SKTiled

public class CityBuilding {
    var costs: [ResourceTypes: Int]
    
    var width = 1
    var height = 1
    
    init(cost: [ResourceTypes: Int]) {
        self.costs = cost
    }
    
    func satisfiesConstraints(cityTerrain: [[CityTile]]) -> Bool {
        return true
    }
}
