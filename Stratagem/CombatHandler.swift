import Foundation

class CombatHandler {
    
    // accepts the attack units and defending city
    // returns the remaining attacking units after they attack the defending city
    // see bottom for specifics
    func cityCombat( attackingUnitList: [UnitType : Int], defendingCity: City) -> [UnitType : Int]{
        var attackingUnits = attackingUnitList
        var defendingUnits = defendingCity.units
        var eliminatedDefendingUnits: [UnitType : Int] = [.SNIPER: 0, .FIGHTER: 0, .BRAWLER: 0]
        var eliminatedAttackingUnits: [UnitType : Int] = [.SNIPER: 0, .FIGHTER: 0, .BRAWLER: 0]
        
        print("started")
        // at the moment, combat is just a series of random dice rolls where specific units are better at eliminating others
        // Snipers < Fighters < Brawlers < Snipers...
        /// Checks attacking units * defending units to see if a side has been wiped out
        while ((attackingUnits[.SNIPER]! + attackingUnits[.FIGHTER]! + attackingUnits[.BRAWLER]!) *
                (defendingUnits[.SNIPER]! + defendingUnits[.FIGHTER]! + defendingUnits[.BRAWLER]!) > 0) {
            
            for type in UnitType.allCases {
                if attackingUnits[type]! + defendingUnits[type]! > 0 {
                    for _ in 0..<attackingUnits[type]! {
                        let hitUnits: (UnitType, Int) = unitAttack(attackingUnitType: type, enemyArmy: defendingUnits)
                        eliminatedDefendingUnits[hitUnits.0]! += hitUnits.1
                    }
                    for _ in 0..<defendingUnits[type]! {
                        let hitUnits: (UnitType, Int) = unitAttack(attackingUnitType: type, enemyArmy: attackingUnits)
                        eliminatedAttackingUnits[hitUnits.0]! += hitUnits.1
                    }
                }
            }
            
            // After we finish calculating one round of combat, we need to apply causualties
            print("round finished")
            print( "eliminated attackers: \(eliminatedAttackingUnits)")
            print( "eliminated defenders: \(eliminatedDefendingUnits)")
            for type in UnitType.allCases {
                attackingUnits[type]! -= eliminatedAttackingUnits[type]!
                if attackingUnits[type]! < 0 {
                    attackingUnits[type] = 0
                }
                defendingUnits[type]! -= eliminatedDefendingUnits[type]!
                if defendingUnits [type]! < 0 {
                    defendingUnits[type] = 0
                }
                eliminatedDefendingUnits[type] = 0
                eliminatedAttackingUnits[type] = 0
            }
            print(attackingUnits)
            print(defendingUnits)
        }
        defendingCity.units = defendingUnits
        return attackingUnits
    }
    
    
    func unitAttack(attackingUnitType: UnitType, enemyArmy: [UnitType : Int]) -> (UnitType, Int) {
        var hitUnits: (UnitType, Int) = (UnitType.SNIPER, 0)
        var weights: [UnitType : Float] = [.BRAWLER: 0, .SNIPER: 0, .FIGHTER: 0]
        let hitPercent: Float
        
        switch attackingUnitType {
        case .SNIPER:
            weights[.SNIPER] = 10
            weights[.FIGHTER] = 50
            weights[.BRAWLER] = 40
            hitPercent = 80
            
            // UNIQUE
            if Float.random(in: 0..<1) < 0.2 { hitUnits.1 += 1 }
            
        case .FIGHTER:
            weights[.SNIPER] = 30
            weights[.FIGHTER] = 40
            weights[.BRAWLER] = 50
            hitPercent = 70
            
        case .BRAWLER:
            weights[.SNIPER] = 25
            weights[.FIGHTER] = 45
            weights[.BRAWLER] = 30
            hitPercent = 50
        }
        

        for type in UnitType.allCases {
            if enemyArmy[type] == 0 {
                weights[type] = 0
            }
        }
        
        // checks if unit missed
        if Float(Double.random(in: 1...100)) > hitPercent { return (UnitType.SNIPER, 0) }
        
        let total = weights[.SNIPER]! + weights[.FIGHTER]! + weights[.BRAWLER]!
        
        let i = Float.random(in: 0...total)
        switch i {
        case 0..<weights[.SNIPER]!:
            hitUnits.0 = UnitType.SNIPER
            hitUnits.1 = 1
            
        case weights[.SNIPER]!..<(weights[.SNIPER]! + weights[.FIGHTER]!):
            hitUnits.0 = UnitType.FIGHTER
            hitUnits.1 = 1
            
        case (weights[.SNIPER]! + weights[.FIGHTER]!)..<total:
            hitUnits.0 = UnitType.BRAWLER
            hitUnits.1 = 1
            
        default:
            fatalError("00x34gh456")
        }
        return hitUnits
    }
    
}
/*
 --> HOW THE UNITS FIGHT EACH OTHER <--
 
 each unit has a kill %, which determines whether this unit will eliminate another unit or not
 upon a hit, a unit has a particular kill distribution; a set of percents totaling 1 that define what unit type the opponent will lose
 additionally, some units have UNIQUE abilities that are outlined in their description
 unit causualties are not put into effect unill after the round has ended, all units present at the begening of a round will have a change to attack
 
 
 SNIPERS
    % to kill: 80
    distribution:
        snipers: .10
        fighters: .50
        brawlers: .40
    UNIQUE: upon a hit, has a 20% chance to take out two of the selected unit
    
    Snipers are the main damage source, and very good at mowing down fighters and bralwers
    Snipers strugge to deal with each other unit all of the other units have been dealt with
 
 FIGHTERS
    % to kill: 70
    distribution:
        snipers: .30
        fighters: .40
        brawlers: .50
    
    fighters are the counter to snipers, but get destroyed pretty quickly
 
 BRAWLERS
    % to kill: 50
    distribution:
        snipers: .25
        fighters: .45
        brawlers: .30
    UNIQUE: at the end of combat, 1/3 of the brawlers eliminated will respawn
 
    brawlers are very good at tanking shots, however they do not protect fighters very well
 
 */
