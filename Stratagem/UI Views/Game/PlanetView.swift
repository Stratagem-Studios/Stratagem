import SwiftUI
import SpriteKit
import SceneKit
import SwiftVideoBackground
import ObjectiveC
import UIKit

struct PlanetView : UIViewRepresentable {
    @EnvironmentObject var playerVariables: PlayerVariables

    let planetID: Int!
    
    let planet = SCNScene.init()
    var planetView = SCNView()
    
    var planetNode: SCNNode
    
    init(planetID: Int) {
        let planetSphere = SCNSphere.init(radius: 10)
        self.planetNode = SCNNode(geometry: planetSphere)
        if let planetMask = UIImage(named: "TestMask1"){
            planetSphere.firstMaterial?.diffuse.contents = planetMask
        }
        self.planetID = planetID
    }
    
    func makeUIView(context: Context) -> SCNView {
        // Make the sphere
        planet.rootNode.addChildNode(planetNode)
        
        // add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = .ambient
        ambientLightNode.light!.color = UIColor.gray
        planet.rootNode.addChildNode(ambientLightNode)
        
        planetView.scene = planet
        
        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.handleTap(_:)))
        planetView.addGestureRecognizer(tapGesture)
        
        return planetView
    }

    func updateUIView(_ scnView: SCNView, context: Context) {
        scnView.scene = planet

        // allows the user to manipulate the camera
        scnView.allowsCameraControl = true
        
        // configure the view
        planet.background.contents = UIColor.clear
        scnView.backgroundColor = UIColor.clear
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(planetView, playerVars: playerVariables, planetID: planetID)
    }
    
    class Coordinator: NSObject {
        private let view: SCNView
        let playerVars: PlayerVariables
        let planetID: Int
        init(_ view: SCNView, playerVars: PlayerVariables, planetID: Int) {
            self.view = view
            self.playerVars = playerVars
            self.planetID = planetID
            super.init()
        }
        
        @objc func handleTap(_ gestureRecognize: UIGestureRecognizer) {
            // check what nodes are tapped
            let p = gestureRecognize.location(in: view)
            let hitResults = view.hitTest(p, options: [:])
            
            // check that we clicked on at least one object
            if hitResults.count > 0 {
                let result: SCNHitTestResult = hitResults[0]
                let planet = Global.gameVars!.galaxy!.planets[planetID]
                for i in 0..<planet.cityMapping.count {
                    if planet.cityMapping[i].contains(CGPoint(x: p.x, y: p.y)){
                        Global.gameVars!.selectedCity = Global.gameVars!.galaxy!.planets[planetID].cities[i]
                        playerVars.currentGameViewLevel = GameViewLevel.CITY
                    }
                }
            }
        }
    }
}
