import Foundation
import SpriteKit
import SwiftUI

class PlanetTransfer {
    let spaceship: Spaceship
    let endCity: City
    let startPos: CGPoint
    let endPos: CGPoint
    
    var travelPercent: CGFloat = 0
    var travelDistance: CGFloat = 0
    var travelGoal: CGFloat = 0
    let unitSprite: SKSpriteNode
    
    weak var planet = Global.gameVars.selectedPlanet!
    
    init(ship: Spaceship, endCityint: Int, startPos: CGPoint, endPos: CGPoint) {
        spaceship = ship
        self.endCity = planet!.cities[endCityint]
        self.startPos = startPos
        self.endPos = endPos
        travelGoal = sqrt((startPos.x - endPos.x) * (startPos.x - endPos.x) + (startPos.y - endPos.y) * (startPos.y - endPos.y))
        unitSprite = SKSpriteNode(imageNamed: "Spaceship")
        unitSprite.size = CGSize(width: Global.gameVars.screenSize.width/30, height: Global.gameVars.screenSize.width/30)
        unitSprite.isUserInteractionEnabled = false
        unitSprite.zRotation = shipAngle(start: startPos, end: endPos)
        spaceship.launched()
    }
    
    func timePassed(dt: CGFloat) -> Bool{
        travelDistance += dt * 20
        if travelDistance > travelGoal {
            unitSprite.removeFromParent()
            return true
        }
        unitSprite.position.x = (endPos.x - startPos.x) * travelPercent + startPos.x
        unitSprite.position.y = (endPos.y - startPos.y) * travelPercent + startPos.y
        travelPercent = travelDistance/travelGoal
        return false
    }
    func shipAngle(start: CGPoint, end: CGPoint) -> CGFloat {
        let deltaX = Float(end.x - start.x)
        let deltaY = Float(end.y - start.y)
        let pi = CGFloat(Double.pi)
        let angle = CGFloat(atan2f(deltaY, deltaX))
        var newAngle = angle
        if angle < (-pi / 2) { newAngle += 2 * pi }
        return newAngle - pi/2
    }
}
