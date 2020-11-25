// This class is mostly for holding very top level things such as game currency

import SwiftUI


struct GameView: View {
    @EnvironmentObject var playerVariables: PlayerVariables
    @EnvironmentObject var staticGameVariables: StaticGameVariables
    
    @StateObject var gameVariables = GameVariables(gameType: GameTypes.standard)
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            switch (gameVariables.currentGameViewLevel){
            case GameViewLevel.galaxy:
                PlanetView()
            case GameViewLevel.planet:
                PlanetView()
            case GameViewLevel.city:
                PlanetView()
            }
        }
    }
    
    // Sets up the galaxy
    init(gameType: GameTypes){
        
        // for now this doesnt do anything
        switch gameType {
        case .standard:
            print("creating standard galaxy")
        case .planetRush:
            print("creating planetRush galaxy")
        }
    }
}
