// Stores variables for player (LF)

import Combine
import Firebase

enum viewStates : String {
    case TitleScreenView, CreateGameView, JoinGameView, GameLobbyView, CityView
}

enum playerStates : String {
    case TITLESCREEN, LOBBY, GAME, OFFLINE
}


class PlayerVariables: ObservableObject {
    @Published var playerName: String = ""
    @Published var currentView: viewStates = .TitleScreenView
    @Published var errorMessage: String = ""
    @Published var inlineErrorMessage: String = ""
    @Published var observerRefs: [DatabaseReference] = []
    
    init() {
        
    }
}
