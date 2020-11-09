import SwiftUI

@main
struct StratagemApp: App {
    @StateObject var gameVariables = GameVariables()
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(self.gameVariables)
        }
    }
}
