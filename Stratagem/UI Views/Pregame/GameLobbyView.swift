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
                            Global.lfGameManager!.removePlayerFromGame(username: playerName)
                        }) {
                            Image("Close")
                        }
                    }
                    Text(playerName)
                        .font(.custom("Montserrat-Bold", size: 15))
                        .foregroundColor(Color.white)
                        .padding()
                }
            }
            
            Spacer()
            
            HStack {
                Button(action: {
                    if staticGameVariables.leaderName == playerVariables.playerName {
                        Global.lfGameManager!.removeGame()
                    } else {
                        Global.lfGameManager!.removePlayerFromGame(username: playerVariables.playerName)
                    }
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
                    if Global.gameVars!.finishedGeneratingGalaxy {
                        Global.lfGameManager!.startGame()
                    } else {
                        Global.playerVariables.errorMessage = "Please wait until the game has finished generating the galaxy"
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
            .environmentObject(PlayerVariables())
            .previewLayout(.fixed(width: 896, height: 414))
    }
}

