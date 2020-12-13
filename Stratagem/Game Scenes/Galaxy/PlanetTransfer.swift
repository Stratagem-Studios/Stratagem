import Foundation
import SpriteKit
import SwiftUI

class PlanetTransfer {
    var units: [UnitType : Int] =
        [.SNIPER:0,
         .FIGHTER:0,
         .BRAWLER:0]
    let endCity: City
    var travelPercent: CGFloat = 0
    var travelDistance: CGFloat = 0
    var travelGoal: CGFloat = 0
    let unitSprite: SKSpriteNode
    weak var map: Galaxy?
    
    weak var planet = Global.gameVars.selectedPlanet!
    
    init(startCityInt: Int, endCityint: Int, units: [UnitType : Int]) {
        self.units = units
        self.endCity = planet!.cities[endCityint]
    }
    
    func timePassed(dt: CGFloat) -> Bool{
        travelDistance += dt * 20
        if travelDistance > travelGoal {
            endCity.units[.SNIPER]! += units[.SNIPER]!
            endCity.units[.FIGHTER]! += units[.FIGHTER]!
            endCity.units[.BRAWLER]! += units[.BRAWLER]!
            unitSprite.removeFromParent()
            return true
        }
        travelPercent = travelDistance/travelGoal
        return false
    }
}
