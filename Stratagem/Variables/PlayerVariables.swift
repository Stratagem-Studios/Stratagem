// Stores variables for player (LF)

import Combine

enum viewStates : String {
    case TitleScreenView, CreateGameView, JoinGameView, GameLobbyView, CityView
}

class PlayerVariables: ObservableObject {
    @Published var playerName: String = "inter"
    @Published var currentView: viewStates = viewStates.TitleScreenView
    
    init() {
        
    }
}
