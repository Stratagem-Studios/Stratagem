import SpriteKit
import Foundation
import SwiftUI

// Scene consists of a right panel, a left panel, and top hud
class GalaxyScene: SKScene {
    private var galaxy = Global.gameVars!.galaxy
    private let screenSize = Global.gameVars?.screenSize
    
    // Holds the top, right and left panels in that order
    var panelNodes: [SKSpriteNode] = [
        SKSpriteNode(color: UIColor.blue, size: CGSize(width: Global.gameVars!.screenSize!.width, height: 65)),
        SKSpriteNode(color: UIColor.red, size: CGSize(width: Global.gameVars!.screenSize!.width/3, height: Global.gameVars!.screenSize!.height*17/20)),
        SKSpriteNode(color: UIColor.green, size: CGSize(width: Global.gameVars!.screenSize!.width*2/3, height: Global.gameVars!.screenSize!.height*17/20))
    ]
    
    var planetNodes: [SKSpriteNode] = []
    
    
    // All the nodes that will be used
    let planetTemplate = SKSpriteNode(imageNamed: "Planet")
    
    override func sceneDidLoad() {
        // The panels for organization, these can be left hardcoded
        for i in 0..<panelNodes.count {
            panelNodes[i].anchorPoint = CGPoint(x:0,y:1)
            panelNodes[i].name = "panel" + String(i)
            addChild(panelNodes[i])
        }
        childNode(withName: "panel0")?.position = CGPoint(x: 0, y: screenSize!.height)
        childNode(withName: "panel1")?.position = CGPoint(x: 0, y: screenSize!.height)
        childNode(withName: "panel2")?.position = CGPoint(x: 0, y: screenSize!.height)
        
        for i in 0..<galaxy!.planets.count{
            let planet = SKSpriteNode()
            planet.name = "planet" + String(i)
            planetNodes.append(planet)
            panelNodes[2].addChild(planet)
        }
    }
    
    
}

