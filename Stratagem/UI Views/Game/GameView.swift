// This class is mostly for holding very top level things such as game currency

import SwiftUI


struct GameView: View {
    @EnvironmentObject var playerVariables: PlayerVariables
    @EnvironmentObject var staticGameVariables: StaticGameVariables
    @EnvironmentObject var gameVars: GameVariables
    let screenSize = UIScreen.main.bounds
    
    var body: some View {
        ZStack {
            switch (gameVars.currentGameViewLevel){
            case GameViewLevel.GALAXY:
                gameVars.galaxy
            case GameViewLevel.PLANET:
                ZStack{
                    gameVars.selectedPlanet
                    Image("Galaxy")
                        .position(x: screenSize.topLeft.x + 60, y: screenSize.topLeft.y + 60)
                        .onTapGesture {
                            gameVars.currentGameViewLevel = GameViewLevel.GALAXY
                        }
                }
            case GameViewLevel.CITY:
                ZStack{
                    gameVars.selectedCity
                    Image("Planet")
                        .position(x: screenSize.topLeft.x + 60, y: screenSize.topLeft.y + 60)
                        .onTapGesture {
                            gameVars.currentGameViewLevel = GameViewLevel.PLANET
                        }
                }
            }
        }
    }
}
