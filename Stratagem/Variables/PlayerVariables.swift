// Stores variables for player (LF)

import Combine
import Firebase

enum ViewStates : String {
    case TitleScreenView, LearnGameView, CreateGameView, JoinGameView, GameLobbyView, GameView
}

enum PlayerStates : String {
    case TITLESCREEN, LOBBY, GAME, OFFLINE
}


class PlayerVariables: ObservableObject {
    @Published var playerName: String = ""
    @Published var currentView: ViewStates = .TitleScreenView
    @Published var observerRefs: [DatabaseReference] = []
    
    @Published var currentGameViewLevel = GameViewLevel.GALAXY
    
    // Error popup for swiftui
    @Published var errorMessage: String = ""
    // Error inline for choosing name
    @Published var inlineErrorMessage: String = ""
    
    init() {
        
    }
}
