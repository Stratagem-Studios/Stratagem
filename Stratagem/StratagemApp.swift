import SwiftUI

@main
struct StratagemApp: App {
    @StateObject var playerVariables = PlayerVariables()
    @StateObject var staticGameVariables = StaticGameVariables()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(self.playerVariables)
                .environmentObject(self.staticGameVariables)
        }
    }
}
