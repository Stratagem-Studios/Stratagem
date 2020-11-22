import SwiftUI
import SpriteKit
import SceneKit
import SwiftVideoBackground

struct GalaxyView : UIViewRepresentable {
    let galaxy = SCNScene.init(named: "GalaxyScene")
    
    func makeUIView(context: Context) -> SCNView {
        let galaxy = SCNView()
        return galaxy
    }

    func updateUIView(_ scnView: SCNView, context: Context) {
        
    }

}
