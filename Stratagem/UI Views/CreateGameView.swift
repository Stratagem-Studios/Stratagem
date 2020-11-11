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
                
                HStack {
                    Text("CODE")
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
                    var createdGame = GameManager().createGame()
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
