import SpriteKit
import SKTiled
import SwiftUI


public class CityScene: SKTiledScene {
    private weak var city: City?
    private var cityEditState = CityEditStates.NONE
    weak var playerVariables = Global.playerVariables
    
    private var hudNode = HudNode()
    
    private var buildSelectedNode: SKNode?
    private var buildSelectedTiledata: SKTilesetData?
    private var selectedCityTile: CityTile?
    
    public override func didMove(to view: SKView) {
        city = Global.gameVars!.selectedCity!
        city!.createTMXFile()
        
        super.didMove(to: view)
        super.setup(tmxFile: "City")
        cameraNode.allowGestures = true
        cameraNode.setCameraZoom(0.4)
        cameraNode.setZoomConstraints(minimum: 0.3, maximum: 0.75)
        cameraNode.showOverlay = true
        
        city!.loadTilemap(tilemap)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(sceneTapped(_:)))
        self.view!.addGestureRecognizer(tapGestureRecognizer)
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(scenePan(_:)))
        self.view!.addGestureRecognizer(panGestureRecognizer)
        
        view.showsFPS = true
        view.showsDrawCount = true
        
        hudNode.setup(city: city!, size: size, view: view, tilemap: tilemap)
        cameraNode.addToOverlay(hudNode)
        city!.hudNode = hudNode
        
        changeStateToNone()
        
        // Updates HUD every 1 sec
        let wait = SKAction.wait(forDuration: 0.5)
        let update = SKAction.run({ [self] in
            hudNode.update()
        })
        let seq = SKAction.sequence([update, wait])
        let repeatActions = SKAction.repeatForever(seq)
        run(repeatActions)
    }
    
    public override func willMove(from view: SKView) {
        hudNode.unInit()
        self.removeAllActions()
    }
    
    /// Called only when user single taps
    @objc public func sceneTapped(_ recognizer: UITapGestureRecognizer) {
        if recognizer.state == UIGestureRecognizer.State.ended {
            let loc = recognizer.location(in: recognizer.view)
            let coordWRTHUD = hudNode.convert(self.convertPoint(fromView: loc), from: self)
            let tappedHudNodes = hudNode.nodes(at: coordWRTHUD)
            
            var clickedOnHud = false
            for tappedHudNode in tappedHudNodes {
                switch tappedHudNode.name {
                case "cityNameBackgroundNode":
                    playerVariables!.currentGameViewLevel = GameViewLevel.PLANET
                    clickedOnHud = true
                case "buildButtonNode":
                    if cityEditState != CityEditStates.BUILD {
                        changeStateToNone()
                        changeStateToBuild()
                    } else {
                        changeStateToNone()
                    }
                    clickedOnHud = true
                case "destroyButtonNode":
                    if cityEditState != CityEditStates.DESTROY {
                        changeStateToNone()
                        changeStateToDestroy()
                    } else {
                        changeStateToNone()
                    }
                    clickedOnHud = true
                default:
                    if cityEditState == .BUILD {
                        if let tappedHudNodeName = tappedHudNode.name {
                            switch tappedHudNodeName {
                            case "BUTTON road":
                                hudNode.scrollView!.setContentOffset(CGPoint(x: 0 + hudNode.scrollView!.frame.width * 3, y: 0), animated: true)
                                clickedOnHud = true
                            case "BUTTON residential":
                                hudNode.scrollView!.setContentOffset(CGPoint(x: 0 + hudNode.scrollView!.frame.width * 2, y: 0), animated: true)
                                clickedOnHud = true
                            case "BUTTON industrial":
                                hudNode.scrollView!.setContentOffset(CGPoint(x: 0 + hudNode.scrollView!.frame.width * 1, y: 0), animated: true)
                                clickedOnHud = true
                            case "BUTTON military":
                                hudNode.scrollView!.setContentOffset(CGPoint(x: 0 + hudNode.scrollView!.frame.width * 0, y: 0), animated: true)
                                clickedOnHud = true
                            default:
                                if tappedHudNodeName.contains("BUTTON_BUILDING_POPUP") {
                                    selectedCityTile?.building?.userTouchedButton(button: tappedHudNode)
                                    clickedOnHud = true
                                } else {
                                    // Build selector
                                    let tiles = tilemap.tilesets.first!.getTileData(named: tappedHudNodeName)
                                    if tiles.count > 0 {
                                        // Toggle
                                        if let buildSelectedNode = buildSelectedNode {
                                            buildSelectedNode.removeAllChildren()
                                            self.buildSelectedNode = nil
                                            self.buildSelectedTiledata = nil
                                            hudNode.selectedBuildingScrollViewPopupNode.hidePopup()
                                            
                                            if buildSelectedNode.name != tappedHudNodeName {
                                                let selectedBorderRect = SKShapeNode(rect: CGRect(x: -25, y: -50, width: 50, height: 100), cornerRadius: 5)
                                                tappedHudNode.addChild(selectedBorderRect)
                                                self.buildSelectedNode = tappedHudNode
                                                buildSelectedTiledata = tiles[0]
                                                
                                                hudNode.selectedBuildingScrollViewPopupNode.showPopup(size: size, tileData: buildSelectedTiledata!)
                                            }
                                        } else {
                                            let selectedBorderRect = SKShapeNode(rect: CGRect(x: -25, y: -50, width: 50, height: 100), cornerRadius: 5)
                                            tappedHudNode.addChild(selectedBorderRect)
                                            buildSelectedNode = tappedHudNode
                                            buildSelectedTiledata = tiles[0]
                                            
                                            hudNode.selectedBuildingScrollViewPopupNode.showPopup(size: size, tileData: buildSelectedTiledata!)
                                        }
                                        clickedOnHud = true
                                    }
                                }
                            }
                        }
                    }
                    break
                }
                
                if clickedOnHud {
                    break
                }
            }
            if !clickedOnHud {
                let tile = getTappedTile(loc)
                if let tile = tile as? SKTile {
                    switch cityEditState {
                    case .NONE:
                        // Show building info popup
                        if tile.tileData.properties["type"] != "ground" {
                            let cityTile = city!.cityTerrain[Int(tile.tileCoord!.x)][Int(tile.tileCoord!.y)]
                            
                            hudNode.selectedBuildingScrollViewPopupNode.showPopup(size: size, tileData: tile.tileData, cityTile: cityTile)
                            selectedCityTile = cityTile
                        } else {
                            hudNode.selectedBuildingScrollViewPopupNode.hidePopup()
                            selectedCityTile = nil
                        }
                    case .BUILD:
                        if let buildSelectedTiledata = buildSelectedTiledata {
                            city!.changeTileAtLoc(firstTile: tile, secondTileID: buildSelectedTiledata.globalID)
                        }
                    case .DESTROY:
                        city!.changeTileAtLoc(firstTile: tile, secondTileID: 1)
                    }
                }
            }
        }
    }
    
    private func changeStateToNone() {
        buildSelectedNode?.removeAllChildren()
        buildSelectedNode = nil
        buildSelectedTiledata = nil
        
        cityEditState = CityEditStates.NONE
        hudNode.noneState()
        highlightUneditableTiles(colorBlendFactor: 0)
    }
    
    private func changeStateToBuild() {
        cityEditState = CityEditStates.BUILD
        hudNode.buildState(view: view!, tilemap: tilemap)
        highlightUneditableTiles(colorBlendFactor: 0.25)
    }
    
    private func changeStateToDestroy() {
        cityEditState = CityEditStates.DESTROY
        hudNode.destroyState()
        highlightUneditableTiles(colorBlendFactor: 0.25)
    }
    
    /// Called only when user pans
    @objc public func scenePan(_ recognizer: UIPanGestureRecognizer) {
        cameraNode.cameraPanned(recognizer)
    }
    
    private func highlightUneditableTiles(colorBlendFactor: CGFloat) {
        for cityTile in city!.cityTerrain!.joined() {
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

