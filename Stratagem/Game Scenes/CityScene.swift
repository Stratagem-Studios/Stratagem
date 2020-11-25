import SpriteKit
import SKTiled


public class CityScene: SKTiledScene {
    public override func didMove(to view: SKView) {
        let city = City()
        city.initCity(cityName: "hi")
        
        super.didMove(to: view)
        super.setup(tmxFile: "City")
        cameraNode.allowGestures = true
        cameraNode.setCameraZoom(0.2)
        cameraNode.setZoomConstraints(minimum: 0.175, maximum: 0.3)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(sceneTapped(_:)))
        self.view!.addGestureRecognizer(tapGestureRecognizer)
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(scenePan(_:)))
        self.view!.addGestureRecognizer(panGestureRecognizer)
    }
    
    /// Called only when user single taps
    @objc public func sceneTapped(_ recognizer: UITapGestureRecognizer) {
        if recognizer.state == UIGestureRecognizer.State.ended {
            let loc = recognizer.location(in: recognizer.view)
            print(getTappedTile(loc))
        }
    }
    
    /// Called only when user pans
    @objc public func scenePan(_ recognizer: UIPanGestureRecognizer) {
        cameraNode.cameraPanned(recognizer)
    }
    
    /// Can return a tile or a tile object
    private func getTappedTile(_ touchLoc: CGPoint) -> Any {
        guard let tilemap = tilemap else { return -1 }
        
        let locationInMap = tilemap.convert(self.convertPoint(fromView: touchLoc), from: cameraNode)
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
                        let coordWRTTile = tile.convert(self.convertPoint(fromView: touchLoc), from: cameraNode)
                        
                        
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
                            let coordWRTTile = proxy.reference!.convert(self.convertPoint(fromView: touchLoc), from: cameraNode)
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
                        let coordWRTTile = proxy.reference!.convert(self.convertPoint(fromView: touchLoc), from: cameraNode)
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

