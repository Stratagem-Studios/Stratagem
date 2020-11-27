import SwiftUI
import SpriteKit

struct ContentView: View {
    @EnvironmentObject var playerVariables: PlayerVariables
    @EnvironmentObject var staticGameVariables: StaticGameVariables
    @EnvironmentObject var gameVars: GameVariables
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            LoopingVideo().ignoresSafeArea()
            
            switch playerVariables.currentView {
            case .TitleScreenView:
                TitleScreenView()
            case .CreateGameView:
                CreateGameView()
                    .transition(.slide)
            case .JoinGameView:
                JoinGameView()
            case .GameLobbyView:
                GameLobbyView()
                    .transition(.slide)
            case .CityView:
                // just temp
                
//                GalaxyView()
                GameView()
                    .edgesIgnoringSafeArea(.all)
            case .GameView:
                GameView()
            }
            
            if playerVariables.errorMessage != "" {
                ErrorPopup()
            }
        }.onAppear() {
            // Because we don't have a server, we make new players help remove dead games
            LFGameManager(playerVariables: playerVariables, staticGameVariables: staticGameVariables).detectAndRemoveDeadGames()
            // Then calls fetchName
        }.animation(.default)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(PlayerVariables())
            .previewLayout(.fixed(width: 896, height: 414))
    }
}
