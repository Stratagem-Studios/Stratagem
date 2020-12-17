import SpriteKit
import SKTiled


class HudNode : SKNode {
    private let cityNameLabelNode = SKLabelNode(fontNamed: "Montserrat-Bold")
    private let popLabelNode = SKLabelNode(fontNamed: "Montserrat-Bold")
    private let creditsLabelNode = SKLabelNode(fontNamed: "Montserrat-Bold")
    private let metalLabelNode = SKLabelNode(fontNamed: "Montserrat-Bold")
    
    private let buildButtonNode = SKSpriteNode(texture: SKTexture(imageNamed: "Build"))
    private let destroyButtonNode = SKSpriteNode(texture: SKTexture(imageNamed: "Destroy"))
    private let inlineErrorLabelNode = SKLabelNode(fontNamed: "Montserrat-Bold")
    
    private var borderRectNode = SKShapeNode()
    
    public var selectedBuildingPopupNode = SelectedBuildingPopupNode(size: CGSize(width: 0, height: 0))
    
    // Building selecter scroll view
    var scrollView: SwiftySKScrollView?
    let moveableNode = SKNode()
    
    private var size: CGSize = CGSize(width: 0, height: 0)
    private weak var city: City?
    
    public func setup(city: City, size: CGSize, view: UIView, tilemap: SKTilemap) {
        self.city = city
        self.size = size
        
        selectedBuildingPopupNode = SelectedBuildingPopupNode(size: size)
        ///
        cityNameLabelNode.zPosition = 100000
        cityNameLabelNode.text = city.cityName
        cityNameLabelNode.fontSize = 20
        cityNameLabelNode.position = CGPoint(x: 0, y: size.halfHeight - 30)
        
        let cityNameBackground = SKShapeNode(rect: CGRect(center: CGPoint(x: 0, y: 0), size: CGSize(width: cityNameLabelNode.frame.size.width + 40, height: cityNameLabelNode.frame.size.height + 10)), cornerRadius: 5)
        cityNameBackground.name = "cityNameBackgroundNode"
        cityNameBackground.fillColor = UIColor(named: "TitleBackground")!
        cityNameBackground.position = CGPoint(x: 0, y: cityNameLabelNode.frame.height / 2 - 2)
        cityNameBackground.zPosition = -1
        cityNameLabelNode.addChild(cityNameBackground)
        
        ///
        popLabelNode.zPosition = 100000
        popLabelNode.text = String(Int(self.city!.resources[.POPULATION]!))
        popLabelNode.fontSize = 15
        popLabelNode.position = CGPoint(x: -size.halfWidth + 75, y: size.halfHeight - 30)
        
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
        
        ///
        creditsLabelNode.zPosition = 100000
        creditsLabelNode.text = String(Int(self.city!.resources[.CREDITS]!))
        creditsLabelNode.fontSize = 15
        creditsLabelNode.position = CGPoint(x: -size.halfWidth + 200, y: size.halfHeight - 30)
        
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
        
        ///
        metalLabelNode.zPosition = 100000
        metalLabelNode.text = String(Int(self.city!.resources[.METAL]!))
        metalLabelNode.fontSize = 15
        metalLabelNode.position = CGPoint(x: -size.halfWidth + 325, y: size.halfHeight - 30)
        
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
        
        ///
        inlineErrorLabelNode.zPosition = 100000 + 1
        inlineErrorLabelNode.fontSize = 15
        inlineErrorLabelNode.position = CGPoint(x: 0, y: -size.halfHeight + 200)
        inlineErrorLabelNode.alpha = 0
        
        ///
        buildButtonNode.name = "buildButtonNode"
        buildButtonNode.zPosition = 100000
        buildButtonNode.position = CGPoint(x: -1 * size.halfWidth + 50, y: -1 * size.halfHeight + 50)
        buildButtonNode.size = CGSize(width: 42, height: 42)
        
        destroyButtonNode.name = "destroyButtonNode"
        destroyButtonNode.zPosition = 100000
        destroyButtonNode.position = CGPoint(x: -size.halfWidth + 125, y: -size.halfHeight + 50)
        destroyButtonNode.size = CGSize(width: 42, height: 42)
        
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
        
        selectedBuildingPopupNode.position = CGPoint(x: 0, y: 0)
        selectedBuildingPopupNode.zPosition = 100000
        
        addChild(cityNameLabelNode)
        if city.owner == Global.playerVariables.playerName {
            addChild(popLabelNode)
            addChild(creditsLabelNode)
            addChild(metalLabelNode)
            
            addChild(inlineErrorLabelNode)
            
            addChild(buildButtonNode)
            addChild(destroyButtonNode)
            addChild(borderRectNode)
            
            addChild(moveableNode)
            
            addChild(selectedBuildingPopupNode)
        }
    }
    
