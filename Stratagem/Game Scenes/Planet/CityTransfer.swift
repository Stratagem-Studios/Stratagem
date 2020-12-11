import Foundation
import SpriteKit
import SwiftUI

class CityTransfer {
    var units: [UnitType : Int] =
        [.SNIPER:0,
         .FIGHTER:0,
         .BRAWLER:0]
    let startCity: City
    let endCity: City
    let startCityLoc: CGPoint
    let endCityLoc: CGPoint
    var travelPercent: CGFloat = 0
    var travelDistance: CGFloat = 0
    var travelGoal: CGFloat = 0
    let unitSprite: SKSpriteNode
    weak var map: PlanetMap?
    
    weak var planet = Global.gameVars.selectedPlanet!
    
    init(startCityInt: Int, endCityint: Int, units: [UnitType : Int]) {
        self.units = units
        self.startCity = planet!.cities[startCityInt]
        self.endCity = planet!.cities[endCityint]
        startCityLoc = planet!.cityLocs[startCityInt]
        endCityLoc = planet!.cityLocs[endCityint]
        map = planet!.planetMap
        unitSprite = map!.generateUnitSprite(loc: startCityLoc)
        travelGoal = sqrt((startCityLoc.x - endCityLoc.x) * (startCityLoc.x - endCityLoc.x) + (startCityLoc.y - endCityLoc.y) * (startCityLoc.y - endCityLoc.y))
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
        unitSprite.position.x = (endCityLoc.x - startCityLoc.x) * travelPercent + startCityLoc.x
        unitSprite.position.y = (endCityLoc.y - startCityLoc.y) * travelPercent + startCityLoc.y
        return false
    }
}
