import SpriteKit
import Foundation


class Updater: SKScene {
    var lastTime: Float?
    override func update(_ currentTime: TimeInterval) {
        if lastTime != nil{
            Global.gameVars?.update(deltaTime: Float(currentTime) - lastTime!)
            lastTime = Float(currentTime)
        }
        else {lastTime = Float(currentTime)}
    }
}