    public func noneState() {
        changeBorderColor(color: .clear)
        
        moveableNode.isHidden = true
        scrollView?.removeFromSuperview()
        scrollView = nil // nil out reference to deallocate properly
        selectedBuildingPopupNode.changeStateToNone()
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
    
    private func setupBuildingScrollView(view: UIView, tilemap: SKTilemap) {
        scrollView = SwiftySKScrollView(frame: CGRect(x: 0, y: size.height - 100, width: size.width, height: 100), moveableNode: moveableNode, direction: .horizontal, hudNode: self, size: size)
        scrollView?.contentSize = CGSize(width: scrollView!.frame.width * 4, height: scrollView!.frame.height) // * 4 makes it three times as wide
        view.addSubview(scrollView!)
        scrollView?.setContentOffset(CGPoint(x: 0 + scrollView!.frame.width * 3, y: 0), animated: false)
        
        //
        guard let scrollView = scrollView else { return } // unwrap  optional
        
        let buildingTypes = ["road", "residential", "industrial", "military"]
        
        for (i, buildingType) in buildingTypes.enumerated() {
            let pageScrollView = SKSpriteNode(color: .clear, size: CGSize(width: scrollView.frame.width, height: scrollView.frame.size.height))
            pageScrollView.position = CGPoint(x: frame.midX - (scrollView.frame.width * (buildingTypes.count - 1 - i)), y: frame.midY)
            moveableNode.addChild(pageScrollView)
            
            // Texture nodes
            for (j, tile) in tilemap.tilesets.first!.getTileData(withProperty: "type", buildingType).enumerated() {
                let sprite = SKSpriteNode(texture: tile.texture, size: CGSize(width: 50, height: 100))
                sprite.name = tile.name
                sprite.position = CGPoint(x: j * 100, y: 0)
                pageScrollView.addChild(sprite)
            }
            
            // Button to switch pages nodes
            let button1 = SKSpriteNode(texture: SKTexture(imageNamed: buildingType))
            button1.name = "BUTTON \(buildingType)"
            button1.size = CGSize(width: 36, height: 36)
            button1.position = CGPoint(x: i * 100 - 100, y: -size.halfHeight + 150)
            button1.zPosition = 100000
            addChild(button1)
        }
    }
    
    public func update() {
        if popLabelNode.text != String(Int(city!.resources[.POPULATION]!)) {
            popLabelNode.text = String(Int(city!.resources[.POPULATION]!))
        }
        
        if creditsLabelNode.text != String(Int(city!.resources[.CREDITS]!)) {
            creditsLabelNode.text = String(Int(city!.resources[.CREDITS]!))
        }
        
        if metalLabelNode.text != String(Int(city!.resources[.METAL]!)) {
            metalLabelNode.text = String(Int(city!.resources[.METAL]!))
        }
    }
    
    public func changeBorderColor(color: UIColor) {
        borderRectNode.strokeColor = color
    }
    
    public func unInit() {
        scrollView?.removeFromSuperview()
        scrollView = nil // nil out reference to deallocate properly
    }
}

class SelectedBuildingPopupNode: SKNode {
    /// At most 1 popup node is shown. When switching, 1 popup node is fading out and the other is fading in
    private var popupNode1 = SKNode()
    private var popupNode2 = SKNode()
    private var onPopupNode1 = true
    private var currentState = PopupStates.NONE
    private let size: CGSize
    
