import SpriteKit
import SKTiled

public class CityTile {
    /// Tile
    var tile: SKTile?
    
    /// Tile is in player modifyable spot
    var isEditable: Bool?
    
    /// Optional building on tile
    var building: CityBuilding?
    
    public func initTile(tile: SKTile, isEditable: Bool) {
        self.tile = tile
        self.isEditable = false
        tileCreateBuilding()
    }
    
    private func tileCreateBuilding() {
        
    }
}
