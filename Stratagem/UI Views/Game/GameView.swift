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
            case GameViewLevel.galaxy:
                gameVars.galaxy
            case GameViewLevel.planet:
                ZStack{
                    gameVars.selectedPlanet
                    Button(action: {
                        gameVars.currentGameViewLevel = GameViewLevel.galaxy
                    }) {
                        Image("Galaxy")
                            .position(x: screenSize.topLeft.x + 60, y: screenSize.topLeft.y + 60)
                    }
                }
            case GameViewLevel.city:
                ZStack{
                    gameVars.selectedCity
                    Button(action: {
                        gameVars.currentGameViewLevel = GameViewLevel.planet
                    }) {
                        Image("Galaxy")
                            .position(x: screenSize.topLeft.x + 60, y: screenSize.topLeft.y + 60)
                    }
                }
            }
        }
    }
}
