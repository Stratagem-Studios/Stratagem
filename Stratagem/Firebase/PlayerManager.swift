import SwiftUI
import Firebase

public struct PlayerManager {
    var playerVariables: PlayerVariables
    var ref: DatabaseReference! = Database.database().reference()
    
    @Binding var hasUsername: Bool
    @Binding var invalidUsername: String
    
    public func fetchName() {
        let id = UIDevice.current.identifierForVendor?.uuidString ?? "NO UUID"
        
        let idUsernameRef = ref.child("id_to_username")
        idUsernameRef.observeSingleEvent(of: .value) { snapshot in
            if snapshot.hasChild(id) {
                if let value = snapshot.value as? [String: Any] {
                    playerVariables.playerName = value[id] as! String
                }
            } else {
                // Tell user to enter username
                hasUsername = false
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
                    invalidUsername = "Username already exists"
                }
            }
            
            if !usernameExists {
                if enteredUsername.isAlphanumeric {
                    self.ref.child("id_to_username").child(id).setValue(enteredUsername)
                    playerVariables.playerName = enteredUsername
                    hasUsername = true
                } else {
                    invalidUsername = "Username must be alphanumeric and must not contain spaces"
                }
            }
        }
    }
}

