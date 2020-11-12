// Mediates connection from Firebase -> GameVariables (realtime)

import Firebase

public struct GameListener {
    var playerVariables: PlayerVariables
    var staticGameVariables: StaticGameVariables
    var ref: DatabaseReference! = Database.database().reference()
    
    public func listenToAll() {
        listenForPlayerChanges()
        listenForGameStateChanges()
    }
    
    public func listenForPlayerChanges() {
        let gameUsernameRef = ref.child("games").child(staticGameVariables.gameCode).child("usernames")
        gameUsernameRef.observe(.value) { snapshot in
            var playerNames = [String]()
            let enumerator = snapshot.children
            while let username = enumerator.nextObject() as? DataSnapshot {
                playerNames.append(username.value as! String)
            }
            staticGameVariables.playerNames = playerNames
        }
    }
    
    public func listenForGameStateChanges() {
        let gameStatusRef = ref.child("game_statuses").child(staticGameVariables.gameCode)
        gameStatusRef.observe(.value) { snapshot in
            staticGameVariables.gameState = gameStates(rawValue: snapshot.value as! String) ?? gameStates.NA
            if staticGameVariables.gameState == gameStates.GAME {
                playerVariables.currentView = viewStates.CityView
            }
        }
    }
}

