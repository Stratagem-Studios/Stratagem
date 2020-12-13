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
        unitSprite.size = CGSize(width: Global.gameVars.screenSize.width/25, height: Global.gameVars.screenSize.width/20)
        spaceship.launched()
    }
    
    func timePassed(dt: CGFloat) -> Bool{
        travelDistance += dt * 20
        if travelDistance > travelGoal {
            print("e")
            unitSprite.removeFromParent()
            return true
        }
        unitSprite.position.x = (endPos.x - startPos.x) * travelPercent + startPos.x
        unitSprite.position.y = (endPos.y - startPos.y) * travelPercent + startPos.y
        print(travelDistance)
        travelPercent = travelDistance/travelGoal
        return false
    }
}
