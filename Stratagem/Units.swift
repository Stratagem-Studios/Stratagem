//
//  Units.swift
//  
//
//  Created by 90306997 on 11/11/20.
//

import Foundation

let unitArrays =
    // Holds the default stats for the various units
    [
        // Swordsman
        [],
        
        // Archer
        [],
        
        // Knight
        []
    ]

enum UnitType {
    case swordsman, archer, knight
}

func spawnSwordsman() {
    let swordsman = Units(unitType: UnitType.swordsman)
    
}

class Units {
    var unitType: UnitType
    var health: Double
    var damage: Double
    var range: Double
    var moveSpeed: Double
    var attackSpeed: Double
    
    init(unitType: UnitType) {
        
        self.unitType = unitType
        
        switch unitType {
        case.swordsman :
            health = 100
            damage = 10
            range = 20
            moveSpeed = 30
            attackSpeed = 15
            
        case.archer :
            health = 100
            damage = 10
            range = 20
            moveSpeed = 30
            attackSpeed = 15
            
        case.knight :
            health = 100
            damage = 10
            range = 20
            moveSpeed = 30
            attackSpeed = 15
        }
    }
}
