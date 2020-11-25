import SpriteKit

class HudNode : SKNode {
    private let cityNameLabelNode = SKLabelNode(fontNamed: "Montserrat-Bold")
    private let buildButtonNode = SKSpriteNode(texture: SKTexture(imageNamed: "Settings"))
    
    private var size: CGSize = CGSize(width: 0, height: 0)
    
    public func setup(city: City, size: CGSize) {
        self.size = size
        cityNameLabelNode.name = "cityNameLabelNode"
        cityNameLabelNode.zPosition = 100000
        cityNameLabelNode.text = city.cityName
        cityNameLabelNode.fontSize = 20
        cityNameLabelNode.position = CGPoint(x: 0, y: size.halfHeight - 25)
        
        buildButtonNode.name = "buildButtonNode"
        buildButtonNode.zPosition = 100000
        buildButtonNode.position = CGPoint(x: -1 * size.halfWidth + 50, y: -1 * size.halfHeight + 25)
        
        addChild(cityNameLabelNode)
        addChild(buildButtonNode)
    }
    
    public func update() {
        
    }
}
