// Mediates connection between StaticGameVariables <-> Firebase (realtime)

import Firebase

public struct GameManager {
    var staticGameVariables: StaticGameVariables
    var ref: DatabaseReference! = Database.database().reference()
    
    public func generateRandomGameCode() {
        var gameCode: String = ""
        var gameCodeAlreadyExists: Bool = false
        
        while true {
            let letters = "0123456789"
            gameCode = String((0..<4).map{ _ in letters.randomElement()! })
            
            // Check if code already exists
            let gameStatusRef = ref.child("game_statuses")
            gameStatusRef.observeSingleEvent(of: .value) { snapshot in
                       let enumerator = snapshot.children
                       while let rest = enumerator.nextObject() as? DataSnapshot {
                        if rest.key == letters {
                            gameCodeAlreadyExists = true
                        }
                }
            }
            if gameCodeAlreadyExists {
                gameCodeAlreadyExists.toggle()
            } else {
                break
            }
        }
        
        self.ref.child("game_statuses").child(gameCode).setValue(gameStates.PRE_LOBBY.rawValue)
        staticGameVariables.gameCode = gameCode
        staticGameVariables.gameState = .PRE_LOBBY
    }

    public func createGameWithCode(code: String) {
        self.ref.child("game_statuses").child(code).setValue(gameStates.LOBBY.rawValue)
        self.ref.child("games").child(code).setValue(
                ["usernames": ["interspatial"]])
        self.ref.child("users").child("interspatial").setValue(
                ["game_id": code])
        
        staticGameVariables.gameState = .LOBBY
    }
    
    public func joinGameWithCode(code: String) {
        self.ref.child("users").child("player 2").setValue(
                ["game_id": code])
        
        let gameStatusRef = ref.child("games").child(code).child("usernames")
        gameStatusRef.observeSingleEvent(of: .value) { snapshot in
                var playerNames = [String]()
                let enumerator = snapshot.children
                while let rest = enumerator.nextObject() as? DataSnapshot {
                    playerNames.append(rest.value as! String)
            }
            playerNames.append("player 2")
            gameStatusRef.setValue(playerNames)
        }
        
        staticGameVariables.gameCode = code
        staticGameVariables.gameState = .LOBBY
    }
    
    public func startGame() {
        
    }
}
