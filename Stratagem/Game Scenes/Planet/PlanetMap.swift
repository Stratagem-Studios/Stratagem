import Foundation
import SceneKit
import SpriteKit

// thses two enums used to easily spawn units
enum UnitAffiliation {
    case ALLIED, NEUTRAL, ENEMY
}

class PlanetMap: SKScene {
    
    var prevCityHash: Int? = nil
    let map = SKSpriteNode(imageNamed: "PlanetMap" + String(Int.random(0...2)))
    let citiesNode = SKNode()
    let lineMaster = SKNode()
    
    override func sceneDidLoad() {
        // sets the map and scene to line up with the sphere properly
        map.size = self.size
        map.zRotation = 0
        self.anchorPoint = CGPoint(x: 0,y: 0)
        map.anchorPoint = CGPoint(x: 0,y: 0)
        addChild(map)
        map.addChild(lineMaster)
        map.addChild(citiesNode)
    }
    
    func generateCitySprite(loc: CGPoint) -> CGRect {
        let city = SKSpriteNode(imageNamed: "NeutralCity")
        city.name = String(loc.hashValue)
        citiesNode.addChild(city)
        city.position = loc
        city.color = UIColor.white
        city.colorBlendFactor = 0.7
        let frame = city.frame
        return CGRect(x: frame.minX/1000,
                      y: frame.minY/1000,
                      width: frame.width/1000,
                      height: frame.height/1000)
    }
    
    /// called when the sphere is loaded. ensures that cities show up with the right owner
    func updateCitySprite(){
        for i in 0..<(Global.gameVars.selectedPlanet!.cities.count) {
            if Global.gameVars.selectedPlanet?.cities[i].owner == Global.playerVariables.playerName{
                let child = (citiesNode.children[i] as! SKSpriteNode)
                child.color = UIColor.blue
            }
        }
    }
    
    func selectCitySprite(loc: CGPoint) {
        if prevCityHash != nil {
            let child = (citiesNode.childNode(withName: String(prevCityHash!)) as! SKSpriteNode)
            child.texture = SKTexture(imageNamed: "NeutralCity")
            child.colorBlendFactor = 0.7
            
        }
        let child = (citiesNode.childNode(withName: String(loc.hashValue)) as! SKSpriteNode)
        child.texture = SKTexture(imageNamed: "SelectedCity")
        child.colorBlendFactor = 0
        prevCityHash = loc.hashValue
    }
    
    func lineBetweenPoints(start: CGPoint, end: CGPoint) {
        lineMaster.removeAllChildren()
        let newLine = SKShapeNode(); let drawPath = CGMutablePath()
        drawPath.move(to: start)
        drawPath.addLine(to: end)
        newLine.path = drawPath
        newLine.strokeColor = SKColor.white
        lineMaster.addChild(newLine)
    }
    
    func generateUnitSprite(loc: CGPoint) -> SKSpriteNode{
        let unit = SKSpriteNode(imageNamed: "Groups")
        unit.zPosition = 100
        unit.size = CGSize(width: 25, height: 30)
        unit.name = "Transfer"
        map.addChild(unit)
        return unit
    }
    
}
