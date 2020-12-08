import SwiftUI
import SceneKit
import Foundation


struct PlanetView : UIViewRepresentable {
    @EnvironmentObject var playerVariables: PlayerVariables
    
    let planet: Planet!
    
    let planetScene = SCNScene.init()
    var planetView = SCNView()
    let planetMap : PlanetMap
    var planetNode: SCNNode
    let planetSphere = SCNSphere.init(radius: 10)
    private var cameraOrbit: SCNNode
    
    init(planet: Planet) {
        planetScene.rootNode.position = SCNVector3(0,0,0)
        self.planet = planet
        self.planetNode = SCNNode(geometry: planetSphere)
        
        planetMap = planet.planetMap
        planetSphere.firstMaterial?.diffuse.contents = planetMap
        
        cameraOrbit = SCNNode()
        cameraOrbit.camera = SCNCamera()
        planetScene.rootNode.addChildNode(cameraOrbit)
        
        cameraOrbit.position = SCNVector3(planetNode.position.x,planetNode.position.y,planetNode.position.z+22)
    }
    
    func makeUIView(context: Context) -> SCNView {
        // Make the sphere
        planetScene.rootNode.addChildNode(planetNode)
        
        // add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = .ambient
        ambientLightNode.light!.color = UIColor.gray
        planetScene.rootNode.addChildNode(ambientLightNode)
        planetView.scene = planetScene
        
        
        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.handleTap(_:)))
        let panGesture = UIPanGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.handlePan(_:)))
        planetView.addGestureRecognizer(tapGesture)
        planetView.addGestureRecognizer(panGesture)
        
        return planetView
    }
    
    func updateUIView(_ scnView: SCNView, context: Context) {
        scnView.scene = planetScene
        
        planetSphere.firstMaterial?.diffuse.contents = planetMap
        
        scnView.pointOfView = cameraOrbit
        // allows the user to manipulate the camera
        //scnView.allowsCameraControl = true
        
        // configure the view
        planetScene.background.contents = UIColor.clear
        scnView.backgroundColor = UIColor.clear
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(planetView, playerVars: playerVariables, planet: planet, planetNode: planetNode, cameraOrbit: cameraOrbit)
    }
    
    class Coordinator: NSObject {
        private let view: SCNView
        let playerVars: PlayerVariables
        let planet: Planet
        var lastPos: CGFloat?
        var planetNode:  SCNNode
        let cameraOrbit: SCNNode
        let matrix: SCNMatrix4
        
        init(_ view: SCNView, playerVars: PlayerVariables, planet: Planet, planetNode: SCNNode, cameraOrbit: SCNNode) {
            self.view = view
            self.playerVars = playerVars
            self.planet = planet
            self.planetNode = planetNode
            self.cameraOrbit = cameraOrbit
            matrix = SCNMatrix4MakeRotation(0, 0, 0, 0)
            super.init()
        }
        
        @objc func handleTap(_ gestureRecognize: UIGestureRecognizer) {
            // check what nodes are tapped
            let p = gestureRecognize.location(in: view)
            let hitResults = view.hitTest(p, options: [:])
            
            // check that we clicked on at least one object
            if hitResults.count > 0 {
                let result: SCNHitTestResult = hitResults[0]
                
                print(planet.cityMapping ,result.textureCoordinates(withMappingChannel: 0))
                for i in 0..<planet.cityMapping.count {
                    if planet.cityMapping[i].contains(result.textureCoordinates(withMappingChannel: 0)){
                        print(i)
                        print(planet.cities)
                        Global.gameVars!.selectedCity = planet.cities[i]
                        playerVars.currentGameViewLevel = GameViewLevel.CITY
                    }
                }
            }
        }
        @objc func handlePan(_ sender: UIPanGestureRecognizer) {
            cameraOrbit.pivot = matrix
            let scrollWidthRatio = Float(sender.velocity(in: sender.view!).x) / 70000 * -1
            let scrollHeightRatio = Float(sender.velocity(in: sender.view!).y) / 70000
            planetNode.eulerAngles.y += Float(-2 * Double.pi) * scrollWidthRatio
        }
    }
}

