import SwiftUI

struct TitleScreenView: View {
    @EnvironmentObject var gameVariables: GameVariables

    var body: some View {
            VStack {
                TitleText(text: "STRATAGEM")
                
                Spacer()
                
                Button(action: {
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
