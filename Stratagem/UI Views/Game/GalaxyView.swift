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
    
    var isDisplayingplanet = false
    var planetToDisplay: PlanetView?
    var planets: [PlanetView]?
    
    let galaxy = SCNScene.init()
    var gameType: GameTypes
        
    init(gameType: GameTypes) {
        self.gameType = gameType
    }
    func makeUIView(context: Context) -> SCNView {
        
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
        if isDisplayingplanet{
        } else {
            scnView.scene = galaxy
            
            // allows the user to manipulate the camera
            scnView.allowsCameraControl = true
            
            // configure the view
            galaxy.background.contents = UIColor.clear
            scnView.backgroundColor = UIColor.clear
        }
    }
    
    func getPlanet() -> some View {
        return planetToDisplay
    }
    
    func getCity() -> some View {
        return planetToDisplay
    }
    
    func generatePlanets(n: Int){
        
    }
}
