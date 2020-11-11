import Firebase

public struct GameManager {
    var ref: DatabaseReference! = Database.database().reference()
    
    public func generateRandomGameCode() -> String {
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
        
        self.ref.child("game_statuses").child(gameCode).setValue(String(describing: gameStates.PRE_LOBBY))
        return gameCode
    }

    public func createGameWithCode(code: String) -> Bool {
        let uuid = UIDevice.current.identifierForVendor?.uuidString
        
        if let uuid = uuid {
            self.ref.child("users").child(uuid).setValue(
                ["username": "interspatial",
                 "game_id": code])
            
            self.ref.child("games").child(code).setValue(
                ["username": "interspatial"])
        } else {
            return false
        }

        return true
    }
}
