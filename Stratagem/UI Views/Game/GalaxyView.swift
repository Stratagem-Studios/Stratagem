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
        

    func makeUIView(context: Context) -> SCNView {
        
        // add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = .ambient
        ambientLightNode.light!.color = UIColor.gray
        galaxyScene.rootNode.addChildNode(ambientLightNode)
        
        let galaxy = SCNView()
        return galaxy
    }
    
    func updateUIView(_ scnView: SCNView, context: Context) {
        scnView.scene = galaxyScene
        
        // allows the user to manipulate the camera
        scnView.allowsCameraControl = true
        
        // configure the view
        galaxyScene.background.contents = UIColor.blue
        scnView.backgroundColor = UIColor.blue
    }
}
