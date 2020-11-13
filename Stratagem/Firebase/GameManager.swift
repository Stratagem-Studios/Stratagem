// Mediates connection between StaticGameVariables <-> Firebase (realtime)

import Firebase

public struct GameManager {
    var playerVariables: PlayerVariables
    var staticGameVariables: StaticGameVariables
    var ref: DatabaseReference! = Database.database().reference()
    
    public func generateRandomGameCode() {
        let letters = "0123456789"
        var gameCode: String = ""
        gameCode = String((0..<4).map{ _ in letters.randomElement()! })
        
        // Check if code already exists
        let gameStatusRef = ref.child("game_statuses")
        gameStatusRef.observeSingleEvent(of: .value) { snapshot in
            if snapshot.hasChild(gameCode) {
                generateRandomGameCode()
            } else {
                self.ref.child("game_statuses").child(gameCode).setValue(gameStates.PRE_LOBBY.rawValue)
                staticGameVariables.gameCode = gameCode
            }
        }
    }
    
    public func createGameWithCode(code: String) {
        self.ref.child("game_statuses").child(code).setValue(gameStates.LOBBY.rawValue)
        self.ref.child("games").child(code).child("usernames").setValue([playerVariables.playerName])
        self.ref.child("games").child(code).child("leader").setValue(playerVariables.playerName)
        self.ref.child("current_users").child(playerVariables.playerName).setValue(
            ["game_id": code])
        
        staticGameVariables.gameState = .LOBBY
        staticGameVariables.leaderName = playerVariables.playerName
    }
    
    public func joinGameWithCode(code: String) {
        self.ref.child("current_users").child(playerVariables.playerName).setValue(
            ["game_id": code])
        
        let gameStatusRef = ref.child("games").child(code).child("usernames")
        gameStatusRef.observeSingleEvent(of: .value) { snapshot in
            var playerNames = [String]()
            let enumerator = snapshot.children
            while let rest = enumerator.nextObject() as? DataSnapshot {
                playerNames.append(rest.value as! String)
            }
            playerNames.append(playerVariables.playerName)
            gameStatusRef.setValue(playerNames)
        }
        
        staticGameVariables.gameCode = code
    }
    
    public func startGame() {
        self.ref.child("game_statuses").child(staticGameVariables.gameCode).setValue(gameStates.GAME.rawValue)
    }
}
