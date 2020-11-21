import SwiftUI
import SpriteKit
import SceneKit
import SwiftVideoBackground

struct PlanetView : UIViewRepresentable {
    let planet = SCNScene.init()
    
    func makeUIView(context: Context) -> SCNView {
        // Make the sphere
        
        
        // set the planet spheres mask
        
        
        // create and add a light to the scene
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = .omni
        lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
        planet.rootNode.addChildNode(lightNode)

        // add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = .ambient
        ambientLightNode.light!.color = UIColor.darkGray
        planet.rootNode.addChildNode(ambientLightNode)

        // retrieve the SCNView
        let planet = SCNView()
        return planet
    }

    func updateUIView(_ scnView: SCNView, context: Context) {
        scnView.scene = planet

        // allows the user to manipulate the camera
        scnView.allowsCameraControl = true

        // configure the view
        planet.background.contents = UIColor.clear
        scnView.backgroundColor = UIColor.clear
    }
}

struct PlanetView_Previews : PreviewProvider {
    static var previews: some View {
        PlanetView()
    }
}
