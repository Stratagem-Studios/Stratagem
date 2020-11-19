//
//  Units.swift
//
//
//  Created by 90306997 on 11/11/20.
//

import Foundation

public enum UnitType {
    case swordsman, archer, knight
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
