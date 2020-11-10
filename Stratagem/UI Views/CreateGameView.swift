import SwiftUI
import SpriteKit

struct CreateGameView: View {
    @EnvironmentObject var gameVariables: GameVariables

    var body: some View {
        VStack {
            TitleText(text: "OPTIONS")
                .padding(.top, 10)
            
            Spacer()
            
            HStack {
                Button(action: {
                    self.gameVariables.currentView = "TitleScreenView"
                }) {
                    Text("BACK")
                }.buttonStyle(BasicButtonStyle())
                .padding(.bottom, 10)
                
                Spacer()
                
                Button(action: {
                }) {
                    Text("CODE")
                }.buttonStyle(BasicButtonStyle())
                .padding(.bottom, 10)
                
                Spacer()
                
                Button(action: {
                        self.gameVariables.currentView = "CityView"
                }) {
                    Text("PLAY")
                }.buttonStyle(BasicButtonStyle())
                .padding(.bottom, 10)
            }
        }.statusBar(hidden: true)
    }
}

struct CreateGameView_Preview: PreviewProvider {
    static var previews: some View {
        CreateGameView()
            .environmentObject(GameVariables())
            .previewLayout(.fixed(width: 896, height: 414))
    }
}
