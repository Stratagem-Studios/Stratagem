import SpriteKit
import SKTiled

public class CityBuilding {
    var cost: [ResourceTypes: Int]
    
    var width = 1
    var height = 1
    
    init(cost: [ResourceTypes: Int]) {
        self.cost = cost
    }
    
    func satisfiesConstraints() -> Bool {
        return true
    }
    
}
