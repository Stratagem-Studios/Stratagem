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
                playerVariables.currentView = .CreateGameView
            }
        }
    }
    
    public func createGameWithCode(code: String) {
        self.ref.child("game_statuses").child(code).setValue(gameStates.LOBBY.rawValue)
        self.ref.child("games").child(code).child("usernames").setValue([playerVariables.playerName])
        self.ref.child("games").child(code).child("leader").setValue(playerVariables.playerName)
        self.ref.child("all_users").child(playerVariables.playerName).child("game_id").setValue(code)
        self.ref.child("all_users").child(playerVariables.playerName).child("status").setValue(playerStates.LOBBY.rawValue)
        
        staticGameVariables.gameState = .LOBBY
        staticGameVariables.leaderName = playerVariables.playerName
    }
    
    public func joinGameWithCode(code: String) {
        // Check if game code exists
        let gameCodesRef = ref.child("games")
        gameCodesRef.observeSingleEvent(of: .value) { snapshot in
            if snapshot.hasChild(code) {
                // Join game
                self.ref.child("all_users").child(playerVariables.playerName).child("game_id").setValue(code)
                self.ref.child("all_users").child(playerVariables.playerName).child("status").setValue(playerStates.LOBBY.rawValue)
                
                let gamePlayersRef = ref.child("games").child(code).child("usernames")
                gamePlayersRef.observeSingleEvent(of: .value) { snapshot in
                    var playerNames = [String]()
                    let enumerator = snapshot.children
                    while let rest = enumerator.nextObject() as? DataSnapshot {
                        playerNames.append(rest.value as! String)
                    }
                    playerNames.append(playerVariables.playerName)
                    gamePlayersRef.setValue(playerNames)
                    
                    staticGameVariables.gameCode = code
                    
                    GameListener(playerVariables: playerVariables, staticGameVariables: staticGameVariables).listenToAll()
                    playerVariables.currentView = .GameLobbyView
                }
            } else {
                // Propagate error message popup
                playerVariables.errorMessage = "Please enter a valid 4 digit game code"
            }
        }
    }
    
    public func removePlayerFromGame(username: String) {
        ref.child("all_users").child(username).child("game_id").removeValue()
        self.ref.child("all_users").child(username).child("status").setValue(playerStates.TITLESCREEN.rawValue)
        
        // Remove from game
        let gamePlayersRef = ref.child("games").child(staticGameVariables.gameCode).child("usernames")
        gamePlayersRef.observeSingleEvent(of: .value) { snapshot in
            var playerNames = [String]()
            let enumerator = snapshot.children
            while let username = enumerator.nextObject() as? DataSnapshot {
                playerNames.append(username.value as! String)
            }
            playerNames.remove(object: username)
            gamePlayersRef.setValue(playerNames)
        }
    }
    
    public func startGame() {
        self.ref.child("game_statuses").child(staticGameVariables.gameCode).setValue(gameStates.GAME.rawValue)
        let gamePlayersRef = ref.child("games").child(staticGameVariables.gameCode).child("usernames")
        gamePlayersRef.observeSingleEvent(of: .value) { snapshot in
            let enumerator = snapshot.children
            while let username = enumerator.nextObject() as? DataSnapshot {
                ref.child("all_users").child(username.value as! String).child("game_id").removeValue()
                ref.child("all_users").child(username.value as! String).child("status").setValue(playerStates.TITLESCREEN.rawValue)
            }
        }
    }
    
    public func removeGame() {        
        // Remove all players from game
        let gamePlayersRef = ref.child("games").child(staticGameVariables.gameCode).child("usernames")
        gamePlayersRef.observeSingleEvent(of: .value) { snapshot in
            let enumerator = snapshot.children
            while let username = enumerator.nextObject() as? DataSnapshot {
                ref.child("all_users").child(username.value as! String).child("game_id").removeValue()
                self.ref.child("all_users").child(playerVariables.playerName).child("status").setValue(playerStates.LOBBY.rawValue)
            }
            
            ref.child("games").child(staticGameVariables.gameCode).removeValue()
            ref.child("game_statuses").child(staticGameVariables.gameCode).removeValue()
            playerVariables.currentView = .TitleScreenView
        }
    }
}
