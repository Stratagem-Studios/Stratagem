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
    
    private let descriptionPanel = SKShapeNode(rectOf: CGSize(width: UIScreen.main.bounds.size.width/3, height: UIScreen.main.bounds.size.height), cornerRadius: 50)
    
    
    
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
        enterText.name = "enterText"
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
        placeholderPanel.addChild(placeholderText)
        placeholderPanel.name = "placeholderPanel"
        addChild(placeholderPanel)
        
        if Global.gameVars.selectedPlanet!.cities.count > 1 {
            let unitTransferButton = SKShapeNode(rectOf: CGSize(width: panelSize.width/4, height: panelSize.width/7), cornerRadius: 10)
            unitTransferButton.position = CGPoint(x: 0, y: -panelSize.height*2/3)
            unitTransferButton.fillColor = SKColor.black
            unitTransferButton.name = "transferButton"
            let transferText = SKLabelNode(fontNamed: "Montserrat-Bold")
            transferText.fontSize = panelSize.height/18
            transferText.fontColor = SKColor.yellow
            transferText.verticalAlignmentMode = .center
            transferText.name = "transferText"
            transferText.text = "Transfer Units"
            unitTransferButton.addChild(transferText)
            descriptionPanel.addChild(unitTransferButton)
        }
    }
    
    func selectCity(city: City){
        if children.first?.name != "descriptionPanel" {
            removeAllChildren()
            addChild(descriptionPanel)
        }
        cityNameNode.text = Global.gameVars.selectedCity!.cityName
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let node = self.atPoint(touches.first!.location(in: self))
        if (node.name == "enterText" || node.name == "enterButton") && children.first?.name == "descriptionPanel"{
            Global.playerVariables.currentGameViewLevel = .CITY
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
        }
    }
    
    
}
