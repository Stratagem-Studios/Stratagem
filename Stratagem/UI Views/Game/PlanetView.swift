import SwiftUI
import SpriteKit
import SwiftVideoBackground
import SceneKit

struct PlanetView: View {
    let screenSize = UIScreen.main.bounds
    let playerVariables = Global.playerVariables!
    var body: some View {
        ZStack {
            PlanetSphereView(planet: Global.gameVars!.selectedPlanet!)
            Image("Galaxy")
                .position(x: screenSize.topLeft.x + 60, y: screenSize.topLeft.y + 60)
                .onTapGesture {
                    playerVariables.currentGameViewLevel = GameViewLevel.GALAXY
                }
                .edgesIgnoringSafeArea(.all)
        }
    
    }
}


