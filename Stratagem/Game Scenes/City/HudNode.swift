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
    
    public var selectedBuildingScrollViewPopupNode = SelectedBuildingScrollViewPopupNode()
    
    // Building selecter scroll view
    var scrollView: SwiftySKScrollView?
    let moveableNode = SKNode()

    private var size: CGSize = CGSize(width: 0, height: 0)
    private weak var city: City?
    
    public func setup(city: City, size: CGSize, view: UIView, tilemap: SKTilemap) {
        self.city = city
        self.size = size
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
        
        selectedBuildingScrollViewPopupNode.position = CGPoint(x: size.halfWidth - 175, y: 0)
        selectedBuildingScrollViewPopupNode.zPosition = 100000
        
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
            
            addChild(selectedBuildingScrollViewPopupNode)
        }
    }
    
    public func noneState() {
        changeBorderColor(color: .clear)
        
        moveableNode.isHidden = true
        scrollView?.removeFromSuperview()
        scrollView = nil // nil out reference to deallocate properly
        selectedBuildingScrollViewPopupNode.hidePopup()
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

class SelectedBuildingScrollViewPopupNode: SKNode {
    private var popupNode = SKNode()
    
    public func setup(size: CGSize, tileData: SKTilesetData, cityTile: CityTile? = nil) {
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
                    
                    popupNode.addChild(costLabelNode)
                }
            }
            
            popupNode.addChild(costsLabelNode)
            popupNode.addChild(divider1)
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
        
        // Show the building's custom SKNode if it has one
        if let customSKNode = cityTile?.building?.customSKNode() {
            yPos -= 15
            let dividerCustom = SKShapeNode(rect: dividerRect)
            dividerCustom.zPosition = 100000
            dividerCustom.position = CGPoint(x: 0, y: yPos)
            
            yPos -= 30
            popupNode.addChild(customSKNode)
        }
        
        popupNode.addChild(popupBackgroundNode)
        popupNode.addChild(titleLabelNode)
        popupNode.addChild(descLabelNode)
        popupNode.alpha = 0
        
        if popupNode.parent == nil {
            addChild(popupNode)
        }
    }
    
    public func showPopup(size: CGSize, tileData: SKTilesetData, cityTile: CityTile? = nil) {
        setup(size: size, tileData: tileData, cityTile: cityTile)
        let fadeIn = SKAction.fadeIn(withDuration: 0.5)
        popupNode.run(fadeIn)
    }
    
    public func hidePopup() {
        let fadeOut = SKAction.fadeOut(withDuration: 0.5)
        popupNode.run(fadeOut)
    }
}
