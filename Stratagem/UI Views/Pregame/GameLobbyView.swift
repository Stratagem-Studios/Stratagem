import SwiftUI
import SpriteKit

public struct GameLobbyView: View {
    @EnvironmentObject var playerVariables: PlayerVariables
    @EnvironmentObject var staticGameVariables: StaticGameVariables
    
    public var body: some View {
        VStack {
            TitleText(text: "LOBBY")
                .padding(.top, 10)
            
            ForEach(staticGameVariables.playerNames, id: \.self) { playerName in
                HStack {
                    if staticGameVariables.leaderName == playerName {
                        Image("Star")
                    } else if staticGameVariables.leaderName == playerVariables.playerName {
                        Button(action: {
                            GameManager(playerVariables: playerVariables, staticGameVariables: staticGameVariables).removePlayerFromGame(username: playerName)
                        }) {
                            Image("Close")
                        }
                    }
                    Text(playerName).padding()
                }
            }
            
            Spacer()
            
            HStack {
                Button(action: {
                    GameManager(playerVariables: playerVariables, staticGameVariables: staticGameVariables).removeGame()
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
                    GameManager(playerVariables: playerVariables, staticGameVariables: staticGameVariables).startGame()
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

