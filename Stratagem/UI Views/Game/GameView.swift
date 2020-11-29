// This class is mostly for holding very top level things such as game currency

import SwiftUI


struct GameView: View {
    @EnvironmentObject var playerVariables: PlayerVariables
    @EnvironmentObject var staticGameVariables: StaticGameVariables
    let screenSize = UIScreen.main.bounds
    
    var body: some View {
        ZStack {
            switch playerVariables.currentGameViewLevel {
            case .GALAXY:
                Global.gameVars!.galaxy
            case .PLANET:
                ZStack{
                    Global.gameVars!.selectedPlanet
                    Image("Galaxy")
                        .position(x: screenSize.topLeft.x + 60, y: screenSize.topLeft.y + 60)
                        .onTapGesture {
                            playerVariables.currentGameViewLevel = GameViewLevel.GALAXY
                        }
                }
            case .CITY:
                ZStack{
                    CityView()
                    Image("Planet")
                        .position(x: screenSize.topLeft.x + 60, y: screenSize.topLeft.y + 60)
                        .onTapGesture {
                            playerVariables.currentGameViewLevel = GameViewLevel.PLANET
                        }
                }
            }
        }
    }
}
