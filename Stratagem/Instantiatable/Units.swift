import Foundation

public enum UnitType {
    case SWORDSMAN, ARCHER, KNIGHT, FIGHTER
}

class Unit {
    var unitType: UnitType
    var health: Double
    var damage: Double
    var range: Double
    var moveSpeed: Double
    var attackSpeed: Double
    var position: [Int]
    
    init(unitType: UnitType, position: [Int]) {
        
        self.unitType = unitType
        self.position = position
        
        switch unitType {
        case.SWORDSMAN :
            health = 100
            damage = 10
            range = 20
            moveSpeed = 30
            attackSpeed = 15
            
        case.ARCHER :
            health = 100
            damage = 10
            range = 20
            moveSpeed = 30
            attackSpeed = 15
            
        case.KNIGHT :
            health = 100
            damage = 10
            range = 20
            moveSpeed = 30
            attackSpeed = 15
        case.FIGHTER :
            health = 100
            damage = 10
            range = 20
            moveSpeed = 30
            attackSpeed = 15
        }
    }
}
