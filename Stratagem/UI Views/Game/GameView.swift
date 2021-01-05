// This class is mostly for holding very top level things such as game currency

import SwiftUI
import SpriteKit
import SwiftVideoBackground
import SceneKit

struct GameView: View {
    @EnvironmentObject var playerVariables: PlayerVariables
    @EnvironmentObject var staticGameVariables: StaticGameVariables
    let screenSize = UIScreen.main.bounds
    
    var body: some View {
        ZStack {
            // This scene needs to be open to update everthing
            SpriteView(scene: Global.gameVars.updater,options: [.allowsTransparency])
            
            // The actual GameView
            switch playerVariables.currentGameViewLevel {
            case .GALAXY:
                GalaxyView()
            case .PLANET:
                PlanetView()
            case .CITY:
                CityView()
            }
            
            // An alert box to inform the player as to what is happenening
            Global.gameVars.alertBox
                .frame(width: screenSize.width/4, height: screenSize.height/4, alignment: Alignment(horizontal: .leading, vertical: .bottom))
                .position(x: 0, y: screenSize.height - screenSize.height/8)
            
        }.onAppear {
            //VideoBackground.shared.pause()
        }
    }
    
}
