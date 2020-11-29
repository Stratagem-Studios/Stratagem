// We can randomly instantiate more planets here
// All planets must be positioned
import SwiftUI
import SpriteKit

enum PlanetTypes {
    case homebaseRed, homebaseBlue, metalRich, goldRich
}

struct GalaxyView : View {
    @EnvironmentObject var playerVariables: PlayerVariables
    
    var body: some View {
        Image("Galaxy")
            .onTapGesture {
                print("g")
                playerVariables.currentGameViewLevel = .PLANET
            }
    }
}

struct PlanetAndLines {
    
}
