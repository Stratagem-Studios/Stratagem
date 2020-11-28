// Stores variables for player (LF)

import Combine
import Firebase

enum ViewStates : String {
    case TitleScreenView, CreateGameView, JoinGameView, GameLobbyView, GameView
}

enum PlayerStates : String {
    case TITLESCREEN, LOBBY, GAME, OFFLINE
}


class PlayerVariables: ObservableObject {
    @Published var playerName: String = ""
    @Published var currentView: ViewStates = .TitleScreenView
    @Published var errorMessage: String = ""
    @Published var inlineErrorMessage: String = ""
    @Published var observerRefs: [DatabaseReference] = []
    
    init() {
        
    }
}
