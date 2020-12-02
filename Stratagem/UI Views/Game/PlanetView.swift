import SwiftUI
import SpriteKit
import SceneKit
import SwiftVideoBackground
import ObjectiveC
import UIKit

struct PlanetView : UIViewRepresentable {
    @EnvironmentObject var playerVariables: PlayerVariables

    let planet: Planet!
    
    let planetScene = SCNScene.init()
    var planetView = SCNView()
    
    var planetNode: SCNNode
    
    
    init(planet: Planet) {
        let planetSphere = SCNSphere.init(radius: 10)
        self.planetNode = SCNNode(geometry: planetSphere)
        let planetMask: UIImage = planet.generatePlanetMap()
        planetSphere.firstMaterial?.diffuse.contents = planetMask
        self.planet = planet
    }
    
    func makeUIView(context: Context) -> SCNView {
        // Make the sphere
        planetScene.rootNode.addChildNode(planetNode)
        
        // add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = .ambient
        ambientLightNode.light!.color = UIColor.gray
        planetScene.rootNode.addChildNode(ambientLightNode)
        
        planetView.scene = planetScene
        
        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.handleTap(_:)))
        planetView.addGestureRecognizer(tapGesture)
        
        return planetView
    }

    func updateUIView(_ scnView: SCNView, context: Context) {
        scnView.scene = planetScene

        // allows the user to manipulate the camera
        scnView.allowsCameraControl = true
        
        // configure the view
        planetScene.background.contents = UIColor.clear
        scnView.backgroundColor = UIColor.clear
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(planetView, playerVars: playerVariables, planet: planet)
    }
    
    class Coordinator: NSObject {
        private let view: SCNView
        let playerVars: PlayerVariables
        let planet: Planet
        init(_ view: SCNView, playerVars: PlayerVariables, planet: Planet) {
            self.view = view
            self.playerVars = playerVars
            self.planet = planet
            super.init()
        }
        
        @objc func handleTap(_ gestureRecognize: UIGestureRecognizer) {
            // check what nodes are tapped
            let p = gestureRecognize.location(in: view)
            let hitResults = view.hitTest(p, options: [:])
            
            // check that we clicked on at least one object
            if hitResults.count > 0 {
                let result: SCNHitTestResult = hitResults[0]

                print(result.textureCoordinates(withMappingChannel: 0))
                for i in 0..<planet.cityMapping.count {
                    if planet.cityMapping[i].contains(result.textureCoordinates(withMappingChannel: 0)){
                        Global.gameVars!.selectedCity = planet.cities[i]
                        playerVars.currentGameViewLevel = GameViewLevel.CITY
                    }
                }
            }
        }
    }
}
