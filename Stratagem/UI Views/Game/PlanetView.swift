import SwiftUI
import SpriteKit
import SceneKit
import SwiftVideoBackground
import ObjectiveC
import UIKit

//struct PlanetView: View {
//    var planet: Planet
//    let scene: SCNScene
//    let view: SCNView
//    var body: some View {
//
//        /// This never works - using View.superclass makes it a UIView, but it swill doesnt conform, every method that i have looked at involving conversions simply requires the use of UIRep again
//        view
//    }
//    init(planet: Planet) {
//        self.planet = planet
//        scene = planet.planetScene
//        view = SCNView()
//        view.backgroundColor = UIColor.clear
//
//    }
//}
    
//===========================================
    // alternate approach that works but never allows for transparency without
    
struct PlanetView: View {
    var planet: Planet
    let scene: SCNScene
    let scnView: SceneView

    var body: some View {
        scnView
    }
    init(planet: Planet) {
        self.planet = planet
        scene = planet.planetScene

        let transparentBG =  SCNView(frame: CGRect(origin: .zero, size: Global.gameVars.screenSize.size))
        scene.background.contents = transparentBG.snapshot()
        scnView = SceneView(scene: scene, pointOfView: scene.rootNode.childNode(withName: "cameraNode", recursively: false), options: [.autoenablesDefaultLighting, .allowsCameraControl])
    }
}
 

