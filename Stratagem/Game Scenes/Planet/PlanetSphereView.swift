import SwiftUI
import SceneKit
import Foundation


struct PlanetSphereView : UIViewRepresentable {
    @EnvironmentObject var playerVariables: PlayerVariables
    
    weak var planet: Planet!
    
    let planetScene = SCNScene.init()
    var planetView = SCNView()
    
    let planetPanel: PlanetPanel
    
    init(planet: Planet, planetPanel: PlanetPanel) {
        planetScene.rootNode.position = SCNVector3(0,0,0)
        self.planet = planet
        self.planetPanel = planetPanel
    }
    
    func makeUIView(context: Context) -> SCNView {
        planetScene.rootNode.addChildNode(planet.planetNode!)
        planetScene.rootNode.addChildNode(planet.planetLight!)
        planetScene.rootNode.addChildNode(planet.cameraOrbit!)

        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.handleTap(_:)))
        let panGesture = UIPanGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.handlePan(_:)))
        planetView.addGestureRecognizer(tapGesture)
        planetView.addGestureRecognizer(panGesture)
        
        planetView.pointOfView = planet.cameraOrbit!
        
        return planetView
    }
    
    func updateUIView(_ scnView: SCNView, context: Context) {
        scnView.scene = planetScene
        
        // configure the view
        planetScene.background.contents = UIColor.clear
        scnView.backgroundColor = UIColor.clear
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(planetView, playerVars: playerVariables, planet: planet, planetNode: planet!.planetNode!, cameraOrbit: planet.cameraOrbit!, planetPanel: planetPanel)
    }
    
    class Coordinator: NSObject {
        private let view: SCNView
        let playerVars: PlayerVariables
        let planet: Planet
        var lastPos: CGFloat?
        var planetNode:  SCNNode
        let cameraOrbit: SCNNode
        let planetPanel: PlanetPanel
        
        
        init(_ view: SCNView, playerVars: PlayerVariables, planet: Planet, planetNode: SCNNode, cameraOrbit: SCNNode, planetPanel: PlanetPanel) {
            self.view = view
            self.playerVars = playerVars
            self.planet = planet
            self.planetNode = planetNode
            self.cameraOrbit = cameraOrbit
            self.planetPanel = planetPanel
            super.init()
        }
        
        @objc func handleTap(_ gestureRecognize: UIGestureRecognizer) {
            // check what nodes are tapped
            let p = gestureRecognize.location(in: view)
            let hitResults = view.hitTest(p, options: [:])
            
            // check that we clicked on at least one object
            if hitResults.count > 0 {
                let result: SCNHitTestResult = hitResults[0]
                print(planet.cityMapping)
                print("---\(result.textureCoordinates(withMappingChannel: 0))---")
                
                for i in 0..<planet.cityMapping.count {
                    if planet.cityMapping[i].contains(result.textureCoordinates(withMappingChannel: 0)){
                        Global.gameVars!.selectedCity = planet.cities[i]
                        planetPanel.selectCity(city: planet.cities[i])
                        planet.planetMap.selectCitySprite(loc: planet.cityLocs[i])
                    }
                }
            }
        }
        @objc func handlePan(_ sender: UIPanGestureRecognizer) {
            let scrollWidthRatio = Float(sender.velocity(in: sender.view!).x) / 30000 * -1
            let scrollHeightRatio = Float(sender.velocity(in: sender.view!).y) / 30000
            planetNode.eulerAngles.y += Float(-2 * Double.pi) * scrollWidthRatio
        }
    }
}

