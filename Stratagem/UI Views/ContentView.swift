import SwiftUI
import SpriteKit

struct ContentView: View {
    @EnvironmentObject var playerVariables: PlayerVariables
    @EnvironmentObject var staticGameVariables: StaticGameVariables

    var body: some View {
        ZStack {
            switch playerVariables.currentView {
            case .TitleScreenView:
                TitleScreenView()
            case .CreateGameView:
                CreateGameView()
            case .JoinGameView:
                JoinGameView()
            case .GameLobbyView:
                GameLobbyView()
            case .CityView:
                CityView()
            }
            
            if playerVariables.errorMessage != "" {
                ErrorPopup()
            }
        }.onAppear() {
            PlayerManager(playerVariables: playerVariables, staticGameVariables: staticGameVariables).fetchName()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(PlayerVariables())
            .previewLayout(.fixed(width: 896, height: 414))
    }
}
