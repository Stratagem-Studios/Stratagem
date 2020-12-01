import SpriteKit
import Foundation


class Updater: SKScene {
    override func update(_ currentTime: TimeInterval) {
        print(Global.gameVars)
        Global.gameVars?.update(currentTime: currentTime)
    }
    override func sceneDidLoad() {
        print("g")
        print(Global.gameVars)
    }
}
