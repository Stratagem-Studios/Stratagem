// Stores more static variables for game (LF)

import Combine

enum gameStates : String {
    case NA, PRE_LOBBY, LOBBY, GAME, POSTGAME
}

class StaticGameVariables: ObservableObject {
    @Published var gameCode: String = "NO CODE"
    @Published var gameState: gameStates = .NA
    @Published var playerNames: [String] = []
}
