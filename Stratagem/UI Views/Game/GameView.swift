import SwiftUI

// One of these must be passed to the GameStruct
enum GameTypes {
    case standard, planetRush
}


struct GameView: View {
    @EnvironmentObject var playerVariables: PlayerVariables
    @EnvironmentObject var staticGameVariables: StaticGameVariables
    
    var gameType: GameTypes
    var galaxy: GalaxyView
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            LoopingVideo().ignoresSafeArea()
            
        }
    }
    
    // Sets up the galaxy
    init(gameType: GameTypes){
        self.gameType = gameType
        
        switch gameType {
        case .standard:
            print("creating standard galaxy")
        case .planetRush:
            print("creating planetRush galaxy")
        }
        
        galaxy = GalaxyView()
    }
}
