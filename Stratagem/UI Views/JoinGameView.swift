import SwiftUI
import SpriteKit

struct JoinGameView: View {
    @EnvironmentObject var gameVariables: GameVariables

    var body: some View {
        VStack {
            TitleText(text: "STRATAGEM")
            
            Spacer()
            
            Button(action: {
                self.gameVariables.currentView = "CityView"
            }) {
                Text("PLAY")
            }.buttonStyle(BasicButtonStyle())
            .padding(.bottom, 10)
            
            Button(action: {
            }) {
                Text("CODE HERE")
            }.buttonStyle(BasicButtonStyle())
            .padding(.bottom, 10)
            
            Button(action: {
                    self.gameVariables.currentView = "TitleScreenView"
            }) {
                Text("BACK")
            }.buttonStyle(BasicButtonStyle())
        }.statusBar(hidden: true)
            //.navigate(to: JoinGameView(), when: $clickedJoin)
    }
}

struct JoinGameView_Preview: PreviewProvider {
    static var previews: some View {
        JoinGameView()
            .environmentObject(GameVariables())
            .previewLayout(.fixed(width: 896, height: 414))
    }
}
