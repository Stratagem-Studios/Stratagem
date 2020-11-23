// We can randomly instantiate more planets here
// All planets must be positioned
import SwiftUI
import SpriteKit
import SceneKit
import SwiftVideoBackground

struct GalaxyView : UIViewRepresentable {
    let galaxy = SCNScene.init()
        
    func makeUIView(context: Context) -> SCNView {
        // Generates some planets
        // Should later be replaced
        for index in 0...3 {
            galaxy.rootNode.addChildNode(generatePlanet(name: "Planet_" + String(index), mask: UIImage(named: "TestPlanetMask")!, cityCount: 0))
            galaxy.rootNode.childNodes[index].position.x = Float((index - 2) * 25)
            
        }
        
        // add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = .ambient
        ambientLightNode.light!.color = UIColor.gray
        galaxy.rootNode.addChildNode(ambientLightNode)
        
        let galaxy = SCNView()
        return galaxy
    }
    func updateUIView(_ scnView: SCNView, context: Context) {
        scnView.scene = galaxy
        
        // allows the user to manipulate the camera
        scnView.allowsCameraControl = true
        
        // configure the view
        galaxy.background.contents = UIColor.clear
        scnView.backgroundColor = UIColor.clear
    }

    func generatePlanet(name: String, mask: UIImage, cityCount: Int) -> SCNNode{

        let planetSphere = SCNSphere.init(radius: 10)
        let planetNode = SCNNode(geometry: planetSphere)
        planetNode.name = name
        planetSphere.firstMaterial?.diffuse.contents = mask
        return planetNode
    }
}
