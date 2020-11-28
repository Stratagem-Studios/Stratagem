import SwiftUI
import SpriteKit
import SceneKit
import SwiftVideoBackground
import ObjectiveC
import UIKit

struct PlanetView : UIViewRepresentable {
    let planetID: Int!
    @EnvironmentObject var gameVars: GameVariables
    
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
        Coordinator(planetView,gameVars: gameVars, planetID: planetID)
    }
    
    class Coordinator: NSObject {
        private let view: SCNView
        let gameVars: GameVariables
        let planetID: Int
        init(_ view: SCNView, gameVars: GameVariables, planetID: Int) {
            self.view = view
            self.gameVars = gameVars
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
                let planetLayout = gameVars.galaxyLayout[planetID]
                for i in 0...planetLayout.cityMapping.count - 1 {
                    if planetLayout.cityMapping[i].contains(CGPoint(x: p.x, y: p.y)){
                        gameVars.selectedCity = gameVars.galaxyLayout[planetID].cities[i].city
                        gameVars.currentGameViewLevel = GameViewLevel.CITY
                    }
                }
            }
        }
    }
}
