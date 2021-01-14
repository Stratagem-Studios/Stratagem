import Foundation

class Spaceship {
    weak var currentCity: City?
    weak var currentPlanet: Planet?
    var units: [UnitType : Int]
    let owner: String = Global.playerVariables.playerName
    
    init(city: City, units: [UnitType : Int]) {
        currentCity = city
        self.units = units
    }
    
    // when a spaceship lands on a new city, assume that currentCity is up to date
    func landed() {
        if (currentCity!.owner == owner){
            for type in UnitType.allCases{
                currentCity!.units[type]! += units[type]!
            }
        } else {
            DispatchQueue.global(qos: .background).async {
                self.units = Global.combatHandler.cityCombat(attackingUnitList: self.units, defendingCity: self.currentCity!)
                let unitSum = self.units[.SNIPER]! + self.units[.FIGHTER]! + self.units[.BRAWLER]!
                if unitSum > 0 {
                    self.currentCity?.owner = self.owner
                    self.currentCity?.units = self.units
                    Global.hfGamePusher.updateOwnership(type: "cities", name: self.currentCity!.cityName, newOwner: Global.playerVariables.playerName)
                    Global.gameVars.alertBox.addAlert(msg: "Captured City " + String(self.currentCity!.cityName) + "!", rectColor: .blue)
                } else { Global.gameVars.alertBox.addAlert(msg: "Failed to Capture City  " + String(self.currentCity!.cityName), rectColor: .red) }
            }
        }
        Global.hfGamePusher.uploadUnits(cityName: currentCity!.cityName, units: currentCity!.units)
    }
}
