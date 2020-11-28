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
    @EnvironmentObject var gameVariables: GameVariables
    var planets: [PlanetView] = []
    
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
        Coordinator(galaxyView)
    }
    
    class Coordinator: NSObject {
            private let view: SCNView
            init(_ view: SCNView) {
                self.view = view
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
                    let material = result.node.geometry!.materials[(result.geometryIndex)]
                    
                    // highlight it
                    SCNTransaction.begin()
                    SCNTransaction.animationDuration = 0.5
                    
                    // on completion - unhighlight
                    SCNTransaction.completionBlock = {
                        SCNTransaction.begin()
                        SCNTransaction.animationDuration = 0.5
                        
                        material.emission.contents = UIColor.black
                      
                        SCNTransaction.commit()
                    }
                    material.emission.contents = UIColor.green
                    SCNTransaction.commit()
                }
            }
        }
}
