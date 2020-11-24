import SpriteKit
import SKTiled


public class CityScene: SKTiledScene {
    private var uiTouches: [(CGPoint, UITouch, Double)] = []
    private var tapGestureRecognizers: [(CGPoint, UITapGestureRecognizer, Double)] = []
    
    public override func didMove(to view: SKView) {
        let city = City()
        city.initCity(cityName: "hi")
        
        super.didMove(to: view)
        super.setup(tmxFile: "City")
        cameraNode.allowGestures = true
        cameraNode.setCameraZoom(0.2)
        cameraNode.setZoomConstraints(minimum: 0.175, maximum: 0.3)
        //cameraNode.setCameraBounds(bounds: CGRect(x: 0, y: 0, width: 300, height: 100))
        //cameraNode.constraints = getCameraConstraints()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(sceneTapped(_:)))
        self.view!.addGestureRecognizer(tapGestureRecognizer)
    }
    
    /// Called when user single taps. All logic goes here.
    private func userTapped(_ touch: UITouch) {
        print(getTappedTile(touch))
    }
    
    /// Called only when user single taps
    @objc public func sceneTapped(_ recognizer: UITapGestureRecognizer) {
        if recognizer.state == UIGestureRecognizer.State.ended {
            let loc = recognizer.location(in: recognizer.view)
            
            // Remove out of date UITouches
            var foundUITouch: UITouch?
            for i in (0..<uiTouches.count).reversed() {
                let tuple = uiTouches[i]
                
                // Greater than 0.25 seconds elapsed
                if CACurrentMediaTime() - tuple.2 > 0.25 {
                    uiTouches.remove(at: i)
                } else if tuple.0 == loc {
                    // Hit
                    foundUITouch = tuple.1
                }
            }
            if let foundUITouch = foundUITouch {
                userTapped(foundUITouch)
            } else {
                tapGestureRecognizers.append((loc, recognizer, CACurrentMediaTime()))
            }
        }
    }
    
    /// Called on any touch event
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let loc = touch.location(in: touch.view)
            
