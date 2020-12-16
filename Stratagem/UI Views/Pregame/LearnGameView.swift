import SwiftUI
import SpriteKit

public struct LearnGameView: View {
    @EnvironmentObject var playerVariables: PlayerVariables
    
    public var body: some View {
        VStack {
            TitleText(text: "LEARN")
                .padding(.top, 10)
            
            ScrollView {
                VStack {
                    Text("Stratagem is a game of interplanetary warfare and a struggle to control the galaxy. The main parts of Stratagem are building and warfare. When you start the game, you will be provided one random planet within the galaxy. You start with no resource generation, so it is important to get generators up first. Following that, prioritize residential and military buildings to expand your population and army. As soon as possible, conquer the remaining cities on your planet. Once you have a solid foundation on you'r home world, build a spaceship to explore and conquer the rest of the galaxy!")
                        .font(.custom("Montserrat-Bold", size: 15))
                        .foregroundColor(.white)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding()
                }
            }
            
            HStack {
                Button(action: {
                    playerVariables.currentView = .TitleScreenView
                }) {
                    Text("BACK")
                }.buttonStyle(BasicButtonStyle())
                .padding(.bottom, 10)
            }
        }.statusBar(hidden: true)
    }
}

struct LearnGameView_Preview: PreviewProvider {
    static var previews: some View {
        CreateGameView()
            .environmentObject(PlayerVariables())
            .previewLayout(.fixed(width: 896, height: 414))
    }
}

