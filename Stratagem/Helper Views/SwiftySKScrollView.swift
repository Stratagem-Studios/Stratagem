//    The MIT License (MIT)
//
//    Copyright (c) 2016-2020 Dominik Ringler
//
//    Permission is hereby granted, free of charge, to any person obtaining a copy
//    of this software and associated documentation files (the "Software"), to deal
//    in the Software without restriction, including without limitation the rights
//    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//    copies of the Software, and to permit persons to whom the Software is
//    furnished to do so, subject to the following conditions:
//
//    The above copyright notice and this permission notice shall be included in all
//    copies or substantial portions of the Software.
//
//    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//    SOFTWARE.

import SpriteKit

/**
 SwiftySKScrollView
 
 A custom subclass of UIScrollView to add to your SpriteKit scenes.
 */
public class SwiftySKScrollView: UIScrollView {
    
    // MARK: - Properties
    
    /// SwiftySKScrollView direction
    public enum ScrollDirection {
        case vertical
        case horizontal
    }
    
    /// SwiftySKScrollView direction
    public enum ScrollIndicatorPosition {
        case top
        case bottom
    }
    
    /// Disable status
    public var isDisabled = false {
        didSet {
            isUserInteractionEnabled = !isDisabled
        }
    }
    
    /// Moveable node
    private let moveableNode: SKNode
    
    private weak var hudNode: HudNode?
    
    /// Scroll direction
    private let direction: ScrollDirection
    
    /// Scroll indicator position
    private let indicatorPosition: ScrollIndicatorPosition
    
    /// Nodes touched. This will forward touches to node subclasses.
    private var touchedNodes = [AnyObject]()
    
    /// Current scene reference
    private weak var currentScene: SKScene?
    
    // MARK: - Init
    
    /// Init
    ///
    /// - parameter frame: The frame of the scroll view
    /// - parameter moveableNode: The moveable node that will contain all the sprites to be moved by the scrollview
    /// - parameter scrollDirection: The scroll direction of the scrollView.
    init(frame: CGRect, moveableNode: SKNode, direction: ScrollDirection, indicatorPosition: ScrollIndicatorPosition = .bottom, hudNode: HudNode, size: CGSize) {
        self.moveableNode = moveableNode
        self.direction = direction
        self.indicatorPosition = indicatorPosition
        self.hudNode = hudNode
        super.init(frame: frame)
        
        if let scene = moveableNode.scene {
            self.currentScene = scene
        }

        backgroundColor = .clear
        self.frame = frame
        delegate = self
        indicatorStyle = .white
        isScrollEnabled = true
        
        // MARK: - Fix wrong indicator positon in MenuScene
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        
        guard direction == .horizontal else { return }
        transform = CGAffineTransform(scaleX: -1, y: indicatorPosition == .bottom ? 1 : -1)
        
        // Add boxes around page selector
        let buildingTypes = ["road", "residential", "industrial", "military"]
        
        for (i, buildingType) in buildingTypes.enumerated() {
            let selectedBorderRect = SKShapeNode(rect: CGRect(x: -20, y: -20, width: 40, height: 40), cornerRadius: 5)
            selectedBorderRect.name = "RECT \(buildingType)"
            selectedBorderRect.zPosition = 100000 - 1
            selectedBorderRect.position = CGPoint(x: i * 100 - 100, y: Int(-size.halfHeight) + 150)
            selectedBorderRect.alpha = 0
            
            hudNode.addChild(selectedBorderRect)
        }
    }
    
    deinit {
        let buildingTypes = ["road", "residential", "industrial", "military"]
        
        for buildingType in buildingTypes {
            if let hudNode = hudNode {
                let nodeRect = hudNode.childNode(withName: "RECT \(buildingType)")
                nodeRect?.removeFromParent()
                
                let nodeButton = hudNode.childNode(withName: "BUTTON \(buildingType)")
                nodeButton?.removeFromParent()
            }
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var prevBuildingType: String?
    
    /// Given a buildingType, turns on border for that and turns off border for previous
    public func activateBorderButton(buildingType: String) {
        if let hudNode = hudNode {
            if let prevBuildingType = prevBuildingType {
                if prevBuildingType != buildingType {
                    let fadeIn = SKAction.fadeIn(withDuration: 0.5)
                    hudNode.childNode(withName: "RECT \(buildingType)")!.run(fadeIn)
                    
                    let fadeOut = SKAction.fadeOut(withDuration: 0.5)
                    hudNode.childNode(withName: "RECT \(prevBuildingType)")!.run(fadeOut)
                    
                    self.prevBuildingType = buildingType
                }
            } else {
                let fadeIn = SKAction.fadeIn(withDuration: 0.5)
                hudNode.childNode(withName: "RECT \(buildingType)")!.run(fadeIn)
                
                prevBuildingType = buildingType
            }
        }
    }
}
    
// MARK: - Touches

extension SwiftySKScrollView {
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard !isDisabled else { return }
        super.touchesBegan(touches, with: event)
        
        guard let currentScene = currentScene else { return }
        
        for touch in touches {
            let location = touch.location(in: currentScene)
        
            currentScene.touchesBegan(touches, with: event)
            touchedNodes = currentScene.nodes(at: location)
            for node in touchedNodes {
                node.touchesBegan(touches, with: event)
            }
        }
    }
    
    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard !isDisabled else { return }
        super.touchesMoved(touches, with: event)
        
        guard let currentScene = currentScene else { return }
        
        for touch in touches {
            let location = touch.location(in: currentScene)
        
            currentScene.touchesMoved(touches, with: event)
            touchedNodes = currentScene.nodes(at: location)
            for node in touchedNodes {
                node.touchesMoved(touches, with: event)
            }
        }
    }
    
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard !isDisabled else { return }
        super.touchesEnded(touches, with: event)
        
        guard let currentScene = currentScene else { return }
        
        for touch in touches {
            let location = touch.location(in: currentScene)
            
            currentScene.touchesEnded(touches, with: event)
            touchedNodes = currentScene.nodes(at: location)
            for node in touchedNodes {
                node.touchesEnded(touches, with: event)
            }
        }
    }
    
    override public func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard !isDisabled else { return }
        super.touchesCancelled(touches, with: event)
        
        guard let currentScene = currentScene else { return }
        
        for touch in touches {
            let location = touch.location(in: currentScene)
        
            currentScene.touchesCancelled(touches, with: event)
            touchedNodes = currentScene.nodes(at: location)
            for node in touchedNodes {
                node.touchesCancelled(touches, with: event)
            }
        }
    }
}

// MARK: - Scroll View Delegate

extension SwiftySKScrollView: UIScrollViewDelegate {
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if direction == .horizontal {
            moveableNode.position.x = scrollView.contentOffset.x
        } else {
            moveableNode.position.y = scrollView.contentOffset.y
        }

        if scrollView.contentOffset.x >= frame.width * 3 {
            activateBorderButton(buildingType: "road")
        } else if scrollView.contentOffset.x >= frame.width * 2 {
            activateBorderButton(buildingType: "residential")
        } else if scrollView.contentOffset.x >= frame.width * 1 {
            activateBorderButton(buildingType: "industrial")
        } else if scrollView.contentOffset.x >= frame.width * 0 {
            activateBorderButton(buildingType: "military")
        }
    }
}
