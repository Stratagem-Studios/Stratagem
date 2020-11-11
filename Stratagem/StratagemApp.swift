import SwiftUI

@main
struct StratagemApp: App {
    @StateObject var gameVariables = GameVariables()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(self.gameVariables)
        }
    }
}
