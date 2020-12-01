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
        SKSpriteNode(color: UIColor.red, size: CGSize(width: Global.gameVars!.screenSize!.width/3, height: Global.gameVars!.screenSize!.height - 65)),
        SKSpriteNode(color: UIColor.clear, size: CGSize(width: Global.gameVars!.screenSize!.width*2/3, height: Global.gameVars!.screenSize!.height - 65))
    ]
    
    // accepts the index of the planet and returns a relative position. only temp
    // .1 = x  .2 = y
    let indexToPos: [CGFloat : CGFloat] = [
        0.1 : 0.2, 0.2 : 0.5,
        1.1 : 0.4, 1.2 : 0.75,
        2.1 : 0.4, 2.2 : 0.25,
        3.1 : 0.5, 3.2 : 0.5,
        4.1 : 0.6, 4.2 : 0.75,
        5.1 : 0.6, 5.2 : 0.25,
        6.1 : 0.8, 6.2 : 0.5,
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
        childNode(withName: "panel1")?.position = CGPoint(x: screenSize!.width*2/3, y: screenSize!.height - 65)
        childNode(withName: "panel2")?.position = CGPoint(x: 0, y: screenSize!.height - 65)
        
        // Adds/organizes planet nodes
        var nodeScreenSize = panelNodes[2].size
        for i in 0..<galaxy!.planets.count{
            let planet = SKSpriteNode(imageNamed: "Planet")
            planet.name = "planet" + String(i)
            planet.size = CGSize(width: screenSize!.width/20,height: screenSize!.width/20)
            panelNodes[2].addChild(planet)
            panelNodes[2].childNode(withName: "planet" + String(i))!.position = CGPoint(
                x: indexToPos[CGFloat(i) + 0.1]! * nodeScreenSize.width,
                y: -indexToPos[CGFloat(i) + 0.2]! * nodeScreenSize.height)
        }
        /// for now all the planet locs are static
        for node in panelNodes[2].children {
            galaxy?.planetLocs.append(node.position)
        }
        
        // Adds/organizes lines
        
        // Creates the top nav bar
        let settings = SKSpriteNode(imageNamed: "Settings")
        settings.size = CGSize(width:65,height:65)
        settings.anchorPoint = CGPoint(x: 1,y: 1)
        settings.position = CGPoint(x: screenSize!.width, y: 0)
        panelNodes[0].addChild(settings)
        
    }
    
    
}

