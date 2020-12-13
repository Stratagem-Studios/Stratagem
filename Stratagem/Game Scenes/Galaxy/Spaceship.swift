import Foundation

class Spaceship {
    weak var currentCity: City?
    var units: [UnitType : Int]
    
    init(city: City, units: [UnitType : Int]) {
        currentCity = city
        self.units = units
    }
    
    // when a rocket is put in transit
    func launched() {
        
    }
    
    // when a spaceship lands on a new city, assume that currentCity is up to date
    func landed() {
        
    }
}
