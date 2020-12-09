import Foundation
import SceneKit
import SpriteKit

class PlanetPanel: SKScene {
    override func sceneDidLoad() {
        let panelSize = CGSize(width: UIScreen.main.bounds.size.width/3, height: UIScreen.main.bounds.size.height)
        backgroundColor = UIColor.clear
        size = panelSize
        
        let descriptionPanel = SKShapeNode(rectOf: panelSize, cornerRadius: 30)
        descriptionPanel.position = CGPoint(x: panelSize.halfWidth, y: panelSize.halfHeight)
        descriptionPanel.fillColor = SKColor.white
        descriptionPanel.strokeColor = SKColor.black
        descriptionPanel.name = "descriptionPanel"
        addChild(descriptionPanel)
        
        
    }
    
    func selectCity(city: City){
        print("d")
    }
    
    
}

class PlanetTopPanel: SKScene {
    override func sceneDidLoad() {
        
    }
}
