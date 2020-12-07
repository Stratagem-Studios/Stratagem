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
                let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
                let build = Bundle.main.infoDictionary?["CFBundleVersion"] as! String
                
                #if DEBUG
                Global.lfGameManager!.detectAndRemoveDeadGames()
                #else
                
                if snapshot.value as! String == (version + " " + build) {
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
