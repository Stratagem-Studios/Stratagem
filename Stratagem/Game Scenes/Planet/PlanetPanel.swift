import Foundation
import SceneKit
import SpriteKit
import SwiftUI

class PlanetPanel: SKScene {
    
    
    private let popLabelNode = SKLabelNode(fontNamed: "Montserrat-Bold")
    private let creditsLabelNode = SKLabelNode(fontNamed: "Montserrat-Bold")
    private let metalLabelNode = SKLabelNode(fontNamed: "Montserrat-Bold")
    private let cityNameNode = SKLabelNode(fontNamed: "Montserrat-Bold")
    
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
        cityNameNode.fontSize = panelSize.height/12
        cityNameNode.fontColor = UIColor.black
        descriptionPanel.addChild(cityNameNode)
        
        metalLabelNode.zPosition = 100
        metalLabelNode.text = "9"
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
        popLabelNode.text = "3000"
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
        creditsLabelNode.text = "1000"
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
        
        //=====
        
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
    
    
}
