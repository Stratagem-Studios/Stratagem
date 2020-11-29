// Mediates connection from Firebase -> GameVariables (realtime)

import Firebase

public struct LFGameListener {
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
                Global.playerManager!.resetPlayer()
            }
        }
        playerVariables.observerRefs.append(gameUsernameRef)
    }
    
    public func listenForLeader() {
        let leaderRef = ref.child("games").child(staticGameVariables.gameCode).child("leader")
        leaderRef.observe(.value) { snapshot in
            if snapshot.exists() {
                staticGameVariables.leaderName = snapshot.value as! String
            } else {
                // Game lobby doesn't exist anymore
                Global.playerManager!.resetPlayer()
            }
        }
        playerVariables.observerRefs.append(leaderRef)
    }
    
    public func listenForGameStateChanges() {
        let gameStatusRef = ref.child("games").child(staticGameVariables.gameCode).child("game_status")
        gameStatusRef.observe(.value) { snapshot in
            if snapshot.exists() {
                staticGameVariables.gameState = GameStates(rawValue: snapshot.value as! String) ?? .NA
            } else {
                Global.playerManager!.resetPlayer()
            }

            switch staticGameVariables.gameState {
            case .NA:
                playerVariables.currentView = ViewStates.TitleScreenView
            case .GAME:
                Global.lfGameManager!.playerInitGame()
                playerVariables.currentView = ViewStates.GameView
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

