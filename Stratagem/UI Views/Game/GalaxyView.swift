// We can randomly instantiate more planets here
// All planets must be positioned
import SwiftUI
import SpriteKit

enum PlanetTypes {
    case homebaseRed, homebaseBlue, metalRich, goldRich
}

struct GalaxyView : View {
    @EnvironmentObject var playerVariables: PlayerVariables
    
    var scene: SKScene {
        let scene = GalaxyScene(size: CGSize(width: 10, height: 10))
        scene.size = CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        scene.backgroundColor = UIColor.clear
        return scene
    }
    
    var body: some View {
        SpriteView(scene: scene,options: [.allowsTransparency])
        
    }
}
