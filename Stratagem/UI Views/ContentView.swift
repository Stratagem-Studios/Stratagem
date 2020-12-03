import SwiftUI
import SpriteKit

struct ContentView: View {
    @EnvironmentObject var playerVariables: PlayerVariables
    @EnvironmentObject var staticGameVariables: StaticGameVariables
    
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
            case .GameView:
                GameView()
                    .ignoresSafeArea()
            }
            
            if playerVariables.errorMessage != "" {
                ErrorPopup()
            }
        }.statusBar(hidden: true)
        .onAppear() {
            Global.initManagers(playerVariables: playerVariables, staticGameVariables: staticGameVariables)
            
            // Because we don't have a server, we make new players help remove dead games
            Global.lfGameManager!.detectAndRemoveDeadGames()
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