    init(size: CGSize) {
        self.size = size
        super.init()
        popupNode1.position = CGPoint(x: 0, y: 0)
        popupNode2.position = CGPoint(x: 0, y: 0)
        
        popupNode1.zPosition = 100000
        popupNode2.zPosition = 100000
        
        popupNode1.alpha = 0
        popupNode2.alpha = 0
        
        addChild(popupNode1)
        addChild(popupNode2)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func createScrollViewPopup(popupNode: SKNode, tileData: SKTilesetData) {
        popupNode.removeAllChildren()
                
        let popupBackgroundNode = SKShapeNode(rect: CGRect(center: CGPoint(x: 0, y: 0), size: CGSize(width: 250, height: size.halfHeight + 100)), cornerRadius: 10)
        popupBackgroundNode.name = "popLabelBackground"
        popupBackgroundNode.fillColor = .black
        popupBackgroundNode.alpha = 0.5
        popupBackgroundNode.position = CGPoint(x: 0, y: 0)
        popupBackgroundNode.zPosition = 10000
        
        /// The yPos the next node should be set at
        var yPos = popupBackgroundNode.frame.height / 2 - 30
        
        let titleLabelNode = SKLabelNode(fontNamed: "Montserrat-Bold")
        titleLabelNode.zPosition = 100000
        titleLabelNode.text = tileData.properties["name"]!
        titleLabelNode.fontSize = 20
        titleLabelNode.position = CGPoint(x: 0, y: yPos)
        
        yPos -= 15
        let descString = NSMutableAttributedString(string: tileData.properties["description"]!)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let range = NSRange(location: 0, length: tileData.properties["description"]!.count)
        descString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: range)
        descString.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.init(name: "Montserrat-Bold", size: 14)!], range: range)
        
        let descLabelNode = SKLabelNode(fontNamed: "Montserrat-Bold")
        descLabelNode.zPosition = 100000
        descLabelNode.numberOfLines = 0
        descLabelNode.verticalAlignmentMode = .top
        descLabelNode.preferredMaxLayoutWidth = 225
        descLabelNode.lineBreakMode = .byWordWrapping
        descLabelNode.fontSize = 14
        descLabelNode.attributedText = descString
        descLabelNode.position = CGPoint(x: 0, y: yPos)
        
        let dividerRect = CGRect(center: CGPoint(x: 0, y: 0), size: CGSize(width: popupBackgroundNode.frame.width, height: 1))
        
        // Costs
        yPos -= (descLabelNode.frame.height + 5)
        let divider1 = SKShapeNode(rect: dividerRect)
        divider1.zPosition = 100000
        divider1.position = CGPoint(x: 0, y: yPos)
        
        yPos -= 30
        let costsLabelNode = SKLabelNode(fontNamed: "Montserrat-Bold")
        costsLabelNode.zPosition = 100000
        costsLabelNode.text = "COSTS"
        costsLabelNode.fontSize = 20
        costsLabelNode.position = CGPoint(x: 0, y: yPos)
        
        /// The yPos the next node should be set at
        yPos -= 30
        ResourceTypes.allCases.forEach {
            if let cost = tileData.properties[$0.rawValue] {
                let costLabelNode = SKLabelNode(fontNamed: "Montserrat-Bold")
                costLabelNode.zPosition = 100000
                costLabelNode.text = "\($0.rawValue): \(cost)"
                costLabelNode.fontSize = 14
                costLabelNode.position = CGPoint(x: 0, y: yPos)
                yPos -= 15
                
                popupNode.addChild(costLabelNode)
            }
        }
        
        popupNode.addChild(costsLabelNode)
        popupNode.addChild(divider1)
        
        // Produces
        let divider2 = SKShapeNode(rect: dividerRect)
        divider2.zPosition = 100000
        divider2.position = CGPoint(x: 0, y: yPos)
        
        yPos -= 30
        let producesLabelNode = SKLabelNode(fontNamed: "Montserrat-Bold")
        producesLabelNode.zPosition = 100000
        producesLabelNode.text = "PRODUCES"
        producesLabelNode.fontSize = 20
        producesLabelNode.position = CGPoint(x: 0, y: yPos)
        
        yPos -= 30
        var doesProduce = false
        ResourceTypes.allCases.forEach {
            if let producesValue = tileData.properties["PRODUCES " + $0.rawValue] {
                doesProduce = true
                
                let producesLabelNode = SKLabelNode(fontNamed: "Montserrat-Bold")
                producesLabelNode.zPosition = 100000
                producesLabelNode.text = "\($0.rawValue): \(producesValue)"
                producesLabelNode.fontSize = 14
                producesLabelNode.position = CGPoint(x: 0, y: yPos)
                yPos -= 15
                
                popupNode.addChild(producesLabelNode)
            }
        }
        
        if doesProduce {
            popupNode.addChild(divider2)
            popupNode.addChild(producesLabelNode)
        } else {
            yPos = yPos + (30 + 30)
        }
        
