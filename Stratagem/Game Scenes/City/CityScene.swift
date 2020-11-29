import SpriteKit
import SKTiled


public class CityScene: SKTiledScene {
    private var city = City()
    private var cityEditState = CityEditStates.NONE
    
    private let hudNode = HudNode()
    
    public override func didMove(to view: SKView) {
        print("hi")
        city.initCity(cityName: "City Name")
        
        super.didMove(to: view)
        super.setup(tmxFile: "City")
        cameraNode.allowGestures = true
        cameraNode.setCameraZoom(0.4)
        cameraNode.setZoomConstraints(minimum: 0.4, maximum: 0.75)
        cameraNode.showOverlay = true
        
        city.loadTilemap(tilemap)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(sceneTapped(_:)))
        self.view!.addGestureRecognizer(tapGestureRecognizer)
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(scenePan(_:)))
        self.view!.addGestureRecognizer(panGestureRecognizer)
        
        view.showsFPS = true
        view.showsDrawCount = true
        
        hudNode.setup(city: city, size: size)
        cameraNode.addToOverlay(hudNode)
    }
    
    /// Called only when user single taps
    @objc public func sceneTapped(_ recognizer: UITapGestureRecognizer) {
        if recognizer.state == UIGestureRecognizer.State.ended {
            let loc = recognizer.location(in: recognizer.view)
            let coordWRTHUD = hudNode.convert(self.convertPoint(fromView: loc), from: self)
            let tappedHudNodes = hudNode.nodes(at: coordWRTHUD)
            
            var clickedOnHud = false
            if tappedHudNodes.count > 0 {
                switch tappedHudNodes[0].name {
                case "buildButtonNode":
                    if cityEditState != CityEditStates.BUILD {
                        changeStateToBuild()
                    } else {
                       changeStateToNone()
                    }
                    clickedOnHud = true
                case "destroyButtonNode":
                    if cityEditState != CityEditStates.DESTROY {
                        changeStateToDestroy()
                    } else {
                        changeStateToNone()
                    }
                    clickedOnHud = true
                    
                default:
                    clickedOnHud = false
                }
            }
            if !clickedOnHud {
                let tile = getTappedTile(loc)
                if let tile = tile as? SKTile {
                    switch cityEditState {
                    case .NONE:
                        print(tile)
                    case .BUILD:
                        city.changeTileAtLoc(firstTile: tile, secondTileID: 8)
                    case .DESTROY:
                        city.changeTileAtLoc(firstTile: tile, secondTileID: 1)
                    }
                }
            }
        }
    }
    
    private func changeStateToNone() {
        cityEditState = CityEditStates.NONE
        hudNode.changeBorderColor(color: .clear)
        highlightUneditableTiles(colorBlendFactor: 0)
    }
    
    private func changeStateToBuild() {
        cityEditState = CityEditStates.BUILD
        hudNode.changeBorderColor(color: .green)
        highlightUneditableTiles(colorBlendFactor: 0.25)
    }
    
    private func changeStateToDestroy() {
        cityEditState = CityEditStates.DESTROY
        hudNode.changeBorderColor(color: .red)
        highlightUneditableTiles(colorBlendFactor: 0.25)
    }
    
    /// Called only when user pans
    @objc public func scenePan(_ recognizer: UIPanGestureRecognizer) {
        cameraNode.cameraPanned(recognizer)
    }
    
    private func highlightUneditableTiles(colorBlendFactor: CGFloat) {
        for cityTile in city.cityTerrain!.joined() {
            if !cityTile.isEditable! {
                let tile = cityTile.tile
                let action = SKAction.colorize(with: .black, colorBlendFactor: colorBlendFactor, duration: 1)
                tile!.run(action)
            }
        }
    }
    
    /// Can return a tile or a tile object
    private func getTappedTile(_ touchLoc: CGPoint) -> Any? {
        guard let tilemap = tilemap else { return nil }
        var locationInMap = self.convertPoint(fromView: touchLoc)
        locationInMap = tilemap.convert(locationInMap, from: self)
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
                        let coordWRTTile = tile.convert(locationInMap, from: tilemap)
                        
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
                            let coordWRTTile = proxy.reference!.convert(locationInMap, from: tilemap)
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
                        let coordWRTTile = proxy.reference!.convert(locationInMap, from: tilemap)
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
        return nil
    }
}

enum CityEditStates : String {
    case NONE, BUILD, DESTROY
}

