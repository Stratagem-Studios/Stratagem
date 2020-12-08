import SpriteKit
import Foundation
import SwiftUI

// Scene consists of a right panel, a left panel, and top hud
class GalaxyScene: SKScene {
    private var galaxy = Global.gameVars!.galaxy
    private let screenSize = Global.gameVars?.screenSize
    var lineNodes: [SKNode] = []
    var selectedPlanet: SKSpriteNode?
    var selectedPlanetColor: SKColor?
    
    // Holds the top, right and left panels in that order
    var panelNodes: [SKSpriteNode] = [
        SKSpriteNode(color: UIColor.clear, size: CGSize(width: Global.gameVars!.screenSize.width, height: 65)),
        SKSpriteNode(color: UIColor.clear, size: CGSize(width: Global.gameVars!.screenSize.width*2/5, height: Global.gameVars!.screenSize.height - 65)),
        SKSpriteNode(color: UIColor.clear, size: CGSize(width: Global.gameVars!.screenSize.width*3/5, height: Global.gameVars!.screenSize.height - 65))
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
        childNode(withName: "panel1")?.position = CGPoint(x: screenSize!.width*3/5, y: screenSize!.height - 65)
        childNode(withName: "panel2")?.position = CGPoint(x: 0, y: screenSize!.height - 65)
        
        
        // Adds/organizes planet nodes
        var nodeScreenSize = panelNodes[2].size
        for i in 0..<galaxy!.planets.count{
            let planet = SKSpriteNode(imageNamed: "Planet")
            planet.colorBlendFactor = 1
            planet.color = SKColor.white
            planet.name = "planet" + String(i)
            planet.size = CGSize(width: screenSize!.height/8,height: screenSize!.height/8)
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
        let linesMaster = SKNode()
        linesMaster.name = "lineMaster"
        panelNodes[2].addChild(linesMaster)
        for i in 0..<7{
            let node = SKNode()
            
            // This section will shw all the respective lines from each planet
            switch i {
            case 0:
                node.addChild(drawLineBetween(aInt: 0, bInt: 1))
                node.addChild(drawLineBetween(aInt: 0, bInt: 2))
                node.addChild(drawLineBetween(aInt: 0, bInt: 3))
            case 1:
                node.addChild(drawLineBetween(aInt: 1, bInt: 0))
                node.addChild(drawLineBetween(aInt: 1, bInt: 2))
                node.addChild(drawLineBetween(aInt: 1, bInt: 3))
                node.addChild(drawLineBetween(aInt: 1, bInt: 4))
            case 2:
                node.addChild(drawLineBetween(aInt: 2, bInt: 0))
                node.addChild(drawLineBetween(aInt: 2, bInt: 1))
                node.addChild(drawLineBetween(aInt: 2, bInt: 3))
                node.addChild(drawLineBetween(aInt: 2, bInt: 5))
            case 3:
                node.addChild(drawLineBetween(aInt: 3, bInt: 0))
                node.addChild(drawLineBetween(aInt: 3, bInt: 1))
                node.addChild(drawLineBetween(aInt: 3, bInt: 2))
                node.addChild(drawLineBetween(aInt: 3, bInt: 4))
                node.addChild(drawLineBetween(aInt: 3, bInt: 5))
                node.addChild(drawLineBetween(aInt: 3, bInt: 6))
            case 4:
                node.addChild(drawLineBetween(aInt: 4, bInt: 1))
                node.addChild(drawLineBetween(aInt: 4, bInt: 3))
                node.addChild(drawLineBetween(aInt: 4, bInt: 5))
                node.addChild(drawLineBetween(aInt: 4, bInt: 6))
            case 5:
                node.addChild(drawLineBetween(aInt: 5, bInt: 2))
                node.addChild(drawLineBetween(aInt: 5, bInt: 3))
                node.addChild(drawLineBetween(aInt: 5, bInt: 4))
                node.addChild(drawLineBetween(aInt: 5, bInt: 6))
            case 6:
                node.addChild(drawLineBetween(aInt: 6, bInt: 3))
                node.addChild(drawLineBetween(aInt: 6, bInt: 4))
                node.addChild(drawLineBetween(aInt: 6, bInt: 5))
            default:
                print("Line attempted to be drawn between planet int that should not exist. check GalaxyScene.swift")
            }
            node.name = "lineHolder" + String(i)
            lineNodes.append(node)
        }
        
        
        // Creates the top nav bar
        nodeScreenSize = panelNodes[0].size
        let settings = SKSpriteNode(imageNamed: "Settings")
        settings.name = "settings"
        settings.size = CGSize(width:65,height:65)
        settings.anchorPoint = CGPoint(x: 1,y: 1)
        settings.position = CGPoint(x: screenSize!.width, y: 0)
        panelNodes[0].addChild(settings)
        
        
        // Sets up part of the description
        nodeScreenSize = panelNodes[1].size
        
        let descriptionPanel = SKShapeNode(rectOf: CGSize(width: nodeScreenSize.width * 4/5, height: nodeScreenSize.height*9/10), cornerRadius: 30)
        descriptionPanel.position = CGPoint(x: nodeScreenSize.width, y: nodeScreenSize.height + nodeScreenSize.height/20)
        descriptionPanel.position = CGPoint(x: nodeScreenSize.width/2,y: -nodeScreenSize.height/2)
        descriptionPanel.fillColor = SKColor.white
        descriptionPanel.strokeColor = SKColor.black
        descriptionPanel.name = "descriptionPanel"
        
        /// the enter button for visiting a planet
        let enterButton = SKShapeNode(rectOf: CGSize(width: nodeScreenSize.width * 2/3, height: nodeScreenSize.width/7), cornerRadius: 10)
        enterButton.position = CGPoint(x: 0, y: -nodeScreenSize.height/3)
        enterButton.fillColor = SKColor.gray
        enterButton.name = "enterButton"
        let enterText = SKLabelNode(fontNamed: "Montserrat-Bold")
        enterText.fontSize = screenSize!.height/18
        enterText.fontColor = SKColor.darkGray
        enterText.verticalAlignmentMode = .center
        enterText.name = "enterText"
        enterText.text = "Visit Planet"
        enterButton.addChild(enterText)
        descriptionPanel.addChild(enterButton)
        
        /// The planet, listed at the top of the description panel
        let planetName = SKLabelNode(fontNamed: "Montserrat-Bold")
        planetName.fontSize = screenSize!.height/18
        planetName.fontColor = SKColor.clear
        planetName.verticalAlignmentMode = .top
        planetName.position.y = descriptionPanel.frame.height/2 - 10
        planetName.name = "planetName"
        planetName.text = "Planet"
        descriptionPanel.addChild(planetName)
        
        panelNodes[1].addChild(descriptionPanel)
    }
    
    // creates the line between planets
    func drawLineBetween(aInt: Int, bInt: Int) -> SKShapeNode{
        // just to make our vars more clear
        let a = planetNodes[aInt]; let b = planetNodes[bInt]
        
        // The path and shape for new line
        let newLine = SKShapeNode(); let drawPath = CGMutablePath()
        
        drawPath.move(to: a.position)
        drawPath.addLine(to: b.position)
        newLine.path = drawPath
        newLine.strokeColor = SKColor.white
        return newLine
    }
    
    func selectPlanet (planetInt: Int){
        if selectedPlanet == nil {
            (panelNodes[1].childNode(withName: "descriptionPanel")?.childNode(withName: "enterButton")?.childNode(withName: "enterText") as! SKLabelNode).fontColor = SKColor.yellow
            (panelNodes[1].childNode(withName: "descriptionPanel")!.childNode(withName: "enterButton") as! SKShapeNode).fillColor = SKColor.black
            (panelNodes[1].childNode(withName: "descriptionPanel")?.childNode(withName: "planetName") as! SKLabelNode).fontColor = SKColor.systemGreen
        } else {
            selectedPlanet?.color = SKColor.white
        }
        selectedPlanet = planetNodes[planetInt]
        selectedPlanet!.color = SKColor.yellow
        panelNodes[2].childNode(withName: "lineMaster")?.removeAllChildren()
        panelNodes[2].childNode(withName: "lineMaster")?.addChild(lineNodes[planetInt])
        (panelNodes[1].childNode(withName: "descriptionPanel")?.childNode(withName: "planetName") as! SKLabelNode).text = Global.gameVars.galaxy.planets[planetInt].planetName
        Global.gameVars.selectedPlanet = Global.gameVars.galaxy.planets[planetInt]
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // We only care about the first touch
        let node = self.atPoint(touches.first!.location(in: self))
        for i in 0..<planetNodes.count{
            if "planet" + String(i) == node.name {
                let planet = Global.gameVars.galaxy.planets[i]
                
                // If there are no cities generated for the planet, we need to make at least one - this code should be removed later
                if (planet.cities.isEmpty){planet.generateNewCity(cityName: "e")}
                
                selectPlanet(planetInt: i)
            } else if node.name == "settings" {
                /// add settings panel here
            } else if node.name == "enterButton" || node.name == "enterText" {
                Global.playerManager.playerVariables.currentGameViewLevel = .PLANET
            }
        }
    }
}