            // Remove out of date recognizers
            var foundRecog = false
            for i in (0..<tapGestureRecognizers.count).reversed() {
                let tuple = tapGestureRecognizers[i]
                
                // Greater than 0.25 seconds elapsed
                if CACurrentMediaTime() - tuple.2 > 0.25 {
                    tapGestureRecognizers.remove(at: i)
                } else if tuple.0 == loc {
                    // Hit
                    foundRecog = true
                    break
                }
            }
            if foundRecog {
                userTapped(touch)
            } else {
                uiTouches.append((loc, touch, CACurrentMediaTime()))
            }
        }
    }
    
    /// Can return a tile or a tile object
    private func getTappedTile(_ touch: UITouch) -> Any {
        guard let tilemap = tilemap else { return -1 }
        
        let locationInMap = touch.location(in: tilemap)
        let nodesUnderCursor = tilemap.nodes(at: locationInMap)
        
        let focusObjects = nodesUnderCursor.filter { node in
            (node as? SKTiledGeometry != nil)
        }
        
        if !focusObjects.isEmpty {
            var currentTile: SKTile?
            var currentObject: TileObjectProxy?
            
            for object in focusObjects {
                
                if let tile = object as? SKTile {
                    if tile.visibleToCamera {
                        // Transform: origin is in the bottom left, upper right is +x,+y
                        let coordWRTTile = touch.location(in: tile)
                        
                        
                        var x: Int
                        var y: Int
                        if tile.getVertices().count > 0 {
                            x = abs(Int((coordWRTTile.x + tile.getVertices()[2].x).rounded()))
                            y = abs(Int((coordWRTTile.y + tile.getVertices()[1].y).rounded()))
                        } else {
                            x = abs(Int(coordWRTTile.x + tile.bounds.width / 2))
                            y = abs(Int(coordWRTTile.y + tile.bounds.width / 2))
                        }
                        
                        if 0 <= x && x < Int(tile.tileSize.width.rounded()) && 0 <= y && y < Int(tile.tileSize.height.rounded()) {
                            if tile.getAlphaBitmask()[x][y] == 1 {
                                currentTile = tile
                                break
                            }
                        }
                    }
                }
                
                if let obj = object as? SKTileObject {
                    if let proxy = obj.proxy {
                        if proxy.visibleToCamera && (currentObject == nil) {
                            let coordWRTTile = touch.location(in: proxy.reference!)
                            let x = Int((coordWRTTile.x + proxy.reference!.size.width / 2).rounded())
                            let y = Int((coordWRTTile.y + proxy.reference!.size.height / 2).rounded())
                            
                            if 0 <= x && x < Int(proxy.reference!.size.width.rounded()) && 0 <= y && y < Int(proxy.reference!.size.height.rounded()) {
                                if proxy.reference!.getAlphaBitmask()[x][y] == 1 {
                                    currentObject = proxy
                                    break
                                }
                            }
                            
                        }
                    }
                }
                
                
                if let proxy = object as? TileObjectProxy {
                    if proxy.visibleToCamera {
                        let coordWRTTile = touch.location(in: proxy.reference!)
                        let x = Int((coordWRTTile.x + proxy.reference!.size.width / 2).rounded())
                        let y = Int((coordWRTTile.y + proxy.reference!.size.height / 2).rounded())
                        
                        if 0 <= x && x < Int(proxy.reference!.size.width.rounded()) && 0 <= y && y < Int(proxy.reference!.size.height.rounded()) {
                            if proxy.reference!.getAlphaBitmask()[x][y] == 1 {
                                currentObject = proxy
                            }
                        }
                    }
                }
            }
            
            if let currentTile = currentTile {
                return currentTile
            }
            
            
            if let currentObject = currentObject {
                return currentObject
            }
        }
        return -1
    }
    
    private func getCameraConstraints() -> [SKConstraint] {
        /*
            Also constrain the camera to avoid it moving to the very edges of the scene.
            First, work out the scaled size of the scene. Its scaled height will always be
            the original height of the scene, but its scaled width will vary based on
            the window's current aspect ratio.
        */
        let scaledSize = CGSize(width: size.width * cameraNode.xScale, height: size.height * cameraNode.yScale)

        /*
            Find the root "board" node in the scene (the container node for
            the level's background tiles).
        */
        //let boardNode = childNode(withName: WorldLayer.board.nodePath)!
        let boardNode = tilemap
        
        /*
            Calculate the accumulated frame of this node.
            The accumulated frame of a node is the outer bounds of all of the node's
            child nodes, i.e. the total size of the entire contents of the node.
            This gives us the bounding rectangle for the level's environment.
        */
        //let boardContentRect = boardNode.calculateAccumulatedFrame()
        let boardContentRect = tilemap.calculateAccumulatedFrame()

        /*
            Work out how far within this rectangle to constrain the camera.
            We want to stop the camera when we get within 100pts of the edge of the screen,
            unless the level is so small that this inset would be outside of the level.
        */
        let xInset = min((scaledSize.width / 2) - 100.0, boardContentRect.width / 2)
        let yInset = min((scaledSize.height / 2) - 100.0, boardContentRect.height / 2)

        // Use these insets to create a smaller inset rectangle within which the camera must stay.
        let insetContentRect = boardContentRect.insetBy(dx: xInset, dy: yInset)

        // Define an `SKRange` for each of the x and y axes to stay within the inset rectangle.
        let xRange = SKRange(lowerLimit: insetContentRect.minX, upperLimit: insetContentRect.maxX)
        let yRange = SKRange(lowerLimit: insetContentRect.minY, upperLimit: insetContentRect.maxY)

        // Constrain the camera within the inset rectangle.
        let levelEdgeConstraint = SKConstraint.positionX(xRange, y: yRange)
        levelEdgeConstraint.referenceNode = boardNode
        return [levelEdgeConstraint]
    }
}

enum CityEditStates : String {
    case NONE, BUILD, DESTROY
}