        // Consumes
        let divider3 = SKShapeNode(rect: dividerRect)
        divider3.zPosition = 100000
        divider3.position = CGPoint(x: 0, y: yPos)
        
        yPos -= 30
        let consumesLabelNode = SKLabelNode(fontNamed: "Montserrat-Bold")
        consumesLabelNode.zPosition = 100000
        consumesLabelNode.text = "CONSUMES"
        consumesLabelNode.fontSize = 20
        consumesLabelNode.position = CGPoint(x: 0, y: yPos)
        
        yPos -= 30
        var doesConsume = false
        ResourceTypes.allCases.forEach {
            if let consumesValue = tileData.properties["CONSUMES " + $0.rawValue] {
                doesConsume = true
                
                let consumesLabelNode = SKLabelNode(fontNamed: "Montserrat-Bold")
                consumesLabelNode.zPosition = 100000
                consumesLabelNode.text = "\($0.rawValue): \(consumesValue)"
                consumesLabelNode.fontSize = 14
                consumesLabelNode.position = CGPoint(x: 0, y: yPos)
                yPos -= 15
                
                popupNode.addChild(consumesLabelNode)
            }
        }
        
        if doesConsume {
            popupNode.addChild(divider3)
            popupNode.addChild(consumesLabelNode)
        } else {
            yPos = yPos + (30 + 30)
        }
        
        popupNode.addChild(popupBackgroundNode)
        popupNode.addChild(titleLabelNode)
        popupNode.addChild(descLabelNode)
        
