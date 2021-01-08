import SpriteKit
import Foundation
import SwiftUI

// Scene consists of a right panel, a left panel, and top hud
class GalaxyScene: SKScene {
    private var galaxy = Global.gameVars!.galaxy
    private let screenSize = Global.gameVars?.screenSize
    var lineNodes: [SKNode] = []
    var selectedPlanet: SKSpriteNode?
    var selectedPlanetInt = 0
    let targetPlanetSprite = SKSpriteNode(imageNamed: "PlanetTarget")
    let spaceshipNodes = SKNode()
    var hasSelectedSpaceship = false
    var transferUnitNodes: [SKLabelNode]?
    var selectedSpaceshipInt = 0
    var unitsToTransfer: [UnitType : Int] = [.SNIPER:0, .FIGHTER:0, .BRAWLER:0]
    let panelSize = CGSize(width: Global.gameVars!.screenSize.width*3/5, height: Global.gameVars!.screenSize.height - 65)
    let inlineErrorLabelNode = SKLabelNode(fontNamed: "Montserrat-Bold")
    var borderRectNode = SKShapeNode(rect: CGRect(center: CGPoint(x: UIScreen.main.bounds.size.halfWidth, y: UIScreen.main.bounds.size.halfHeight), size: UIScreen.main.bounds.size))
    let transferPanel = SKShapeNode(rectOf: CGSize(width: Global.gameVars!.screenSize.width*2/5 * 4/5, height: (Global.gameVars!.screenSize.height - 65)*9/10), cornerRadius: 30)
    let selectUnitsPanel = SKShapeNode(rectOf: CGSize(width: Global.gameVars!.screenSize.width*2/5 * 4/5, height: (Global.gameVars!.screenSize.height - 65)*9/10), cornerRadius: 30)
    
    // Holds the top, right and left panels in that order
    var panelNodes: [SKSpriteNode] = [
        SKSpriteNode(color: UIColor.clear, size: CGSize(width: Global.gameVars!.screenSize.width, height: 65)),
        SKSpriteNode(color: UIColor.clear, size: CGSize(width: Global.gameVars!.screenSize.width*2/5, height: Global.gameVars!.screenSize.height - 65)),
        SKSpriteNode(color: UIColor.clear, size: CGSize(width: Global.gameVars!.screenSize.width*3/5, height: Global.gameVars!.screenSize.height - 65))
    ]
    
    private let brawlerLabelNode = SKLabelNode(fontNamed: "Montserrat-Bold")
    private let sniperLabelNode = SKLabelNode(fontNamed: "Montserrat-Bold")
    private let fighterLabelNode = SKLabelNode(fontNamed: "Montserrat-Bold")
    
    // accepts the index of the planet and returns a relative position
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
     ...1     4
     0     3     6
     ...2     5
     */
    
    // All the nodes that will be used
    var planetNodes: [SKSpriteNode] = []
    
