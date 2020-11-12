import SwiftUI
import Firebase

class AppDelegate: NSObject, UIApplicationDelegate {
    var ref: DatabaseReference!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        FirebaseApp.configure()
        self.ref = Database.database().reference()
        return true
    }
}
