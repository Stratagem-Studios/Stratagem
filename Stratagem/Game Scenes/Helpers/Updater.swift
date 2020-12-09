import SpriteKit
import Foundation


class Updater: SKScene {
    var lastTime: Float?
    override func update(_ currentTime: TimeInterval) {
        if lastTime != nil {
            Global.gameVars?.update(deltaTime: CGFloat(currentTime) - CGFloat(lastTime!))
            lastTime = Float(currentTime)
        }
        else {lastTime = Float(currentTime)}
    }
    override func sceneDidLoad() {
        backgroundColor = UIColor.clear
    }
}