        popupNode.setScale(1)
        popupNode.position = CGPoint(x: size.halfWidth - 175, y: 0)
    }
    
    public func createSmallPopupNode(popupNode: SKNode, cityTile: CityTile) {
        popupNode.removeAllChildren()
        let tileData = cityTile.tile!.tileData
        
        let popupBackgroundNode = SKShapeNode(rect: CGRect(center: CGPoint(x: 0, y: 0), size: CGSize(width: 250, height: size.halfHeight + 100)), cornerRadius: 10)
        popupBackgroundNode.name = "popLabelBackground"
        popupBackgroundNode.fillColor = .black
        popupBackgroundNode.alpha = 0.5
        popupBackgroundNode.position = CGPoint(x: 0, y: 0)
        popupBackgroundNode.zPosition = 10000
        
        /// The yPos the next node should be set at
        var yPos = popupBackgroundNode.frame.height / 2 - 30
        
        let titleLabelNode = SKLabelNode(fontNamed: "Montserrat-Bold")
        titleLabelNode.zPosition = 100000
        titleLabelNode.text = tileData.properties["name"]!
        titleLabelNode.fontSize = 20
        titleLabelNode.position = CGPoint(x: 0, y: yPos)
        
        yPos -= 15
        let descString = NSMutableAttributedString(string: tileData.properties["description"]!)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let range = NSRange(location: 0, length: tileData.properties["description"]!.count)
        descString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: range)
        descString.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.init(name: "Montserrat-Bold", size: 14)!], range: range)
        
        let descLabelNode = SKLabelNode(fontNamed: "Montserrat-Bold")
        descLabelNode.zPosition = 100000
        descLabelNode.numberOfLines = 0
        descLabelNode.verticalAlignmentMode = .top
        descLabelNode.preferredMaxLayoutWidth = 225
        descLabelNode.lineBreakMode = .byWordWrapping
        descLabelNode.fontSize = 14
        descLabelNode.attributedText = descString
        descLabelNode.position = CGPoint(x: 0, y: yPos)
        
        let dividerRect = CGRect(center: CGPoint(x: 0, y: 0), size: CGSize(width: popupBackgroundNode.frame.width, height: 1))
        
        // Produces
        yPos -= (descLabelNode.frame.height + 5)
        let divider2 = SKShapeNode(rect: dividerRect)
        divider2.zPosition = 100000
        divider2.position = CGPoint(x: 0, y: yPos)
        
        yPos -= 30
        let producesLabelNode = SKLabelNode(fontNamed: "Montserrat-Bold")
        producesLabelNode.zPosition = 100000
        producesLabelNode.text = "PRODUCES"
        producesLabelNode.fontSize = 20
        producesLabelNode.position = CGPoint(x: 0, y: yPos)
        
        yPos -= 30
        var doesProduce = false
        ResourceTypes.allCases.forEach {
            if let producesValue = tileData.properties["PRODUCES " + $0.rawValue] {
                doesProduce = true
                
                let producesLabelNode = SKLabelNode(fontNamed: "Montserrat-Bold")
                producesLabelNode.zPosition = 100000
                producesLabelNode.text = "\($0.rawValue): \(producesValue)"
                producesLabelNode.fontSize = 14
                producesLabelNode.position = CGPoint(x: 0, y: yPos)
                yPos -= 15
                
                popupNode.addChild(producesLabelNode)
            }
        }
        
        if doesProduce {
            popupNode.addChild(divider2)
            popupNode.addChild(producesLabelNode)
        } else {
            yPos = yPos + (30 + 30)
        }
        
        // Consumes
        let divider3 = SKShapeNode(rect: dividerRect)
        divider3.zPosition = 100000
        divider3.position = CGPoint(x: 0, y: yPos)
        
        yPos -= 30
        let consumesLabelNode = SKLabelNode(fontNamed: "Montserrat-Bold")
        consumesLabelNode.zPosition = 100000
        consumesLabelNode.text = "CONSUMES"
        consumesLabelNode.fontSize = 20
        consumesLabelNode.position = CGPoint(x: 0, y: yPos)
        
        yPos -= 30
        var doesConsume = false
        ResourceTypes.allCases.forEach {
            if let consumesValue = tileData.properties["CONSUMES " + $0.rawValue] {
                doesConsume = true
                
                let consumesLabelNode = SKLabelNode(fontNamed: "Montserrat-Bold")
                consumesLabelNode.zPosition = 100000
                consumesLabelNode.text = "\($0.rawValue): \(consumesValue)"
                consumesLabelNode.fontSize = 14
                consumesLabelNode.position = CGPoint(x: 0, y: yPos)
                yPos -= 15
                
                popupNode.addChild(consumesLabelNode)
            }
        }
        
        if doesConsume {
            popupNode.addChild(divider3)
            popupNode.addChild(consumesLabelNode)
        } else {
            yPos = yPos + (30 + 30)
        }
        
        // Show the building's custom SKNode if it has one. Fits on this small sknode
        if let customSKNode = cityTile.building?.customSKNodeSmall() {
            yPos -= 15
            let divider4 = SKShapeNode(rect: dividerRect)
            divider4.zPosition = 100000
            divider4.position = CGPoint(x: 0, y: yPos)
            
            yPos -= 30
            let dividerCustom = SKShapeNode(rect: dividerRect)
            dividerCustom.zPosition = 100000
            dividerCustom.position = CGPoint(x: 0, y: yPos)
            
            popupNode.addChild(divider4)
            popupNode.addChild(customSKNode)
        }
        
        popupNode.addChild(popupBackgroundNode)
        popupNode.addChild(titleLabelNode)
        popupNode.addChild(descLabelNode)
        
        popupNode.setScale(1)
        popupNode.position = CGPoint(x: size.halfWidth - 175, y: 0)
    }
    
    public func createLargePopupNode(popupNode: SKNode, customSKNode: SKNode) {
        popupNode.removeAllChildren()
        
        customSKNode.zPosition = 10000
        popupNode.addChild(customSKNode)
        
        popupNode.position = CGPoint(x: 0, y: 0)
        popupNode.setScale(CGFloat.minimum(size.width / 600, size.height / 300) - 0.1)
    }
    
    
    public func setup(size: CGSize, tileData: SKTilesetData, cityTile: CityTile? = nil) {
        popupNode1.removeAllChildren()
        
        // If the building has a large sknode, show that instead. Displayed when they tap an existing building
        if let customSKNode = cityTile?.building?.customSKNodeLarge(size: size) {
            customSKNode.zPosition = 10000
            popupNode1.addChild(customSKNode)
            self.position = CGPoint(x: 0, y: 0)
            self.setScale(CGFloat.minimum(size.width / 600, size.height / 300) - 0.1)
        } else {
            let popupBackgroundNode = SKShapeNode(rect: CGRect(center: CGPoint(x: 0, y: 0), size: CGSize(width: 250, height: size.halfHeight + 100)), cornerRadius: 10)
            popupBackgroundNode.name = "popLabelBackground"
            popupBackgroundNode.fillColor = .black
            popupBackgroundNode.alpha = 0.5
            popupBackgroundNode.position = CGPoint(x: 0, y: 0)
            popupBackgroundNode.zPosition = 10000
            
            /// The yPos the next node should be set at
            var yPos = popupBackgroundNode.frame.height / 2 - 30
            
            let titleLabelNode = SKLabelNode(fontNamed: "Montserrat-Bold")
            titleLabelNode.zPosition = 100000
            titleLabelNode.text = tileData.properties["name"]!
            titleLabelNode.fontSize = 20
            titleLabelNode.position = CGPoint(x: 0, y: yPos)
            
            yPos -= 15
            let descString = NSMutableAttributedString(string: tileData.properties["description"]!)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            let range = NSRange(location: 0, length: tileData.properties["description"]!.count)
            descString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: range)
            descString.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.init(name: "Montserrat-Bold", size: 14)!], range: range)
            
            let descLabelNode = SKLabelNode(fontNamed: "Montserrat-Bold")
            descLabelNode.zPosition = 100000
            descLabelNode.numberOfLines = 0
            descLabelNode.verticalAlignmentMode = .top
            descLabelNode.preferredMaxLayoutWidth = 225
            descLabelNode.lineBreakMode = .byWordWrapping
            descLabelNode.fontSize = 14
            descLabelNode.attributedText = descString
            descLabelNode.position = CGPoint(x: 0, y: yPos)
            
            let dividerRect = CGRect(center: CGPoint(x: 0, y: 0), size: CGSize(width: popupBackgroundNode.frame.width, height: 1))
            
            // Costs, don't show if they clicked on a tile
            if cityTile == nil {
                yPos -= (descLabelNode.frame.height + 5)
                let divider1 = SKShapeNode(rect: dividerRect)
                divider1.zPosition = 100000
                divider1.position = CGPoint(x: 0, y: yPos)
                
                yPos -= 30
                let costsLabelNode = SKLabelNode(fontNamed: "Montserrat-Bold")
                costsLabelNode.zPosition = 100000
                costsLabelNode.text = "COSTS"
                costsLabelNode.fontSize = 20
                costsLabelNode.position = CGPoint(x: 0, y: yPos)
                
                /// The yPos the next node should be set at
                yPos -= 30
                ResourceTypes.allCases.forEach {
                    if let cost = tileData.properties[$0.rawValue] {
                        let costLabelNode = SKLabelNode(fontNamed: "Montserrat-Bold")
                        costLabelNode.zPosition = 100000
                        costLabelNode.text = "\($0.rawValue): \(cost)"
                        costLabelNode.fontSize = 14
                        costLabelNode.position = CGPoint(x: 0, y: yPos)
                        yPos -= 15
                        
                        popupNode1.addChild(costLabelNode)
                    }
                }
                
                popupNode1.addChild(costsLabelNode)
                popupNode1.addChild(divider1)
            } else {
                yPos -= (descLabelNode.frame.height + 5)
            }
            
            // Produces
            let divider2 = SKShapeNode(rect: dividerRect)
            divider2.zPosition = 100000
            divider2.position = CGPoint(x: 0, y: yPos)
            
            yPos -= 30
            let producesLabelNode = SKLabelNode(fontNamed: "Montserrat-Bold")
            producesLabelNode.zPosition = 100000
            producesLabelNode.text = "PRODUCES"
            producesLabelNode.fontSize = 20
            producesLabelNode.position = CGPoint(x: 0, y: yPos)
            
            yPos -= 30
            var doesProduce = false
            ResourceTypes.allCases.forEach {
                if let producesValue = tileData.properties["PRODUCES " + $0.rawValue] {
                    doesProduce = true
                    
                    let producesLabelNode = SKLabelNode(fontNamed: "Montserrat-Bold")
                    producesLabelNode.zPosition = 100000
                    producesLabelNode.text = "\($0.rawValue): \(producesValue)"
                    producesLabelNode.fontSize = 14
                    producesLabelNode.position = CGPoint(x: 0, y: yPos)
                    yPos -= 15
                    
                    popupNode1.addChild(producesLabelNode)
                }
            }
            
            if doesProduce {
                popupNode1.addChild(divider2)
                popupNode1.addChild(producesLabelNode)
            } else {
                yPos = yPos + (30 + 30)
            }
            
            // Consumes
            let divider3 = SKShapeNode(rect: dividerRect)
            divider3.zPosition = 100000
            divider3.position = CGPoint(x: 0, y: yPos)
            
            yPos -= 30
            let consumesLabelNode = SKLabelNode(fontNamed: "Montserrat-Bold")
            consumesLabelNode.zPosition = 100000
            consumesLabelNode.text = "CONSUMES"
            consumesLabelNode.fontSize = 20
            consumesLabelNode.position = CGPoint(x: 0, y: yPos)
            
            yPos -= 30
            var doesConsume = false
            ResourceTypes.allCases.forEach {
                if let consumesValue = tileData.properties["CONSUMES " + $0.rawValue] {
                    doesConsume = true
                    
                    let consumesLabelNode = SKLabelNode(fontNamed: "Montserrat-Bold")
                    consumesLabelNode.zPosition = 100000
                    consumesLabelNode.text = "\($0.rawValue): \(consumesValue)"
                    consumesLabelNode.fontSize = 14
                    consumesLabelNode.position = CGPoint(x: 0, y: yPos)
                    yPos -= 15
                    
                    popupNode1.addChild(consumesLabelNode)
                }
            }
            
            if doesConsume {
                popupNode1.addChild(divider3)
                popupNode1.addChild(consumesLabelNode)
            } else {
                yPos = yPos + (30 + 30)
            }
            
            // Show the building's custom SKNode if it has one. Fits on this small sknode
            if let customSKNode = cityTile?.building?.customSKNodeSmall() {
                yPos -= 15
                let divider4 = SKShapeNode(rect: dividerRect)
                divider4.zPosition = 100000
                divider4.position = CGPoint(x: 0, y: yPos)
                
                yPos -= 30
                let dividerCustom = SKShapeNode(rect: dividerRect)
                dividerCustom.zPosition = 100000
                dividerCustom.position = CGPoint(x: 0, y: yPos)
                
                popupNode1.addChild(divider4)
                popupNode1.addChild(customSKNode)
            }
            
            popupNode1.addChild(popupBackgroundNode)
            popupNode1.addChild(titleLabelNode)
            popupNode1.addChild(descLabelNode)
            //self.setScale(1)
            //self.position = CGPoint(x: size.halfWidth - 175, y: 0)
        }
        popupNode1.alpha = 0
        
        if popupNode1.parent == nil {
            addChild(popupNode1)
        }
    }
    
    
    public func changeStateToNone() {
        currentState = .NONE
        
        // Fades out the currently selected popup node
        let fadeOut = SKAction.fadeOut(withDuration: 0.5)
        if onPopupNode1 {
            popupNode1.run(fadeOut)
        } else {
            popupNode2.run(fadeOut)
        }
    }
    
    public func changeStateToScrollView(tileData: SKTilesetData) {
        currentState = .SCROLLVIEW
        
        // Fades out the currently selected popup node
        let fadeOut = SKAction.fadeOut(withDuration: 0.5)
        if onPopupNode1 {
            popupNode1.run(fadeOut)
        } else {
            popupNode2.run(fadeOut)
        }
        
        let fadeIn = SKAction.fadeIn(withDuration: 0.5)
        // Fades in the new popup node by switching the current node
        onPopupNode1.toggle()
        
        if onPopupNode1 {
            createScrollViewPopup(popupNode: popupNode1, tileData: tileData)
            popupNode1.run(fadeIn)
        } else {
            createScrollViewPopup(popupNode: popupNode2, tileData: tileData)
            popupNode2.run(fadeIn)
        }
    }
    
    public func changeStateToPopup(cityTile: CityTile) {
        // Fades out the currently selected popup node
        let fadeOut = SKAction.fadeOut(withDuration: 0.5)
        if onPopupNode1 {
            popupNode1.run(fadeOut)
        } else {
            popupNode2.run(fadeOut)
        }
        
        let fadeIn = SKAction.fadeIn(withDuration: 0.5)
        // Fades in the new popup node by switching the current node
        onPopupNode1.toggle()
        var currentPopupNode = popupNode1
        if !onPopupNode1 {
            currentPopupNode = popupNode2
        }
        
        if let customSKNode = cityTile.building?.customSKNodeLarge(size: size) {
            currentState = .LARGEPOPUP
            createLargePopupNode(popupNode: currentPopupNode, customSKNode: customSKNode)
        } else {
            currentState = .SMALLPOPUP
            createSmallPopupNode(popupNode: currentPopupNode, cityTile: cityTile)
        }
        currentPopupNode.run(fadeIn)
    }
}


enum PopupStates: String {
    /// Default | Building in scrollview | building that exists
    case NONE, SCROLLVIEW, SMALLPOPUP, LARGEPOPUP
}
