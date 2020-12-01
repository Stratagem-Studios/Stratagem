import SpriteKit
import Foundation
import SwiftUI

// Scene consists of a right panel, a left panel, and top hud
class GalaxyScene: SKScene {
    private var galaxy = Global.gameVars!.galaxy
    private let screenSize = Global.gameVars?.screenSize
    
    // Holds the top, right and left panels in that order
    var panelNodes: [SKSpriteNode] = [
        SKSpriteNode(color: UIColor.blue, size: CGSize(width: Global.gameVars!.screenSize.width, height: 65)),
        SKSpriteNode(color: UIColor.red, size: CGSize(width: Global.gameVars!.screenSize.width/3, height: Global.gameVars!.screenSize.height - 65)),
        SKSpriteNode(color: UIColor.clear, size: CGSize(width: Global.gameVars!.screenSize.width*2/3, height: Global.gameVars!.screenSize.height - 65))
    ]
    
    // accepts the index of the planet and returns a relative position. only temp
    // .1 = x  .2 = y
    let indexToPos: [CGFloat : CGFloat] = [
        0.1 : 0.15, 0.2 : 0.5,
        1.1 : 0.3, 1.2 : 0.75,
        2.1 : 0.3, 2.2 : 0.25,
        3.1 : 0.5, 3.2 : 0.5,
        4.1 : 0.7, 4.2 : 0.75,
        5.1 : 0.7, 5.2 : 0.25,
        6.1 : 0.85, 6.2 : 0.5,
    ]
    // Planet positioning
    /*
        1     4
     0     3     6
        2     5
    */
    
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
            planet.size = CGSize(width: screenSize!.height/9,height: screenSize!.height/9)
            panelNodes[2].addChild(planet)
            planetNodes.append(planet)
            panelNodes[2].childNode(withName: "planet" + String(i))!.position = CGPoint(
                x: indexToPos[CGFloat(i) + 0.1]! * nodeScreenSize.width,
                y: -indexToPos[CGFloat(i) + 0.2]! * nodeScreenSize.height)
        }
        /// for now all the planet locs are static
        for node in panelNodes[2].children {
            galaxy?.planetLocs.append(node.position)
        }
        
        // Adds/organizes lines
        drawLineBetween(aInt: 1, bInt: 2)
                
        // Creates the top nav bar
        let settings = SKSpriteNode(imageNamed: "Settings")
        settings.name = "settings"
        settings.size = CGSize(width:65,height:65)
        settings.anchorPoint = CGPoint(x: 1,y: 1)
        settings.position = CGPoint(x: screenSize!.width, y: 0)
        panelNodes[0].addChild(settings)
        
    }
    
    // creates the line between planets
    func drawLineBetween(aInt: Int, bInt: Int){
        // just to make our vars more clear
        let a = planetNodes[aInt]; let b = planetNodes[bInt]
        
        // The path and shape for new line
        let newLine = SKShapeNode(); let drawPath = CGMutablePath()
        
        drawPath.move(to: a.position)
        drawPath.addLine(to: b.position)
        newLine.path = drawPath
        newLine.strokeColor = SKColor.white
        panelNodes[2].addChild(newLine)
    }
    
    func selectPlanet (planetInt: Int){
        let planetNode = planetNodes[planetInt]
        planetNode.color = SKColor.yellow
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // We only care about the first touch
        let node = self.atPoint(touches.first!.location(in: self))
        print(planetNodes)
        for i in 0..<planetNodes.count{
            if "planet" + String(i) == node.name {
                let planet = Global.gameVars.galaxy.planets[i]

                
                // If there are no cities generated for the planet, we need to make at least one - this code should be removed later
                if (planet.cities.isEmpty){planet.generateNewCity(cityName: "e")}
                
                Global.gameVars.selectedPlanet = planet
                Global.playerManager.playerVariables.currentGameViewLevel = .PLANET
            } else if node.name == "settings" {
                
            }
        }
    }
}

