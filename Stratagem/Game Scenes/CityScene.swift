import SpriteKit
import SKTiled


public class CityScene: SKTiledScene {
    public override func didMove(to view: SKView) {
        let city = City()
        city.initCity(cityName: "hi")

        super.didMove(to: view)
        super.setup(tmxFile: "City")
        cameraNode.allowGestures = true
    }
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let tilemap = tilemap else { return }
        
        for touch in touches {
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
                    let coordStr = "Coord: \(locationInMap)"
                    print(currentTile)
                    
                    //updateTileInfo(msg: coordStr)
                    
                    // tile properties output
                    //let propertiesInfoString = currentTile.tileData.description
                    //updatePropertiesInfo(msg: propertiesInfoString)
                }
                
                
                if let currentObject = currentObject {
                    //                    if let object = currentObject.reference {
                    //                        NotificationCenter.default.post(
                    //                            name: Notification.Name.Demo.ObjectUnderCursor,
                    //                            object: object,
                    //                            userInfo: nil
                    //                        )
                    //                    }
                }
            }
        }
    }
}
