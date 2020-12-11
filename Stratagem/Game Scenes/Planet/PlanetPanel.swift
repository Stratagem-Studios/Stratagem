import Foundation
import SceneKit
import SpriteKit
import SwiftUI

class PlanetPanel: SKScene {
    
    
    private let popLabelNode = SKLabelNode(fontNamed: "Montserrat-Bold")
    private let creditsLabelNode = SKLabelNode(fontNamed: "Montserrat-Bold")
    private let metalLabelNode = SKLabelNode(fontNamed: "Montserrat-Bold")
    private let cityNameNode = SKLabelNode(fontNamed: "Montserrat-Bold")
    private let brawlerLabelNode = SKLabelNode(fontNamed: "Montserrat-Bold")
    private let sniperLabelNode = SKLabelNode(fontNamed: "Montserrat-Bold")
    private let fighterLabelNode = SKLabelNode(fontNamed: "Montserrat-Bold")
    
    weak var planet = Global.gameVars.selectedPlanet!
    
    private var transferSnipernode: SKLabelNode?
    private var transferFighterNode: SKLabelNode?
    private var transferBrawlerNode: SKLabelNode?
    
    private var avalibleUnitsLabel: [SKLabelNode] = []
    private var avalibleUnits: [UnitType : Int] = [.SNIPER:0, .FIGHTER:0, .BRAWLER:0]
    
    private var unitsToTransfer: [UnitType : Int] = [.SNIPER:0, .FIGHTER:0, .BRAWLER:0]
    
    private let descriptionPanel = SKShapeNode(rectOf: CGSize(width: UIScreen.main.bounds.size.width/3, height: UIScreen.main.bounds.size.height), cornerRadius: 50)
    
    private let unitTransferNode = SKShapeNode(rectOf: CGSize(width: UIScreen.main.bounds.size.width/3, height: UIScreen.main.bounds.size.height), cornerRadius: 50)
    
    private let pulsedRed = SKAction.sequence([
        SKAction.colorize(with: .red, colorBlendFactor: 1.0, duration: 0.15),
        SKAction.wait(forDuration: 0.1),
        SKAction.colorize(withColorBlendFactor: 0.0, duration: 0.15)])
    
    private var startCityint: Int = -1
    private var endCityInt: Int = -1
    
