import SwiftUI
import SpriteKit

public struct JoinGameView: View {
    @EnvironmentObject var playerVariables: PlayerVariables
    @EnvironmentObject var staticGameVariables: StaticGameVariables
    @EnvironmentObject var gameVariables: GameVariables
    @State var enteredCode: String = ""

    public var body: some View {
        VStack() {
            TitleText(text: "STRATAGEM")
                .padding(.top, 10)

            Spacer()
            
            Button(action: {
                GameListener(playerVariables: playerVariables, staticGameVariables: staticGameVariables).listenToAll()
                GameManager(playerVariables: playerVariables, staticGameVariables: staticGameVariables).joinGameWithCode(code: enteredCode)
                playerVariables.currentView = .GameLobbyView
            }) {
                Text("PLAY")
            }.buttonStyle(BasicButtonStyle())
            .padding(.bottom, 10)
            
            ZStack {
                TextField("CODE", text: $enteredCode)
                    .frame(width: 62, height: 40)
                    .font(.custom("Montserrat-Bold", size: 20))
                
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color("ButtonBackground"))
                    .frame(width: 85, height: 40)
            }
                .padding(.bottom, 10)
            
            Button(action: {
                playerVariables.currentView = .TitleScreenView
            }) {
                Text("BACK")
            }.buttonStyle(BasicButtonStyle())
            .padding(.bottom, 10)
        }.statusBar(hidden: true)
    }
}

struct JoinGameView_Preview: PreviewProvider {
    static var previews: some View {
        JoinGameView()
            .environmentObject(GameVariables())
            .previewLayout(.fixed(width: 896, height: 414))
    }
}
