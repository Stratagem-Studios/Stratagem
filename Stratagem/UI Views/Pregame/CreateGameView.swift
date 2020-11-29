import SwiftUI
import SpriteKit

public struct CreateGameView: View {
    @EnvironmentObject var playerVariables: PlayerVariables
    @EnvironmentObject var staticGameVariables: StaticGameVariables
    
    public var body: some View {
        VStack {
            TitleText(text: "OPTIONS")
                .padding(.top, 10)
            
            Spacer()
            
            HStack {
                Button(action: {
                    LFGameManager(playerVariables: playerVariables, staticGameVariables: staticGameVariables).removeGame()
                }) {
                    Text("BACK")
                }.buttonStyle(BasicButtonStyle())
                .padding(.bottom, 10)
                
                Spacer()
                
                HStack {
                    Text(staticGameVariables.gameCode)
                        .font(.custom("Montserrat-Bold", size: 20))
                        .background(Color("TitleBackground"))
                        .foregroundColor(Color.white)
                    Button(action: {
                        UIPasteboard.general.string = staticGameVariables.gameCode
                    }) {
                        Image("Copy")
                    }
                    .padding(.leading, 5)
                }
                .padding()
                .frame(height: 40)
                .background(Color("TitleBackground"))
                .cornerRadius(5)
                .foregroundColor(.white)
                .padding(.bottom, 10)
                
                Spacer()
                
                Button(action: {
                    LFGameManager(playerVariables: playerVariables, staticGameVariables: staticGameVariables).createGameWithCode(code: staticGameVariables.gameCode)
                    LFGameListener(playerVariables: playerVariables, staticGameVariables: staticGameVariables).listenToAll()
                    playerVariables.currentView = .GameLobbyView
                }) {
                    Text("CREATE")
                }.buttonStyle(BasicButtonStyle())
                .padding(.bottom, 10)
            }
        }.statusBar(hidden: true)
    }
}

struct CreateGameView_Preview: PreviewProvider {
    static var previews: some View {
        CreateGameView()
            .environmentObject(PlayerVariables())
            .previewLayout(.fixed(width: 896, height: 414))
    }
}
