// Mediates connection from Firebase -> GameVariables (realtime)

import Firebase

public struct GameListener {
    var playerVariables: PlayerVariables
    var staticGameVariables: StaticGameVariables
    var ref: DatabaseReference! = Database.database().reference()
    
    public func listenToAll() {
        listenForPlayerChanges()
    }
    
    public func listenForPlayerChanges() {
        let gameStatusRef = ref.child("games").child(staticGameVariables.gameCode).child("usernames")
        let listenForPlayerChangesRef = gameStatusRef.observe(.value) { snapshot in
                var playerNames = [String]()
                let enumerator = snapshot.children
                while let rest = enumerator.nextObject() as? DataSnapshot {
                    playerNames.append(rest.value as! String)
            }
            staticGameVariables.playerNames = playerNames
        }
    }
}

