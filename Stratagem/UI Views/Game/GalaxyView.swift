// We can randomly instantiate more planets here
// All planets must be positioned
import SwiftUI
import SpriteKit
import SceneKit
import SwiftVideoBackground

enum PlanetTypes {
    case homebaseRed, homebaseBlue, metalRich, goldRich
}

struct GalaxyView : UIViewRepresentable {
    @EnvironmentObject var gameVars: GameVariables
    
    var galaxyScene = SCNScene.init()
    var galaxyView = SCNView()
        

    func makeUIView(context: Context) -> SCNView {
        
        // add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = .ambient
        ambientLightNode.light!.color = UIColor.gray
        galaxyScene.rootNode.addChildNode(ambientLightNode)
        galaxyView.scene = galaxyScene
        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.handleTap(_:)))
        galaxyView.addGestureRecognizer(tapGesture)
        return galaxyView
    }
    
    func updateUIView(_ scnView: SCNView, context: Context) {
        scnView.scene = galaxyScene
        
        // allows the user to manipulate the camera
        scnView.allowsCameraControl = true
        
        // configure the view
        galaxyScene.background.contents = UIColor.blue
        scnView.backgroundColor = UIColor.blue
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(galaxyView, gameVars: self.gameVars)
    }
    
    class Coordinator: NSObject {
        private let view: SCNView
        private let gameVars: GameVariables
        init(_ view: SCNView, gameVars: GameVariables) {
            self.view = view
            self.gameVars = gameVars
            super.init()
        }
        
        @objc func handleTap(_ gestureRecognize: UIGestureRecognizer) {
            // check what nodes are tapped
            let p = gestureRecognize.location(in: view)
            let hitResults = view.hitTest(p, options: [:])
            
            // check that we clicked on at least one object
            if hitResults.count > 0 {
                
                // retrieved the first clicked object
                let result = hitResults[0]
         
                // get material for selected geometry element
                for i in gameVars.galaxyLayout {
                    if i.planetNode == result.node {
                        print("e")
                        gameVars.selectedPlanet = i.planet
                        gameVars.currentGameViewLevel = GameViewLevel.planet
                    }
                }
            }
        }
    }
}