    override func sceneDidLoad() {
        
        targetPlanetSprite.size = CGSize(width: 130,height: 130)
        targetPlanetSprite.position = CGPoint(x: -500, y: 500)
        addChild(borderRectNode)
        
        // The panels for organization, these can be left hardcoded
        for i in 0..<panelNodes.count {
            panelNodes[i].anchorPoint = CGPoint(x:0,y:1)
            panelNodes[i].name = "panel" + String(i)
            addChild(panelNodes[i])
        }
        childNode(withName: "panel0")?.position = CGPoint(x: 0, y: screenSize!.height)
        childNode(withName: "panel1")?.position = CGPoint(x: screenSize!.width*3/5, y: screenSize!.height - 65)
        childNode(withName: "panel2")?.position = CGPoint(x: 0, y: screenSize!.height - 65)
        
        // Sets up border node
        borderRectNode.name = "borderRectNode"
        borderRectNode.zPosition = -1
        borderRectNode.fillColor = .clear
        borderRectNode.strokeColor = .clear
        borderRectNode.alpha = 0.5
        borderRectNode.glowWidth = 5
        borderRectNode.lineWidth = 3
        borderRectNode.isUserInteractionEnabled = false
        
        // Sets up the error node
        inlineErrorLabelNode.zPosition = 100000 + 1
        inlineErrorLabelNode.fontSize = 15
        inlineErrorLabelNode.position = CGPoint(x: UIScreen.main.bounds.size.halfWidth, y: UIScreen.main.bounds.size.halfHeight)
        inlineErrorLabelNode.alpha = 0
        addChild(inlineErrorLabelNode)
        
        // Adds/organizes planet nodes
        var nodeScreenSize = panelNodes[2].size
        for i in 0..<galaxy!.planets.count{
            var planetSpriteString = ""
            switch galaxy!.planets[i].owner {
            case "***NIL***":
                planetSpriteString = "NeutralPlanet"
            case Global.playerVariables.playerName:
                planetSpriteString = "AlliedPlanet"
            default:
                planetSpriteString = "EnemyPlanet"
            }
            
            let planet = SKSpriteNode(imageNamed: planetSpriteString)
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
        
        // Adds any possible spaceship sprites to the scene
        for transfer in galaxy!.planetTransfers {
            transfer.unitSprite.removeFromParent()
            panelNodes[2].addChild(transfer.unitSprite)
        }
        
        // Adds/organizes lines
        let linesMaster = SKNode()
        linesMaster.zPosition = -1
        linesMaster.name = "lineMaster"
        panelNodes[2].addChild(linesMaster)
        for i in 0..<7{
            let node = SKNode()
            let a = getConnectedPlanetInts(i: i)
            for z in a {
                node.addChild(drawLineBetween(aInt: i, bInt: z))
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
        panelNodes[0].addChild(spaceshipNodes)
        
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
        enterText.fontSize = screenSize!.width/40
        enterText.fontColor = SKColor.darkGray
        enterText.verticalAlignmentMode = .center
        enterText.name = "enterText"
        enterText.text = "Visit Planet"
        enterText.isUserInteractionEnabled = false
        enterButton.addChild(enterText)
        descriptionPanel.addChild(enterButton)
        
        /// The planet, listed at the top of the description panel
        let planetName = SKLabelNode(fontNamed: "Montserrat-Bold")
        planetName.fontSize = screenSize!.width/40
        planetName.fontColor = SKColor.clear
        planetName.verticalAlignmentMode = .top
        planetName.position.y = descriptionPanel.frame.height/2 - 10
        planetName.name = "planetName"
        planetName.text = "Planet"
        descriptionPanel.addChild(planetName)
        
        panelNodes[1].addChild(descriptionPanel)
        
        // Sets up the planet transfer button
        transferPanel.position = CGPoint(x: nodeScreenSize.width, y: nodeScreenSize.height + nodeScreenSize.height/20)
        transferPanel.position = CGPoint(x: nodeScreenSize.width/2,y: -nodeScreenSize.height/2)
        transferPanel.zPosition = -10
        transferPanel.fillColor = SKColor.white
        transferPanel.strokeColor = SKColor.black
        transferPanel.name = "transferPanel"
        panelNodes[1].addChild(transferPanel)
        
        /// the button to initiate a transfer
        let startTransferButton = SKShapeNode(rectOf: CGSize(width: nodeScreenSize.width * 2/3, height: nodeScreenSize.width/7), cornerRadius: 10)
        startTransferButton.position = CGPoint(x: 0, y: -nodeScreenSize.height/3)
        startTransferButton.fillColor = SKColor.gray
        startTransferButton.name = "startTransferButton"
        let startTransferText = SKLabelNode(fontNamed: "Montserrat-Bold")
        startTransferText.fontSize = screenSize!.width/40
        startTransferText.fontColor = SKColor.darkGray
        startTransferText.verticalAlignmentMode = .center
        startTransferText.name = "startTransferText"
        startTransferText.text = "Initiate transfer"
        startTransferText.isUserInteractionEnabled = false
        startTransferButton.addChild(startTransferText)
        transferPanel.addChild(startTransferButton)
        
        let selectUnitsButton = SKShapeNode(rectOf: CGSize(width: nodeScreenSize.width * 2/3, height: nodeScreenSize.width/7), cornerRadius: 10)
        selectUnitsButton.position = CGPoint(x: 0, y: 0)
        selectUnitsButton.fillColor = SKColor.black
        selectUnitsButton.name = "selectUnitsButton"
        let selectUnitsText = SKLabelNode(fontNamed: "Montserrat-Bold")
        selectUnitsText.fontSize = screenSize!.width/40
        selectUnitsText.fontColor = SKColor.yellow
        selectUnitsText.verticalAlignmentMode = .center
        selectUnitsText.name = "selectUnitsText"
        selectUnitsText.text = "Select Units"
        selectUnitsButton.addChild(selectUnitsText)
        transferPanel.addChild(selectUnitsButton)
        
        let selectDestinationButton = SKShapeNode(rectOf: CGSize(width: nodeScreenSize.width * 2/3, height: nodeScreenSize.width/7), cornerRadius: 10)
        selectDestinationButton.position = CGPoint(x: 0, y: nodeScreenSize.height/3)
        selectDestinationButton.fillColor = SKColor.black
        selectDestinationButton.name = "selectDestinationButton"
        let selectDestinationText = SKLabelNode(fontNamed: "Montserrat-Bold")
        selectDestinationText.fontSize = screenSize!.width/40
        selectDestinationText.fontColor = SKColor.yellow
        selectDestinationText.verticalAlignmentMode = .center
        selectDestinationText.name = "selectDestinationText"
        selectDestinationText.text = "Select Destination"
        selectDestinationText.isUserInteractionEnabled = false
        selectDestinationButton.addChild(selectDestinationText)
        transferPanel.addChild(selectDestinationButton)
        
        // Sets up the transfer units button
        panelNodes[1].addChild(selectUnitsPanel)
        selectUnitsPanel.position = CGPoint(x: nodeScreenSize.width, y: nodeScreenSize.height + nodeScreenSize.height/20)
        selectUnitsPanel.position = CGPoint(x: nodeScreenSize.width/2,y: -nodeScreenSize.height/2)
        selectUnitsPanel.zPosition = -1000
        selectUnitsPanel.fillColor = SKColor.white
        selectUnitsPanel.strokeColor = SKColor.black
        
        let confirmUnitsButton = SKShapeNode(rectOf: CGSize(width: selectUnitsPanel.frame.width * 2/3, height: selectUnitsPanel.frame.height/10), cornerRadius: 30)
        confirmUnitsButton.fillColor = UIColor.black
        let confirmUnitsText = SKLabelNode(fontNamed: "Montserrat-Bold");
        confirmUnitsText.fontColor = UIColor.yellow
        confirmUnitsText.position.y = confirmUnitsButton.position.y
        confirmUnitsText.verticalAlignmentMode = .center
        confirmUnitsText.text = "Confirm"
        confirmUnitsText.fontSize = 20
        confirmUnitsText.zPosition = 50
        confirmUnitsButton.position.y = -selectUnitsPanel.frame.height*1/3
        confirmUnitsButton.addChild(confirmUnitsText)
        confirmUnitsButton.zPosition = 500
        confirmUnitsText.name = "confirmUnits"
        confirmUnitsButton.name = "confirmUnits"
        selectUnitsPanel.addChild(confirmUnitsButton)
        
        sniperLabelNode.zPosition = 100
        sniperLabelNode.text = "???"
        sniperLabelNode.fontSize = 15
        sniperLabelNode.position = CGPoint(x: 0, y: size.height*2/3)
        
        let sniperLabelBackground = SKShapeNode(rect: CGRect(center: CGPoint(x: 0, y: 0), size: CGSize(width: sniperLabelNode.frame.size.width + 60, height: sniperLabelNode.frame.size.height + 10)), cornerRadius: 5)
        sniperLabelBackground.name = "brawlerLabelBackground"
        sniperLabelBackground.fillColor = UIColor.systemPink
        sniperLabelBackground.position = CGPoint(x: -10, y: sniperLabelNode.frame.height / 2 - 2)
        sniperLabelBackground.zPosition = -1
        sniperLabelNode.addChild(sniperLabelBackground)
        
        let sniperIconNode = SKSpriteNode()
        sniperIconNode.texture = SKTexture(imageNamed: "SniperIcon")
        sniperIconNode.size = CGSize(width: 24, height: 24)
        sniperIconNode.position = CGPoint(x: -40, y: sniperLabelNode.frame.height / 2 - 2)
        sniperLabelNode.addChild(sniperIconNode)
        selectUnitsPanel.addChild(sniperLabelNode)
        
        fighterLabelNode.zPosition = 100
        fighterLabelNode.text = "???"
        fighterLabelNode.fontSize = 15
        fighterLabelNode.position = CGPoint(x: 0, y: size.halfHeight*2/3 - sniperLabelNode.frame.height * 2)
        
        let fighterLabelBackground = SKShapeNode(rect: CGRect(center: CGPoint(x: 0, y: 0), size: CGSize(width: fighterLabelNode.frame.size.width + 60, height: fighterLabelNode.frame.size.height + 10)), cornerRadius: 5)
        fighterLabelBackground.name = "brawlerLabelBackground"
        fighterLabelBackground.fillColor = UIColor.systemPink
        fighterLabelBackground.position = CGPoint(x: -10, y: fighterLabelNode.frame.height / 2 - 2)
        fighterLabelBackground.zPosition = -1
        fighterLabelNode.addChild(fighterLabelBackground)
        
        let fighterIconNode = SKSpriteNode()
        fighterIconNode.texture = SKTexture(imageNamed: "FighterIcon")
        fighterIconNode.size = CGSize(width: 24, height: 24)
        fighterIconNode.position = CGPoint(x: -40, y: fighterLabelNode.frame.height / 2 - 2)
        fighterLabelNode.addChild(fighterIconNode)
        selectUnitsPanel.addChild(fighterLabelNode)
        
        brawlerLabelNode.zPosition = 100
        brawlerLabelNode.text = "???"
        brawlerLabelNode.fontSize = 15
        brawlerLabelNode.position = CGPoint(x: 0, y: size.halfHeight*2/3 - sniperLabelNode.frame.height * 2 - fighterLabelNode.frame.height * 2)
        
        let brawlerLabelBackground = SKShapeNode(rect: CGRect(center: CGPoint(x: 0, y: 0), size: CGSize(width: brawlerLabelNode.frame.size.width + 60, height: brawlerLabelNode.frame.size.height + 10)), cornerRadius: 5)
        brawlerLabelBackground.name = "brawlerLabelBackground"
        brawlerLabelBackground.fillColor = UIColor.systemPink
        brawlerLabelBackground.position = CGPoint(x: -10, y: brawlerLabelNode.frame.height / 2 - 2)
        brawlerLabelBackground.zPosition = -1
        brawlerLabelNode.addChild(brawlerLabelBackground)
        
        let brawlerIconNode = SKSpriteNode()
        brawlerIconNode.texture = SKTexture(imageNamed: "BrawlerIcon")
        brawlerIconNode.size = CGSize(width: 24, height: 24)
        brawlerIconNode.position = CGPoint(x: -40, y: brawlerLabelNode.frame.height / 2 - 2)
        brawlerLabelNode.addChild(brawlerIconNode)
        selectUnitsPanel.addChild(brawlerLabelNode)
        
        transferUnitNodes = [sniperLabelNode, fighterLabelNode, brawlerLabelNode]
        for i in 0..<transferUnitNodes!.count{
            let labelNode = transferUnitNodes![i]
            let labelBackground = labelNode.children.first!
            labelNode.name = "transferLabel" + String(i)
            labelNode.position.x = 0
            labelNode.text = "0"
            
            
            labelNode.position.y += panelSize.halfHeight * 2/3
            
            let leftArrow = SKSpriteNode(imageNamed: "LeftArrow")
            let rightArrow = SKSpriteNode(imageNamed: "RightArrow")
            
            leftArrow.size = CGSize(width: labelBackground.frame.width/3, height: labelBackground.frame.height * 4/5)
            rightArrow.size = CGSize(width: labelBackground.frame.width/3, height: labelBackground.frame.height * 4/5)
            
            leftArrow.name = "leftArrow" + String(i)
            rightArrow.name = "rightArrow" + String(i)
            
            labelNode.addChild(leftArrow)
            labelNode.addChild(rightArrow)
            
            leftArrow.position.x = labelBackground.frame.bottomLeft.x - 30
            rightArrow.position.x = labelBackground.frame.bottomRight.x + 30
            
            leftArrow.position.y = labelBackground.frame.midY
            rightArrow.position.y = labelBackground.frame.midY
            
        }
    }
    
    // creates the line between planets
    func drawLineBetween(aInt: Int, bInt: Int) -> SKShapeNode{
        // just to make our vars more clear
        let a = planetNodes[aInt]; let b = planetNodes[bInt]
        
        // The path and shape for new line
        let newLine = SKShapeNode()
        let drawPath = CGMutablePath()
        
        drawPath.move(to: a.position)
        drawPath.addLine(to: b.position)
        newLine.path = drawPath
        newLine.strokeColor = SKColor.white
        newLine.isUserInteractionEnabled = false
        return newLine
    }
    
    func selectPlanet (planetInt: Int){
        if hasSelectedSpaceship == true {
            if (getConnectedPlanetInts(i: selectedPlanetInt)).contains(planetInt) {
                targetPlanetSprite.position = planetNodes[planetInt].position
            } else {
                inlineErrorMessage(errorMessage: "Too far away")
            }
            return
        }
        else if selectedPlanet == nil {
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
        selectedPlanetInt = planetInt
        
        // Handle spaceship icons
        spaceshipNodes.removeAllChildren()
        for i in 0..<(Global.gameVars.selectedPlanet?.spacesphips.count)! {
            let shipIcon = SKSpriteNode(imageNamed: "SpaceshipIcon")
            shipIcon.name = "ship" + String(i)
            shipIcon.size = CGSize(width: screenSize!.height/5, height: screenSize!.height/5)
            shipIcon.position.x = CGFloat((Int(screenSize!.height)/5 + 15) * i + 100)
            shipIcon.position.y = -panelNodes[0].frame.size.halfHeight - 15
            spaceshipNodes.addChild(shipIcon)
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // checking for planet touches
        let node = self.atPoint(touches.first!.location(in: self))
        for i in 0..<planetNodes.count{
            if "planet" + String(i) == node.name {
                selectPlanet(planetInt: i)
                return
            }
        }
        
        // checking for spacship touches
        for i in 0..<spaceshipNodes.children.count{
            if "ship" + String(i) == node.name {
                let ship = spaceshipNodes.children[i] as! SKSpriteNode
                
                // Checks if deselecting spaceship
                if i == selectedSpaceshipInt && hasSelectedSpaceship == true {
                    borderRectNode.strokeColor = .clear
                    hasSelectedSpaceship = false
                    ship.texture = SKTexture(imageNamed: "SpaceshipIcon")
                    targetPlanetSprite.position = CGPoint(x: -500, y: 500)
                    targetPlanetSprite.removeFromParent()
                    transferPanel.zPosition = -100
                    selectUnitsPanel.zPosition = -1000
                    Global.gameVars.galaxy.planets[selectedPlanetInt].spacesphips[selectedSpaceshipInt].units = unitsToTransfer
                    return
                }
                
                // Selects target spaceship
                transferPanel.zPosition = 100
                borderRectNode.strokeColor = .yellow
                hasSelectedSpaceship = true
                selectedSpaceshipInt = i
                ship.texture = SKTexture(imageNamed: "SpaceshipSelectedIcon")
                panelNodes[2].addChild(targetPlanetSprite)
            }
        }
        
        
        // checking for settings touches
        if node.name == "settings" {
            //            Global.gameVars.alertBox.addAlert(msg: "No settings yet bro", rectColor: Color.red)
            
            Global.gameVars.selectedPlanet?.spacesphips.append(
                Spaceship(city: Global.gameVars.selectedPlanet!.cities[0], units: [.BRAWLER: 0, .SNIPER: 0, .FIGHTER: 0])
            )
            
            // checking for visit plant text
        } else if (node.name == "enterButton" || node.name == "enterText") && selectedPlanet != nil {
            Global.playerManager.playerVariables.currentGameViewLevel = .PLANET
            
        } else if node.name == "selectUnitsText" {
            print("e")
            selectUnitsPanel.zPosition = 99999
        } else if node.name == "confirmUnits" {
            selectUnitsPanel.zPosition = -1000
        } else if node.name == "selectDestinationText" {
        } else if node.name == "startTransferButton" || node.name == "startTransferText" {
            launchSpaceship(spaceshipInt: selectedSpaceshipInt);
        } else {
            for i in 0..<3 {
                if node.name == "leftArrow" + String(i) {
                    var cityUnits = Global.gameVars.selectedPlanet?.spacesphips[selectedSpaceshipInt].currentCity!.units
                    if unitsToTransfer[UnitType.allCases[i]]! > 0 {
                        unitsToTransfer[UnitType.allCases[i]]! -= 1
                        cityUnits![UnitType.allCases[i]]! += 1
                        transferUnitNodes![i].text = String(unitsToTransfer[UnitType.allCases[i]]!)
                    } else {
                        transferUnitNodes![i].run(pulsedRed)
                    }
                } else if node.name == "rightArrow" + String(i) {
                    print(i)
                    var cityUnits = Global.gameVars.selectedPlanet?.spacesphips[selectedSpaceshipInt].currentCity?.units
                    if cityUnits![UnitType.allCases[i]]! > 0 {
                        print("e");
                        Global.gameVars.selectedPlanet!.spacesphips[selectedSpaceshipInt].currentCity?.units[UnitType.allCases[i]]! -= 1
                        unitsToTransfer[UnitType.allCases[i]]! += 1
                        transferUnitNodes![i].text = String(unitsToTransfer[UnitType.allCases[i]]!)
                    } else {
                        transferUnitNodes![i].run(pulsedRed)
                    }
                }
            }
        }
    }
    
    func getConnectedPlanetInts(i: Int) -> [Int] {
        switch i {
        case 0:
            return [1,2,3]
        case 1:
            return [0,2,3,4]
        case 2:
            return [0,1,3,5]
        case 3:
            return [0,1,2,4,5,6]
        case 4:
            return [1,3,5,6]
        case 5:
            return [2,3,4,6]
        case 6:
            return [3,4,5]
        default:
            fatalError()
        }
    }
    
    public func inlineErrorMessage(errorMessage: String) {
        inlineErrorLabelNode.removeAllChildren()
        inlineErrorLabelNode.text = errorMessage
        
        let inlineErrorBackground = SKShapeNode(rect: CGRect(center: CGPoint(x: 0, y: 0), size: CGSize(width: inlineErrorLabelNode.frame.size.width + 40, height: inlineErrorLabelNode.frame.size.height + 10)), cornerRadius: 5)
        inlineErrorBackground.fillColor = .black
        inlineErrorBackground.strokeColor = .black
        inlineErrorBackground.alpha = 0.75
        inlineErrorBackground.position = CGPoint(x: 0, y: inlineErrorLabelNode.frame.height / 2 - 2)
        inlineErrorBackground.zPosition = -1
        
        inlineErrorLabelNode.addChild(inlineErrorBackground)
        inlineErrorLabelNode.alpha = 0
        
        let action = SKAction.fadeIn(withDuration: 0.5)
        let actionWait = SKAction.wait(forDuration: 3)
        let action2 = SKAction.fadeOut(withDuration: 0.5)
        
        let sequence = SKAction.sequence([action, actionWait, action2])
        inlineErrorLabelNode.run(sequence)
    }
    private let pulsedRed = SKAction.sequence([
        SKAction.colorize(with: .red, colorBlendFactor: 1.0, duration: 0.15),
        SKAction.wait(forDuration: 0.1),
        SKAction.colorize(withColorBlendFactor: 0.0, duration: 0.15)])
    
    func launchSpaceship(spaceshipInt: Int){
        let ship = Global.gameVars.selectedPlanet!.spacesphips[selectedSpaceshipInt]
        ship.units = unitsToTransfer
        let sPos = planetNodes[selectedPlanetInt].position
        let ePos = targetPlanetSprite.position
        var ePlanetInt = 0
        for i in 0..<planetNodes.count{
            if planetNodes[i].position == targetPlanetSprite.position {
                ePlanetInt = i
            }
        }
        let transfer = PlanetTransfer(ship: ship, endPlanetint: ePlanetInt, endCityint: 0, startPos: sPos, endPos: ePos)
        galaxy?.planetTransfers.append(transfer)
        galaxy?.planets[selectedPlanetInt].spacesphips.remove(at: spaceshipInt)
        panelNodes[2].addChild(transfer.unitSprite)
        borderRectNode.strokeColor = .clear
        hasSelectedSpaceship = false
        transferPanel.zPosition = -1500
        targetPlanetSprite.position.x = -5000
        spaceshipNodes.children[spaceshipInt].removeFromParent()
    }
}


