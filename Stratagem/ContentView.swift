import SwiftUI
import SpriteKit

struct ContentView: View {
    var scene: SKScene {
        let scene = GameScene(fileNamed: "GameScene")
        //let scene = BasicScene()
        if let scene = scene {
            scene.size = CGSize(width: 300, height: 300)
            scene.scaleMode = .fill
            return scene
        }
        return SKScene()
    }

    var body: some View {
        ZStack {
            SpriteView(scene: scene)
                .frame(width: 300, height: 300)
            Button(action: {
                print("pressed button")
            }) {
                Text("SwiftUI Button")
            }
        }.statusBar(hidden: true)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().previewLayout(.fixed(width: 896, height: 414))
    }
}
