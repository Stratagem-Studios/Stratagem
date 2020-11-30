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
        let scene = GalaxyScene(size: CGSize(width: 200, height: 200))
        return scene
    }
    
    var body: some View {
        VStack{
            Image("Galaxy")
                .onTapGesture {
                    print("g")
                    playerVariables.currentGameViewLevel = .PLANET
                }
            SpriteView(scene: scene).edgesIgnoringSafeArea(.all)
        }
    }
}

struct PlanetAndLines {
    
}
