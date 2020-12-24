import SwiftUI
import SpriteKit
import Firebase

struct ContentView: View {
    @EnvironmentObject var playerVariables: PlayerVariables
    @EnvironmentObject var staticGameVariables: StaticGameVariables
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            LoopingVideo().ignoresSafeArea()
            
            switch playerVariables.currentView {
            case .TitleScreenView:
                TitleScreenView()
            case .LearnGameView:
                LearnGameView()
                    .transition(.opacity)
            case .CreateGameView:
                CreateGameView()
                    .transition(.slide)
            case .JoinGameView:
                JoinGameView()
            case .GameLobbyView:
                GameLobbyView()
                    .transition(.slide)
            case .GameView:
                GameView()
                    .ignoresSafeArea()
            }
            
            if playerVariables.errorMessage != "" {
                ErrorPopup()
            }
        }.statusBar(hidden: true)
        .onAppear() {
            Global.initManagers(playerVariables: playerVariables, staticGameVariables: staticGameVariables)
            
            // Verify they're up to date
            Database.database().reference().child("app_version").observeSingleEvent(of: .value, with: { snapshot in
                let currentVersion = Float(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String)!
                let currentBuild = Float(Bundle.main.infoDictionary?["CFBundleVersion"] as! String)!
                
                #if DEBUG
                Global.lfGameManager!.detectAndRemoveDeadGames()
                #else
                
                let minVersion = Float((snapshot.value as! String).split(separator: " ")[0])!
                let minBuild = Float((snapshot.value as! String).split(separator: " ")[1])!
                if currentVersion >= minVersion && currentBuild >= minBuild {
                    // Because we don't have a server, we make new players help remove dead games, then calls fetchName
                    Global.lfGameManager!.detectAndRemoveDeadGames()
                } else {
                    playerVariables.errorMessage = "Please update to the newest version"
                }
                #endif
            })
        }.animation(.default)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(PlayerVariables())
            .previewLayout(.fixed(width: 896, height: 414))
    }
}
