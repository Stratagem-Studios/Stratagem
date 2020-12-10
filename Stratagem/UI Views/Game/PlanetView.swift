import SwiftUI
import SpriteKit
import SwiftVideoBackground
import SceneKit

struct PlanetView: View {
    let screenBounds = UIScreen.main.bounds
    let playerVariables = Global.playerVariables!
    let planetPanelScene: PlanetPanel
    var body: some View {
        
        ZStack {
            HStack {
                VStack{
                    Spacer()
                        .frame(height:screenBounds.height/20)
                    Text(Global.gameVars.selectedPlanet!.planetName)
                        .font(.custom("Montserrat-Bold", size: 40))
                        .frame(width: screenBounds.size.width*3/5, height: 30)
                    PlanetSphereView(planet: Global.gameVars!.selectedPlanet!, planetPanel: planetPanelScene)
                        .frame( alignment: .top)
//                        .position(x: screenBounds.size.width/3, y: screenBounds.size.halfHeight)
                }
                SpriteView(scene: planetPanelScene, options: [.allowsTransparency])
                    .frame(
                        width: screenBounds.size.width*2/5, height: screenBounds.size.height, alignment: .trailing)
            }
            Image("Galaxy")
                .position(x: screenBounds.topLeft.x + 50, y: screenBounds.topLeft.y + 50)
                .onTapGesture {
                    playerVariables.currentGameViewLevel = GameViewLevel.GALAXY
                }
                .edgesIgnoringSafeArea(.all)
        }
    }
    init() {
        planetPanelScene = PlanetPanel(size: CGSize(width: screenBounds.size.width*2/5, height: screenBounds.size.height))
    }
}


