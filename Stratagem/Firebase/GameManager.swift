import Firebase

public struct GameManager {
    var ref: DatabaseReference! = Database.database().reference()

    func createGame() -> Bool {
        self.ref.child("users").child("Unique_UUID").setValue(["username": ["test 2", "test 3"]])

        return true
    }
}