    override func sceneDidLoad() {
        let panelSize = CGSize(width: UIScreen.main.bounds.size.width/3, height: UIScreen.main.bounds.size.height)
        backgroundColor = UIColor.clear
        size = panelSize
        
        descriptionPanel.position = CGPoint(x: panelSize.halfWidth, y: panelSize.halfHeight)
        descriptionPanel.fillColor = SKColor.white
        descriptionPanel.strokeColor = SKColor.black
        descriptionPanel.name = "descriptionPanel"
        
        cityNameNode.position = CGPoint(x: 0, y: panelSize.halfHeight - panelSize.height/10)
        cityNameNode.text = "CityName"
        cityNameNode.fontSize = panelSize.width/12
        cityNameNode.fontColor = UIColor.black
        descriptionPanel.addChild(cityNameNode)
        
        metalLabelNode.zPosition = 100
        metalLabelNode.text = "???"
        metalLabelNode.fontSize = 15
        metalLabelNode.position = CGPoint(x: -panelSize.halfWidth/3, y: size.halfHeight*2/3)
        
        let metalLabelBackground = SKShapeNode(rect: CGRect(center: CGPoint(x: 0, y: 0), size: CGSize(width: metalLabelNode.frame.size.width + 70, height: metalLabelNode.frame.size.height + 10)), cornerRadius: 5)
        metalLabelBackground.name = "metalLabelBackground"
        metalLabelBackground.fillColor = UIColor(named: "TitleBackground")!
        metalLabelBackground.position = CGPoint(x: -20, y: metalLabelNode.frame.height / 2 - 2)
        metalLabelBackground.zPosition = -1
        metalLabelNode.addChild(metalLabelBackground)
        
        let metalIconNode = SKSpriteNode()
        metalIconNode.texture = SKTexture(imageNamed: "Metal")
        metalIconNode.size = CGSize(width: 36, height: 18)
        metalIconNode.position = CGPoint(x: -40, y: metalLabelNode.frame.height / 2 - 2)
        metalLabelNode.addChild(metalIconNode)
        descriptionPanel.addChild(metalLabelNode)
        
        popLabelNode.zPosition = 100
        popLabelNode.text = "???"
        popLabelNode.fontSize = 15
        popLabelNode.position = CGPoint(x: -panelSize.halfWidth/3, y: size.halfHeight*2/3 - metalLabelNode.frame.height * 2)
        
        let popLabelBackground = SKShapeNode(rect: CGRect(center: CGPoint(x: 0, y: 0), size: CGSize(width: popLabelNode.frame.size.width + 60, height: popLabelNode.frame.size.height + 10)), cornerRadius: 5)
        popLabelBackground.name = "popLabelBackground"
        popLabelBackground.fillColor = UIColor(named: "TitleBackground")!
        popLabelBackground.position = CGPoint(x: -10, y: popLabelNode.frame.height / 2 - 2)
        popLabelBackground.zPosition = -1
        popLabelNode.addChild(popLabelBackground)
        
        let popIconNode = SKSpriteNode()
        popIconNode.texture = SKTexture(imageNamed: "Population")
        popIconNode.size = CGSize(width: 24, height: 24)
        popIconNode.position = CGPoint(x: -40, y: popLabelNode.frame.height / 2 - 2)
        popLabelNode.addChild(popIconNode)
        descriptionPanel.addChild(popLabelNode)
        
        creditsLabelNode.zPosition = 100
        creditsLabelNode.text = "???"
        creditsLabelNode.fontSize = 15
        creditsLabelNode.position = CGPoint(x: -panelSize.halfWidth/3, y: size.halfHeight*2/3 - metalLabelNode.frame.height * 2 - popLabelNode.frame.height * 2)
        
        let creditsLabelBackground = SKShapeNode(rect: CGRect(center: CGPoint(x: 0, y: 0), size: CGSize(width: creditsLabelNode.frame.size.width + 60, height: creditsLabelNode.frame.size.height + 10)), cornerRadius: 5)
        creditsLabelBackground.name = "creditsLabelBackground"
        creditsLabelBackground.fillColor = UIColor(named: "TitleBackground")!
        creditsLabelBackground.position = CGPoint(x: -10, y: creditsLabelNode.frame.height / 2 - 2)
        creditsLabelBackground.zPosition = -1
        creditsLabelNode.addChild(creditsLabelBackground)
        
        let creditsIconNode = SKSpriteNode()
        creditsIconNode.texture = SKTexture(imageNamed: "Coin")
        creditsIconNode.size = CGSize(width: 24, height: 24)
        creditsIconNode.position = CGPoint(x: -40, y: creditsLabelNode.frame.height / 2 - 2)
        creditsLabelNode.addChild(creditsIconNode)
        descriptionPanel.addChild(creditsLabelNode)
        
        let enterButton = SKShapeNode(rectOf: CGSize(width: panelSize.width * 2/3, height: panelSize.width/7), cornerRadius: 10)
        enterButton.position = CGPoint(x: 0, y: -panelSize.height/3)
        enterButton.fillColor = SKColor.black
        enterButton.name = "enterButton"
        let enterText = SKLabelNode(fontNamed: "Montserrat-Bold")
        enterText.fontSize = panelSize.height/18
        enterText.fontColor = SKColor.yellow
        enterText.verticalAlignmentMode = .center
        enterText.name = "enterButton"
        enterText.text = "Visit City"
        enterButton.addChild(enterText)
        descriptionPanel.addChild(enterButton)
        
        //========
        
        sniperLabelNode.zPosition = 100
        sniperLabelNode.text = "???"
        sniperLabelNode.fontSize = 15
        sniperLabelNode.position = CGPoint(x: panelSize.halfWidth/3, y: size.halfHeight*2/3)
        
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
        descriptionPanel.addChild(sniperLabelNode)
        
        fighterLabelNode.zPosition = 100
        fighterLabelNode.text = "???"
        fighterLabelNode.fontSize = 15
        fighterLabelNode.position = CGPoint(x: panelSize.halfWidth/3, y: size.halfHeight*2/3 - metalLabelNode.frame.height * 2)
        
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
        descriptionPanel.addChild(fighterLabelNode)
        
        brawlerLabelNode.zPosition = 100
        brawlerLabelNode.text = "???"
        brawlerLabelNode.fontSize = 15
        brawlerLabelNode.position = CGPoint(x: panelSize.halfWidth/3, y: size.halfHeight*2/3 - metalLabelNode.frame.height * 2 - popLabelNode.frame.height * 2)
        
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
        descriptionPanel.addChild(brawlerLabelNode)
        
        //========
        
        let placeholderPanel = SKShapeNode(rectOf: CGSize(width: UIScreen.main.bounds.size.width/3, height: UIScreen.main.bounds.size.height), cornerRadius: 50)
        placeholderPanel.position = CGPoint(x: panelSize.halfWidth, y: panelSize.halfHeight)
        placeholderPanel.fillColor = SKColor.gray
        placeholderPanel.strokeColor = SKColor.clear
        let placeholderText = SKLabelNode(fontNamed: "Montserrat-Bold")
        placeholderText.text = "Please select a city"
        placeholderText.fontSize = 20
        placeholderText.name = "placeholderPanel"
        placeholderPanel.addChild(placeholderText)
        placeholderPanel.name = "placeholderPanel"
        addChild(placeholderPanel)
        
        
        // =========================================
        // unit transfer nodes
        
        if Global.gameVars.selectedPlanet!.cities.count > 1 {
            let unitTransferButton = SKShapeNode(rectOf: CGSize(width: panelSize.width * 2/3, height: panelSize.width/7), cornerRadius: 10)
            unitTransferButton.position = CGPoint(x: 0, y: -panelSize.height/5)
            unitTransferButton.fillColor = SKColor.black
            unitTransferButton.name = "transferButton"
            let transferText = SKLabelNode(fontNamed: "Montserrat-Bold")
            transferText.fontSize = panelSize.height/18
            transferText.fontColor = SKColor.yellow
            transferText.verticalAlignmentMode = .center
            transferText.name = "transferButton"
            transferText.text = "Transfer Units"
            unitTransferButton.addChild(transferText)
            descriptionPanel.addChild(unitTransferButton)
        }
        
        unitTransferNode.name = "unitTransferNode"
        unitTransferNode.position = CGPoint(x: panelSize.halfWidth, y: panelSize.halfHeight)
        unitTransferNode.fillColor = UIColor.white
        
        let exitUnitTransfer = SKSpriteNode(imageNamed: "Close")
        exitUnitTransfer.name = "exitUnitTransfer"
        exitUnitTransfer.size = CGSize(width: 50, height: 50)
        exitUnitTransfer.zPosition = 101
        exitUnitTransfer.position = CGPoint(x: -panelSize.halfWidth + 30, y: panelSize.halfHeight - 30)
        exitUnitTransfer.color = UIColor.red
        exitUnitTransfer.colorBlendFactor = 0.7
        unitTransferNode.addChild(exitUnitTransfer)
        
        transferSnipernode = (sniperLabelNode.copy() as! SKLabelNode)
        transferFighterNode = (fighterLabelNode.copy() as! SKLabelNode)
        transferBrawlerNode = (brawlerLabelNode.copy() as! SKLabelNode)
        
        let transferUnitNodes: [SKLabelNode] = [transferSnipernode!,transferFighterNode!,transferBrawlerNode!]
        for i in 0..<transferUnitNodes.count{
            let labelNode = transferUnitNodes[i]
            let labelBackground = labelNode.children.first!
            labelNode.name = "transferLabel" + String(i)
            labelNode.position.x = 0
            labelNode.text = "0"
            
            avalibleUnitsLabel.append(labelNode.copy() as! SKLabelNode)
            
            labelNode.position.y -= panelSize.halfHeight * 2/3
            
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
            
            unitTransferNode.addChild(labelNode)
        }
        
        for labelNode in avalibleUnitsLabel {
            let labelBackground = labelNode.children.first! as! SKShapeNode
            labelBackground.fillColor = UIColor.systemGreen
            unitTransferNode.addChild(labelNode)
            labelNode.position.y -= 1/10*panelSize.height
        }
        
        let avalibleUnitsLabel = SKLabelNode(fontNamed: "Montserrat-Bold")
        avalibleUnitsLabel.text = "Avalible Units"
        avalibleUnitsLabel.position = CGPoint(x: 0, y: exitUnitTransfer.position.y)
        unitTransferNode.addChild(avalibleUnitsLabel)
        
    }
    
