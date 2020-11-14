// Stores more static variables for game (LF)

import Combine

enum gameStates : String {
    case NA, PRE_LOBBY, LOBBY, GAME, POSTGAME
}

class StaticGameVariables: ObservableObject {
    @Published var gameCode: String
    @Published var gameState: gameStates
    @Published var playerNames: [String]
    @Published var leaderName: String
    
    init() {
        gameCode = "NO CODE"
        gameState = .NA
        playerNames = []
        leaderName = ""
    }
    
    func reset() {
        gameCode = "NO CODE"
        gameState = .NA
        playerNames = []
        leaderName = ""
    }
}
