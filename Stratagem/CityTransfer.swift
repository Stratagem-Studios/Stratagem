import Foundation
import SpriteKit

class CityTransfers {
    var units: [UnitType : Int] =
        [.SNIPER:0,
         .FIGHTER:0,
         .BRAWLER:0]
    var startCity: City
    var endCity: City
    var travelPercent: Float = 0
    
    weak var planet = Global.gameVars.selectedPlanet!
    
    init(startCityInt: Int, endCityint: Int, units: [UnitType : Int]) {
        self.units = units
        self.startCity = planet!.cities[startCityInt]
        self.endCity = planet!.cities[endCityint]
    }
    
    func timePassed(dt: Float){
        
    }
}
