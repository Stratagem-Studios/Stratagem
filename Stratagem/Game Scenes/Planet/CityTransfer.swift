import Foundation
import SpriteKit
import SwiftUI

class CityTransfer {
    var units: [UnitType : Int] =
        [.SNIPER:0,
         .FIGHTER:0,
         .BRAWLER:0]
    var unitsAfterCombat: [UnitType : Int] =
        [.SNIPER:0,
         .FIGHTER:0,
         .BRAWLER:0]
    let startCity: City
    let endCity: City
    let endCityInt: Int
    let startCityLoc: CGPoint
    let endCityLoc: CGPoint
    var travelPercent: CGFloat = 0
    var travelDistance: CGFloat = 0
    var travelGoal: CGFloat = 0
    let unitSprite: SKSpriteNode
    var isDoneWithCombat = false
    var isAttack = false
    weak var map: PlanetMap?
    
    weak var planet = Global.gameVars.selectedPlanet!
    
    init(startCityInt: Int, endCityInt: Int, units: [UnitType : Int], isAttack: Bool) {
        self.units = units
        self.endCityInt = endCityInt
        self.startCity = planet!.cities[startCityInt]
        self.endCity = planet!.cities[endCityInt]
        startCityLoc = planet!.cityLocs[startCityInt]
        endCityLoc = planet!.cityLocs[endCityInt]
        map = planet!.planetMap
        unitSprite = map!.generateUnitSprite(loc: startCityLoc)
        travelGoal = sqrt((startCityLoc.x - endCityLoc.x) * (startCityLoc.x - endCityLoc.x) + (startCityLoc.y - endCityLoc.y) * (startCityLoc.y - endCityLoc.y))
        if endCity.owner != Global.playerVariables.playerName {
            DispatchQueue.global(qos: .background).async {
                self.startCombat()
            }
        } else {
            self.isAttack = false
        }
    }
    
    func timePassed(dt: CGFloat) -> Bool{
        travelDistance += dt * 20
        if travelDistance > travelGoal {
            if isAttack == false {
                // If friendly city
                endCity.units[.SNIPER]! += units[.SNIPER]!
                endCity.units[.FIGHTER]! += units[.FIGHTER]!
                endCity.units[.BRAWLER]! += units[.BRAWLER]!
            } else if isDoneWithCombat == true {
                // check combat result
                if unitsAfterCombat[UnitType.SNIPER]! + unitsAfterCombat[UnitType.FIGHTER]! + unitsAfterCombat[UnitType.BRAWLER]! > 0  {
                    endCity.units[.SNIPER]! += unitsAfterCombat[.SNIPER]!
                    endCity.units[.FIGHTER]! += unitsAfterCombat[.FIGHTER]!
                    endCity.units[.BRAWLER]! += unitsAfterCombat[.BRAWLER]!
                    endCity.owner = Global.playerVariables.playerName
                    let sprite = planet?.planetMap.citiesNode.children[endCityInt] as! SKSpriteNode
                    sprite.color = UIColor.blue
                }
                
            } else {return false}
            unitSprite.removeFromParent()
            return true
        }
        travelPercent = travelDistance/travelGoal
        unitSprite.position.x = (endCityLoc.x - startCityLoc.x) * travelPercent + startCityLoc.x
        unitSprite.position.y = (endCityLoc.y - startCityLoc.y) * travelPercent + startCityLoc.y
        return false
    }
    
    func startCombat(){
        isAttack = true
        unitsAfterCombat = Global.combatHandler.cityCombat(attackingUnitList: units, defendingCity: endCity)
        isDoneWithCombat = true
        print("----Done---")
        print(unitsAfterCombat)
    }
}
