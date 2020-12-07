import Foundation
import SceneKit
import SpriteKit

// thses two enums used to easily spawn units
enum UnitAffiliation {
    case ALLIED, NEUTRAL, ENEMY
    
}

class PlanetMap: SKScene {
    let map = SKSpriteNode(imageNamed: "BasicMap")
    
    override func sceneDidLoad() {
        // sets the map and scene to line up with the sphere properly
        map.size = self.size
        self.anchorPoint = CGPoint(x: 0,y: 0)
        map.anchorPoint = CGPoint(x: 0,y: 0)
        addChild(map)
    }
    
    func generateCitySprite(loc: CGPoint) {
        let city = SKSpriteNode(imageNamed: "NeutralCity")
        map.addChild(city)
        city.position = loc
    }
    
    func generateUnitSprite(unitType: UnitType, unitAffiliation: UnitAffiliation){
        
    }
    
}
