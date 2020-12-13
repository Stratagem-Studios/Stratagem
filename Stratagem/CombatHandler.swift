import Foundation

class CombatHandler {
    
    // accepts the attack units and defending city
    // returns the remaining attacking units after they attack the defending city
    // see bottom for specifics
    func cityCombat(attackingUnits: [UnitType : Int], defendingCity: City) -> [UnitType : Int]{
        let defendingUnits = defendingCity.units
        var eliminatedDefendingUnits: [UnitType : Int] = [.BRAWLER: 0, .SNIPER: 0, .FIGHTER: 0]
        var eliminatedAttackingUnits: [UnitType : Int] = [.BRAWLER: 0, .SNIPER: 0, .FIGHTER: 0]
        
        // at the moment, combat is just a series of random dice rolls where specific units are better at eliminating others
        // Snipers < Fighters < Brawlers < Snipers...
        /// Checks attacking units * defending units to see if a side has been wiped out
        while ((attackingUnits[.SNIPER]! + attackingUnits[.FIGHTER]! + attackingUnits[.BRAWLER]!) *
                (defendingUnits[.SNIPER]! + defendingUnits[.FIGHTER]! + defendingUnits[.BRAWLER]!) > 0) {
            
            for type in UnitType.allCases {
                if attackingUnits[type]! * defendingUnits[type]! > 0 {
                    for _ in 0..<attackingUnits[type]! {
                        let hitUnits: (UnitType, Int) = unitAttack(attackingUnitType: type)
                        eliminatedDefendingUnits[hitUnits.0]! += hitUnits.1
                    }
                    for _ in 0..<defendingUnits[type]! {
                        let hitUnits: (UnitType, Int) = unitAttack(attackingUnitType: type)
                        eliminatedAttackingUnits[hitUnits.0]! += hitUnits.1
                    }
                }
            }
            
            // After we finish calculating one round of combat, we need to apply causualties
            for type in UnitType.allCases {
            }
        }
        defendingCity.units = defendingUnits
        return attackingUnits
    }
    
    
    func unitAttack(attackingUnitType: UnitType) -> (UnitType, Int) {
        let hitUnits: (UnitType, Int)
        let sniperWeight: Float
        let fighterWeight: Float
        let brawlerWeight: Float
        let hitPercent: Float
        
        switch attackingUnitType {
        case .SNIPER:
            sniperWeight = 10
            fighterWeight = 50
            brawlerWeight = 40
            hitPercent = 0.8
        case .FIGHTER:
            sniperWeight = 30
            fighterWeight = 40
            brawlerWeight = 50
            hitPercent = 0.7
        case .BRAWLER:
            sniperWeight = 25
            fighterWeight = 45
            brawlerWeight = 30
            hitPercent = 0.5
        }
        let total = sniperWeight + fighterWeight + brawlerWeight
        
        let i = Float.random(in: 0...total)
        switch i {
        case 0..<sniperWeight:
            hitUnits.0 = UnitType.SNIPER
            hitUnits.1 = 1
        case sniperWeight..<(sniperWeight + fighterWeight):
            hitUnits.0 = UnitType.SNIPER
            hitUnits.1 = 1
        case (sniperWeight + fighterWeight)..<total:
            hitUnits.0 = UnitType.SNIPER
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
