import SpriteKit
import SKTiled

public class CityTile {
    /// Tile
    var tile: SKTile?
    
    /// Tile is in player modifiable spot
    var isEditable: Bool?
    
    /// Optional building on tile
    var building: CityBuilding?
    
    func initTile(tile: SKTile, isEditable: Bool) {
        self.tile = tile
        self.isEditable = false
        tileCreateBuilding()
    }
    
    private func tileCreateBuilding() {
        
    }
}
