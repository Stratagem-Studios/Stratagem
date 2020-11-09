import SwiftUI
import SpriteKit

struct TitleScreenView: View {
    @EnvironmentObject var gameVariables: GameVariables

    //@State var gameStarted = false
    
    //var scene: SKScene {
    //    let scene = GameScene(fileNamed: "GameScene")
      //  //let scene = BasicScene()
    //    if let scene = scene {
    //        scene.size = CGSize(width: 896, height: 414)
    //        //scene.scaleMode = .fill
     //       scene.setContentView(tempContentView: self)
       //     return scene
        //}
       // return SKScene()
    //}

    var body: some View {
        //if !gameStarted {
            VStack {
                TitleText(text: "STRATAGEM")
                
                Spacer()
                
                Button(action: {
                    //gameStarted = true
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
                    //gameStarted = true
                }) {
                    Text("LEARN")
                }.buttonStyle(BasicButtonStyle())
            }.statusBar(hidden: true)
            //.navigate(to: JoinGameView(), when: $clickedJoin)
        
        //} else {
        //    SpriteView(scene: scene)
        //        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        //        .edgesIgnoringSafeArea(.all)
        //}
    }
}

struct TitleScreenView_Previews: PreviewProvider {
    static var previews: some View {
        TitleScreenView()
            .environmentObject(GameVariables())
            .previewLayout(.fixed(width: 896, height: 414))
    }
}
