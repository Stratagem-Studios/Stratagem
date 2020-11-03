import SwiftUI
import SpriteKit

struct ContentView: View {
    var scene: SKScene {
        let scene = GameScene(fileNamed: "GameScene")
        //let scene = BasicScene()
        if let scene = scene {
            scene.size = CGSize(width: 896, height: 414)
            //scene.scaleMode = .fill
            return scene
        }
        return SKScene()
    }

    var body: some View {
        ZStack {
            SpriteView(scene: scene)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                .edgesIgnoringSafeArea(.all)
            VStack {
                TitleText("STRATAGEM")
                Button(action: {
                    print("pressed button")
                }) {
                    Text("PLAY")
                }.buttonStyle(BasicButtonStyle())
            }
        }.statusBar(hidden: true)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().previewLayout(.fixed(width: 896, height: 414))
    }
}
