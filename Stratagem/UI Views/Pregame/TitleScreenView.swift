import SwiftUI

public struct TitleScreenView: View {
    @EnvironmentObject var gameVariables: GameVariables

    public var body: some View {
            VStack {
                TitleText(text: "STRATAGEM")
                    .padding(.top, 10)
                
                Spacer()
                
                Button(action: {
                    gameVariables.currentView = "CreateGameView"
                }) {
                    Text("PLAY")
                }.buttonStyle(BasicButtonStyle())
                .padding(.bottom, 10)
                
                Button(action: {
                    gameVariables.currentView = "JoinGameView"
                }) {
                    Text("JOIN")
                }.buttonStyle(BasicButtonStyle())
                .padding(.bottom, 10)
                
                Button(action: {
                }) {
                    Text("LEARN")
                }.buttonStyle(BasicButtonStyle())
                .padding(.bottom, 10)
            }.statusBar(hidden: true)
    }
}

struct TitleScreenView_Previews: PreviewProvider {
    static var previews: some View {
        TitleScreenView()
            .environmentObject(GameVariables())
            .previewLayout(.fixed(width: 896, height: 414))
    }
}
