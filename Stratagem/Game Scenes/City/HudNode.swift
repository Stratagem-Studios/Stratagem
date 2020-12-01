import SpriteKit
import SKTiled
import SwiftySKScrollView


class HudNode : SKNode {
    private let cityNameLabelNode = SKLabelNode(fontNamed: "Montserrat-Bold")
    private let buildButtonNode = SKSpriteNode(texture: SKTexture(imageNamed: "Build"))
    private let destroyButtonNode = SKSpriteNode(texture: SKTexture(imageNamed: "Destroy"))
    
    private var borderRectNode = SKShapeNode()
    
    // Building selecter scroll view
    var scrollView: SwiftySKScrollView?
    let moveableNode = SKNode()

    private var size: CGSize = CGSize(width: 0, height: 0)
    
    public func setup(city: City, size: CGSize, view: UIView, tilemap: SKTilemap) {
        self.size = size
        cityNameLabelNode.fontName = "Montserrat-Bold"
        cityNameLabelNode.zPosition = 100000
        cityNameLabelNode.text = city.cityName
        cityNameLabelNode.fontSize = 20
        cityNameLabelNode.position = CGPoint(x: 0, y: size.halfHeight - 30)
        
        let cityNameBackground = SKShapeNode(rect: CGRect(center: CGPoint(x: 0, y: 0), size: CGSize(width: cityNameLabelNode.frame.size.width + 40, height: cityNameLabelNode.frame.size.height + 10)), cornerRadius: 5)
        cityNameBackground.name = "cityNameBackgroundNode"
        cityNameBackground.fillColor = UIColor(named: "TitleBackground")!
        cityNameBackground.position = CGPoint(x: 0, y: size.halfHeight - 23)
        cityNameBackground.zPosition = 100000 - 1
        
        buildButtonNode.name = "buildButtonNode"
        buildButtonNode.zPosition = 100000
        buildButtonNode.position = CGPoint(x: -1 * size.halfWidth + 50, y: -1 * size.halfHeight + 50)
        buildButtonNode.size = CGSize(width: 42, height: 42)

        destroyButtonNode.name = "destroyButtonNode"
        destroyButtonNode.zPosition = 100000
        destroyButtonNode.position = CGPoint(x: -size.halfWidth + 125, y: -size.halfHeight + 50)
        destroyButtonNode.size = CGSize(width: 75, height: 75)
        
        borderRectNode = SKShapeNode(rect: CGRect(center: CGPoint(x: 0, y: 0), size: CGSize(width: size.width, height: size.height)))
        borderRectNode.name = "borderRectNode"
        borderRectNode.zPosition = 100000 - 1
        borderRectNode.fillColor = .clear
        borderRectNode.strokeColor = .clear
        borderRectNode.alpha = 0.5
        borderRectNode.glowWidth = 5
        borderRectNode.lineWidth = 3
        
        moveableNode.zPosition = 100000
        moveableNode.position = CGPoint(x: 0, y: -size.halfHeight + 75)
        
        addChild(cityNameLabelNode)
        addChild(cityNameBackground)

        addChild(buildButtonNode)
        addChild(destroyButtonNode)
        addChild(borderRectNode)
        
        addChild(moveableNode)
    }
    
    public func noneState() {
        changeBorderColor(color: .clear)
        
        moveableNode.isHidden = true
        scrollView?.removeFromSuperview()
        scrollView = nil // nil out reference to deallocate properly
    }
    
    public func buildState(view: UIView, tilemap: SKTilemap) {
        changeBorderColor(color: .green)
        
        moveableNode.isHidden = false
        setupBuildingScrollView(view: view, tilemap: tilemap)
    }
    
    public func destroyState() {
        changeBorderColor(color: .red)
        
        moveableNode.isHidden = true
        scrollView?.removeFromSuperview()
        scrollView = nil // nil out reference to deallocate properly
    }
    
    private func setupBuildingScrollView(view: UIView, tilemap: SKTilemap) {
        scrollView = SwiftySKScrollView(frame: CGRect(x: 0, y: size.height - 100, width: size.width, height: 100), moveableNode: moveableNode, direction: .horizontal)
        scrollView?.contentSize = CGSize(width: scrollView!.frame.width * 3, height: scrollView!.frame.height) // * 3 makes it three times as wide
        view.addSubview(scrollView!)
        scrollView?.setContentOffset(CGPoint(x: 0 + scrollView!.frame.width * 2, y: 0), animated: false)
        
        //
        guard let scrollView = scrollView else { return } // unwrap  optional
        
        let buildingTypes = ["road", "residential", "industrial"]
        
        for (i, buildingType) in buildingTypes.enumerated() {
            let pageScrollView = SKSpriteNode(color: .clear, size: CGSize(width: scrollView.frame.width, height: scrollView.frame.size.height))
            pageScrollView.position = CGPoint(x: frame.midX - (scrollView.frame.width * (buildingTypes.count - 1 - i)), y: frame.midY)
            moveableNode.addChild(pageScrollView)
            
            for (j, tile) in tilemap.tilesets.first!.getTileData(withProperty: "type", buildingType).enumerated() {
                let sprite = SKSpriteNode(texture: tile.texture, size: CGSize(width: 50, height: 100))
                sprite.name = tile.name
                sprite.position = CGPoint(x: j * 100, y: 0)
                pageScrollView.addChild(sprite)
            }
        }
    }
    
    public func update() {
        
    }
    
    public func changeBorderColor(color: UIColor) {
        borderRectNode.strokeColor = color
    }
    
    public func unInit() {
        scrollView?.removeFromSuperview()
        scrollView = nil // nil out reference to deallocate properly
    }
}
