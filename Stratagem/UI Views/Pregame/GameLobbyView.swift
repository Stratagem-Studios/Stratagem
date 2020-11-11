import SwiftUI
import SpriteKit

public struct GameLobbyView: View {
    @EnvironmentObject var gameVariables: GameVariables

    public var body: some View {
        VStack {
            TitleText(text: "LOBBY")
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
                    Text(gameVariables.gameCode)
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
                    let createdGame = GameManager().createGameWithCode(code: gameVariables.gameCode)
                    
                    if createdGame {
                        self.gameVariables.currentView = "CityView"
                    } else {
                        // inform failure
                    }
                }) {
                    Text("START")
                }.buttonStyle(BasicButtonStyle())
                .padding(.bottom, 10)
            }
        }.statusBar(hidden: true)
    }
}

struct GameLobbyView_Preview: PreviewProvider {
    static var previews: some View {
        GameLobbyView()
            .environmentObject(GameVariables())
            .previewLayout(.fixed(width: 896, height: 414))
    }
}

