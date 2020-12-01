import SpriteKit
import Foundation


class Updater: SKScene {
    override func update(_ currentTime: TimeInterval) {
        Global.gameVars?.update(currentTime: currentTime)
    }
}
