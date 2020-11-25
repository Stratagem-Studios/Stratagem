import SwiftUI
import SpriteKit
import SceneKit
import SwiftVideoBackground

struct PlanetView : UIViewRepresentable {
    @EnvironmentObject var gameVariables: GameVariables
    
    let planet = SCNScene.init()
    let planetID: Int
    
    func makeUIView(context: Context) -> SCNView {
        // Make the sphere
        let planetSphere = SCNSphere.init(radius: 10)
        let planetNode = SCNNode(geometry: planetSphere)
        if let planetMask = UIImage(named: "TestPlanetMask"){
            planetSphere.firstMaterial?.diffuse.contents = planetMask
        }
        planet.rootNode.addChildNode(planetNode)
        
        // add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = .ambient
        ambientLightNode.light!.color = UIColor.gray
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
    
    func generateCities() -> [CityLayout] {
        var tempCityLayout: [CityLayout] = []
        
        // Code to setup the 
        
        return tempCityLayout
    }
}
