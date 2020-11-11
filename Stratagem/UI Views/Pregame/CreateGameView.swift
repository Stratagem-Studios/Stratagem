import SwiftUI
import SpriteKit

public struct CreateGameView: View {
    @EnvironmentObject var gameVariables: GameVariables
    let gameCode: String = GameManager().generateRandomGameCode()

    public var body: some View {
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
                
                HStack {
                    Text(gameCode)
                        .font(.custom("Montserrat-Bold", size: 20))
                        .background(Color("TitleBackground"))
                        .foregroundColor(Color.white)
                    Button(action: {
                        UIPasteboard.general.string = "CODE"
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
                    gameVariables.gameCode = self.gameCode
                    self.gameVariables.currentView = "GameLobbyView"
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
            .environmentObject(GameVariables())
            .previewLayout(.fixed(width: 896, height: 414))
    }
}