    func selectCity(city: City, cityInt: Int){
        if children.first?.name == "placeholderPanel" {
            removeAllChildren()
            addChild(descriptionPanel)
            cityNameNode.text = city.cityName
            avalibleUnits = city.units
            startCityint = cityInt
            planet?.planetMap.selectCitySprite(loc: (planet?.cityLocs[cityInt])!)
        } else if children.first?.name == "unitTransferNode" {
            endCityInt = cityInt
            planet?.drawLineBetweenCites(startInt: startCityint, endInt: endCityInt)
        } else {
            cityNameNode.text = city.cityName
            avalibleUnits = city.units
            startCityint = cityInt
            planet?.planetMap.selectCitySprite(loc: (planet?.cityLocs[cityInt])!)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let node = self.atPoint(touches.first!.location(in: self))
        if children.first?.name != "placeholderPanel" {
            switch node.name {
            case "enterButton":
                Global.playerVariables.currentGameViewLevel = .CITY
            case "transferButton":
                removeAllChildren()
                addChild(unitTransferNode)
            case "exitUnitTransfer":
                planet?.planetMap.lineMaster.removeAllChildren()
                removeAllChildren()
                addChild(descriptionPanel)
                unitsToTransfer = [.SNIPER:0,.FIGHTER:0,.BRAWLER:0]
            default:
                // chack to see if it is an arrow
                var arrowName = node.name
                guard let arrowInt = arrowName?.removeLast() else {
                    return
                }
                if arrowName == "rightArrow" {
                    switch arrowInt {
                    case "0":
                        if avalibleUnits[.SNIPER] != 0 {
                            unitsToTransfer[.SNIPER]! += 1
                            avalibleUnits[.SNIPER]! -= 1
                        } else {
                            avalibleUnitsLabel[0].run(pulsedRed)
                        }
                    case "1":
                        if avalibleUnits[.FIGHTER] != 0 {
                            unitsToTransfer[.FIGHTER]! += 1
                            avalibleUnits[.FIGHTER]! -= 1
                        } else {
                            avalibleUnitsLabel[1].run(pulsedRed)
                        }
                    case "2":
                        if avalibleUnits[.BRAWLER] != 0 {
                            unitsToTransfer[.BRAWLER]! += 1
                            avalibleUnits[.BRAWLER]! -= 1
                        } else {
                            avalibleUnitsLabel[2].run(pulsedRed)
                        }
                    default:
                        print("Error, arrowInt was not 0,1,2. check PlanetPanel.Swift")
                    }
                } else if arrowName == "leftArrow" {
                    switch arrowInt {
                    case "0":
                        if unitsToTransfer[.SNIPER] != 0 {
                            avalibleUnits[.SNIPER]! += 1
                            unitsToTransfer[.SNIPER]! -= 1
                        } else {
                            sniperLabelNode.run(pulsedRed)
                        }
                    case "1":
                        if unitsToTransfer[.FIGHTER] != 0 {
                            avalibleUnits[.FIGHTER]! += 1
                            unitsToTransfer[.FIGHTER]! -= 1
                        } else {
                            fighterLabelNode.run(pulsedRed)
                        }
                    case "2":
                        if unitsToTransfer[.BRAWLER] != 0 {
                            avalibleUnits[.BRAWLER]! += 1
                            unitsToTransfer[.BRAWLER]! -= 1
                        } else {
                            brawlerLabelNode.run(pulsedRed)
                        }
                    default:
                        print("Error, arrowInt was not 0,1,2. check PlanetPanel.Swift")
                    }
                }
            }
        }
    }
    
    // seperate from global update loop. only needs to trigger while seen open
    override func update(_ currentTime: TimeInterval) {
        if children.first?.name == "descriptionPanel"{
            if Global.gameVars.selectedPlanet?.owner == Global.playerVariables.playerName {
                popLabelNode.text = String(Int(Global.gameVars.selectedCity!.resources[.POPULATION]!))
                creditsLabelNode.text = String(Int(Global.gameVars.selectedCity!.resources[.CREDITS]!))
                metalLabelNode.text = String(Int(Global.gameVars.selectedCity!.resources[.METAL]!))
                
                brawlerLabelNode.text = String(Int(Global.gameVars.selectedCity!.units[.BRAWLER]!))
                sniperLabelNode.text = String(Int(Global.gameVars.selectedCity!.units[.SNIPER]!))
                fighterLabelNode.text = String(Int(Global.gameVars.selectedCity!.units[.FIGHTER]!))
            }
        } else if children.first?.name == "unitTransferNode" {
            transferSnipernode!.text = String(unitsToTransfer[.SNIPER]!)
            transferFighterNode!.text = String(unitsToTransfer[.FIGHTER]!)
            transferBrawlerNode!.text = String(unitsToTransfer[.BRAWLER]!)
            
            avalibleUnitsLabel[0].text = String(avalibleUnits[.SNIPER]!)
            avalibleUnitsLabel[1].text = String(avalibleUnits[.FIGHTER]!)
            avalibleUnitsLabel[2].text = String(avalibleUnits[.BRAWLER]!)
        }
    }
    
    
}
