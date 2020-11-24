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
}

enum CityEditStates : String {
    case NONE, BUILD, DESTROY
}

