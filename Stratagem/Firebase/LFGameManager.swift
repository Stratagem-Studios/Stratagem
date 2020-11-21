// Mediates connection between StaticGameVariables <-> Firebase (realtime)

import Firebase
import SwiftUI

public struct LFGameManager {
    var playerVariables: PlayerVariables
    var staticGameVariables: StaticGameVariables
    var ref: DatabaseReference! = Database.database().reference()
    
    public func generateRandomGameCode() {
        let letters = "0123456789"
        var gameCode: String = ""
        gameCode = String((0..<4).map{ _ in letters.randomElement()! })
        
        // Check if code already exists
        let gameStatusRef = ref.child("games")
        gameStatusRef.observeSingleEvent(of: .value) { snapshot in
            if snapshot.hasChild(gameCode) {
                generateRandomGameCode()
            } else {
                staticGameVariables.gameCode = gameCode
                self.ref.child("games").child(staticGameVariables.gameCode).child("game_status").setValue(gameStates.PRE_LOBBY.rawValue)
                
                staticGameVariables.leaderName = playerVariables.playerName
                self.ref.child("games").child(gameCode).child("usernames").setValue([playerVariables.playerName])
                self.ref.child("games").child(gameCode).child("leader").setValue(playerVariables.playerName)
                self.ref.child("all_users").child(playerVariables.playerName).child("game_id").setValue(gameCode)
                self.ref.child("all_users").child(playerVariables.playerName).child("status").setValue(playerStates.LOBBY.rawValue)
                
                playerVariables.currentView = .CreateGameView
            }
        }
    }
    
    public func createGameWithCode(code: String) {
        self.ref.child("games").child(staticGameVariables.gameCode).child("game_status").setValue(gameStates.LOBBY.rawValue)
        staticGameVariables.gameState = .LOBBY
        playerVariables.currentView = .GameLobbyView
    }
    
    public func joinGameWithCode(code: String) {
        // Check if game code exists
        let gameCodesRef = ref.child("games")
        gameCodesRef.observeSingleEvent(of: .value) { snapshot in
            if snapshot.hasChild(code) {
                // Check if game is joinable
                let game_status = snapshot.childSnapshot(forPath: code).childSnapshot(forPath: "game_status").value as! String
                if game_status == gameStates.LOBBY.rawValue {
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
                        
                        LFGameListener(playerVariables: playerVariables, staticGameVariables: staticGameVariables).listenToAll()
                        playerVariables.currentView = .GameLobbyView
                    }
                } else {
                    playerVariables.errorMessage = "Game is in progress or hasn't been created yet"
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
        if staticGameVariables.leaderName == playerVariables.playerName {
            // Player is the leader
            self.ref.child("games").child(staticGameVariables.gameCode).child("game_status").setValue(gameStates.GAME.rawValue)
            let gamePlayersRef = ref.child("games").child(staticGameVariables.gameCode).child("usernames")
            gamePlayersRef.observeSingleEvent(of: .value) { snapshot in
                let enumerator = snapshot.children
                while let username = enumerator.nextObject() as? DataSnapshot {
                    ref.child("all_users").child(username.value as! String).child("game_id").setValue(staticGameVariables.gameCode)
                    ref.child("all_users").child(username.value as! String).child("status").setValue(playerStates.GAME.rawValue)
                }
            }
        } else {
            playerVariables.errorMessage = "You're not the leader"
        }
    }
    
    public func removeGame() {
        // Remove all players from game
        let gamePlayersRef = ref.child("games").child(staticGameVariables.gameCode).child("usernames")
        gamePlayersRef.observeSingleEvent(of: .value) { snapshot in
            let enumerator = snapshot.children
            while let username = enumerator.nextObject() as? DataSnapshot {
                ref.child("all_users").child(username.value as! String).child("game_id").removeValue()
                self.ref.child("all_users").child(playerVariables.playerName).child("status").setValue(playerStates.TITLESCREEN.rawValue)
            }
            
            ref.child("games").child(staticGameVariables.gameCode).removeValue()
            playerVariables.currentView = .TitleScreenView
        }
    }
    
    public func detectAndRemoveDeadGames() {
        let allUsersRef = ref.child("all_users")
        allUsersRef.observeSingleEvent(of: .value) { snapshot in
            var allGameCodes: [String] = []
            var dontKillGameCode: [String] = []
            
            let enumerator = snapshot.children
            while let username = enumerator.nextObject() as? DataSnapshot {
                let value = username.value as! Dictionary<String, Any>
                if let game_id = value["game_id"] {
                    if value["status"] as! String != "OFFLINE" {
                        // 1+ active player in game
                        dontKillGameCode.append(game_id as! String)
                    }
                    allGameCodes.append(game_id as! String)
                }
            }
            
            let toRemove = Array(Set(allGameCodes).subtracting(dontKillGameCode))
            for removeGameCode in toRemove {
                ref.child("games").child(removeGameCode).removeValue()
            }
            
            PlayerManager(playerVariables: playerVariables, staticGameVariables: staticGameVariables).fetchName()
        }
    }
}

