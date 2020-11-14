// Stores variables for player (LF)

import Combine
import Firebase

enum viewStates : String {
    case TitleScreenView, CreateGameView, JoinGameView, GameLobbyView, CityView
}

class PlayerVariables: ObservableObject {
    @Published var playerName: String = "***NIL***"
    @Published var currentView: viewStates = viewStates.TitleScreenView
    @Published var errorMessage: String = ""
    @Published var observerRefs: [DatabaseReference] = []
    
    init() {
        
    }
}
