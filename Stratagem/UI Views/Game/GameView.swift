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
                GalaxyView()
            case .PLANET:
                ZStack{
                    PlanetView(planet: Global.gameVars!.selectedPlanet!)
                    Image("Galaxy")
                        .position(x: screenSize.topLeft.x + 60, y: screenSize.topLeft.y + 60)
                        .onTapGesture {
                            playerVariables.currentGameViewLevel = GameViewLevel.GALAXY
                        }
                        .edgesIgnoringSafeArea(.all)
                }
            case .CITY:
                CityView()
            }
        }.onAppear {
            Global.gameVars?.screenSize = UIScreen.main.bounds
        }
    }
    
}
