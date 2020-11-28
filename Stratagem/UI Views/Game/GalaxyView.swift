// We can randomly instantiate more planets here
// All planets must be positioned
import SwiftUI
import SpriteKit

enum PlanetTypes {
    case homebaseRed, homebaseBlue, metalRich, goldRich
}

struct GalaxyView : View {
    @EnvironmentObject var gameVars: GameVariables
    
    var body: some View {
        Image("Galaxy")
            .onTapGesture {
                print("g")
                gameVars.currentGameViewLevel = .planet
            }
    }
}

struct PlanetAndLines {
    
}
