// Mediates connection from Firebase -> GameVariables (realtime)

import Firebase

public struct GameListener {
    var playerVariables: PlayerVariables
    var staticGameVariables: StaticGameVariables
    var ref: DatabaseReference! = Database.database().reference()
    
    public func listenToAll() {
        listenForPlayerChanges()
        listenForLeader()
        listenForGameStateChanges()
    }
    
    public func stopListening() {
        for ref in playerVariables.observerRefs {
            ref.removeAllObservers()
        }
        playerVariables.observerRefs = []
    }
    
    public func listenForPlayerChanges() {
        let gameUsernameRef = ref.child("games").child(staticGameVariables.gameCode).child("usernames")
        gameUsernameRef.observe(.value) { snapshot in
            var playerNames = [String]()
            let enumerator = snapshot.children
            while let username = enumerator.nextObject() as? DataSnapshot {
                playerNames.append(username.value as! String)
            }
            if playerNames.contains(playerVariables.playerName) {
                staticGameVariables.playerNames = playerNames
            } else {
                // Removed from game
                PlayerManager(playerVariables: playerVariables, staticGameVariables: staticGameVariables).resetPlayer()
            }
        }
        playerVariables.observerRefs.append(gameUsernameRef)
    }
    
    public func listenForLeader() {
        let leaderRef = ref.child("games").child(staticGameVariables.gameCode).child("leader")
        leaderRef.observe(.value) { snapshot in
            if snapshot.exists() {
                print(snapshot.value as! String)
                staticGameVariables.leaderName = snapshot.value as! String
            } else {
                // Game lobby doesn't exist anymore
                PlayerManager(playerVariables: playerVariables, staticGameVariables: staticGameVariables).resetPlayer()
            }
        }
        playerVariables.observerRefs.append(leaderRef)
    }
    
    public func listenForGameStateChanges() {
        let gameStatusRef = ref.child("game_statuses").child(staticGameVariables.gameCode)
        gameStatusRef.observe(.value) { snapshot in
            if snapshot.exists() {
                staticGameVariables.gameState = gameStates(rawValue: snapshot.value as! String) ?? .NA
            } else {
                PlayerManager(playerVariables: playerVariables, staticGameVariables: staticGameVariables).resetPlayer()
            }
            
            switch staticGameVariables.gameState {
            case .NA:
                playerVariables.currentView = viewStates.TitleScreenView
            case .GAME:
                playerVariables.currentView = viewStates.CityView
            case .PRE_LOBBY:
                break
            case .LOBBY:
                break
            case .POSTGAME:
                break
            }
        }
        playerVariables.observerRefs.append(gameStatusRef)
    }
}

