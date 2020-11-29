import SwiftUI
import Firebase

public struct PlayerManager {
    var playerVariables: PlayerVariables
    var staticGameVariables: StaticGameVariables
    var ref: DatabaseReference! = Database.database().reference()
    
    public func fetchName() {
        let id = UIDevice.current.identifierForVendor?.uuidString ?? "NO UUID"
        
        let idUsernameRef = ref.child("id_to_username")
        idUsernameRef.observeSingleEvent(of: .value) { snapshot in
            if snapshot.hasChild(id) {
                if let value = snapshot.value as? [String: Any] {
                    playerVariables.playerName = value[id] as! String
                    self.ref.child("all_users").child(playerVariables.playerName).child("status").setValue(PlayerStates.TITLESCREEN.rawValue)
                    handleDisconnect()
                }
            } else {
                // Tell user to enter username
                playerVariables.playerName = "***NIL***"
            }
        }
    }
    
    public func assignName(enteredUsername: String) {
        let id = UIDevice.current.identifierForVendor?.uuidString ?? "NO UUID"
        
        // Check if username exists
        let gameStatusRef = ref.child("id_to_username")
        gameStatusRef.observeSingleEvent(of: .value) { snapshot in
            var usernameExists = false
            if snapshot.exists() {
                let value = (snapshot.value as! Dictionary<String, Any>).values.first as! String
                if value.lowercased() == enteredUsername.lowercased() {
                    usernameExists = true
                    playerVariables.inlineErrorMessage = "Username already exists"
                }
            }
            
            if !usernameExists {
                if enteredUsername.isAlphanumeric {
                    self.ref.child("id_to_username").child(id).setValue(enteredUsername)
                    playerVariables.playerName = enteredUsername
                    handleDisconnect()
                    self.ref.child("all_users").child(playerVariables.playerName).child("status").setValue(PlayerStates.TITLESCREEN.rawValue)
                } else {
                    playerVariables.inlineErrorMessage = "Username must be alphanumeric and must not contain spaces"
                }
            }
        }
    }
    
    public func handleDisconnect() {
        let playerStatusRef = self.ref.child("all_users").child(playerVariables.playerName).child("status")
        let connectedRef = Database.database().reference(withPath: ".info/connected")
        connectedRef.observe(.value, with: { snapshot in
            // Only handle connection established (or I've reconnected after a loss of connection)
            guard let connected = snapshot.value as? Bool, connected else { return }
            
            // When this device disconnects, set as offline
            playerStatusRef.onDisconnectSetValue(PlayerStates.OFFLINE.rawValue)
            self.ref.child("all_users").child(playerVariables.playerName).child("last_online").onDisconnectSetValue(ServerValue.timestamp())
            
            // Player is connected again
            let gameIdRef = ref.child("all_users").child(playerVariables.playerName).child("game_id")
            gameIdRef.observeSingleEvent(of: .value, with: { snapshot in
                if snapshot.exists() {
                    let gameRef = ref.child("games")
                    gameRef.observeSingleEvent(of: .value, with: { snapshot2 in
                        if snapshot2.hasChild(snapshot.value as! String) {
                            // Game still exists
                            let gameCodeRef = ref.child("games").child(snapshot.value as! String)
                            gameCodeRef.observeSingleEvent(of: .value, with: { snapshot3 in
                                let gameDict = (snapshot3.value as! Dictionary<String, Any>)
                                staticGameVariables.gameCode = snapshot.value as! String
                                
                                if playerVariables.observerRefs.count == 0 {
                                    // Reattach listeners
                                    Global.lfGameListener!.listenToAll()
                                }
                                
                                if gameDict["game_status"] as! String == GameStates.LOBBY.rawValue {
                                    playerStatusRef.setValue(PlayerStates.LOBBY.rawValue)
                                    playerVariables.currentView = .GameLobbyView
                                } else if  gameDict["game_status"] as! String == GameStates.GAME.rawValue {
                                    playerStatusRef.setValue(PlayerStates.GAME.rawValue)
                                    playerVariables.currentView = .GameView
                                }
                            })
                        } else {
                            // Game removed
                            playerStatusRef.setValue(PlayerStates.TITLESCREEN.rawValue)
                            ref.child("all_users").child(playerVariables.playerName).child("game_id").removeValue()
                            resetPlayer()
                        }
                    })
                } else {
                    // Not in a game
                    playerStatusRef.setValue(PlayerStates.TITLESCREEN.rawValue)
                    ref.child("all_users").child(playerVariables.playerName).child("game_id").removeValue()
                    resetPlayer()
                }
            })
            self.ref.child("all_users").child(playerVariables.playerName).child("last_online").removeValue()
        })
    }
    
    public func resetPlayer() {
        Global.lfGameListener!.stopListening()
        playerVariables.currentView = ViewStates.TitleScreenView
        staticGameVariables.reset()
    }
}

