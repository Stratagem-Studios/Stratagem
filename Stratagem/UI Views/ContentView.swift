import SwiftUI
import SpriteKit

struct ContentView: View {
    @State var gameStarted = false
    var scene: SKScene {
        let scene = GameScene(fileNamed: "GameScene")
        //let scene = BasicScene()
        if let scene = scene {
            scene.size = CGSize(width: 896, height: 414)
            //scene.scaleMode = .fill
            scene.setContentView(tempContentView: self)
            return scene
        }
        return SKScene()
    }

    var body: some View {
        if !gameStarted {
            ZStack {
                VStack {
                    TitleText(text: "STRATAGEM")
                    Button(action: {
                        gameStarted = true
                    }) {
                        Text("PLAY")
                    }.buttonStyle(BasicButtonStyle())
                }
            }.statusBar(hidden: true)
        } else {
            SpriteView(scene: scene)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                .edgesIgnoringSafeArea(.all)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().previewLayout(.fixed(width: 896, height: 414))
    }
}
