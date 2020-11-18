/*
 README
 
 This file contains the setup for the game board
 
 gameBoard -> 10x10 gameClusters
 gameCluster -> 5x5 gameTiles
 
 game tile
 
 
 */

import Foundation

func createGameBoard() -> GameBoard{
    let newGameBoard = GameBoard()
    return newGameBoard
}

enum tileTypes {
    case Rocky
}

class GameBoard {
    var gameBoard =
        [
            [GameCluster(),GameCluster(),GameCluster(),GameCluster(),GameCluster(),GameCluster(),GameCluster(),GameCluster(),GameCluster(),GameCluster()],
            [GameCluster(),GameCluster(),GameCluster(),GameCluster(),GameCluster(),GameCluster(),GameCluster(),GameCluster(),GameCluster(),GameCluster()],
            [GameCluster(),GameCluster(),GameCluster(),GameCluster(),GameCluster(),GameCluster(),GameCluster(),GameCluster(),GameCluster(),GameCluster()],
            [GameCluster(),GameCluster(),GameCluster(),GameCluster(),GameCluster(),GameCluster(),GameCluster(),GameCluster(),GameCluster(),GameCluster()],
            [GameCluster(),GameCluster(),GameCluster(),GameCluster(),GameCluster(),GameCluster(),GameCluster(),GameCluster(),GameCluster(),GameCluster()],
            [GameCluster(),GameCluster(),GameCluster(),GameCluster(),GameCluster(),GameCluster(),GameCluster(),GameCluster(),GameCluster(),GameCluster()],
            [GameCluster(),GameCluster(),GameCluster(),GameCluster(),GameCluster(),GameCluster(),GameCluster(),GameCluster(),GameCluster(),GameCluster()],
            [GameCluster(),GameCluster(),GameCluster(),GameCluster(),GameCluster(),GameCluster(),GameCluster(),GameCluster(),GameCluster(),GameCluster()],
            [GameCluster(),GameCluster(),GameCluster(),GameCluster(),GameCluster(),GameCluster(),GameCluster(),GameCluster(),GameCluster(),GameCluster()],
            [GameCluster(),GameCluster(),GameCluster(),GameCluster(),GameCluster(),GameCluster(),GameCluster(),GameCluster(),GameCluster(),GameCluster()],
        ]
    var player1Units = playerUnits(unitEnums: [UnitType.swordsman, UnitType.swordsman],
                                   unitPosition: [[0,0],[0,1]] as [[Int]] )
    var player2Units = playerUnits(unitEnums: [UnitType.swordsman, UnitType.swordsman],
                                  unitPosition: [[0,0],[0,1]] as [[Int]] )
}

struct GameCluster {
    var tilePiece = tileTypes.Rocky
}

struct playerUnits {
    // Holds all the units for this player
    var unitArray: [Unit]
    
    init(unitEnums: [UnitType], unitPosition: [[Int]]){
        unitArray = [Unit(unitType: UnitType.swordsman, position: [10,10])]
        for i in 0..<unitEnums.count {
            unitArray.append(
                Unit(unitType: unitEnums[i], position: unitPosition[i])
            )
        }
    }
    
    // Should be run constantly to cause battles
    func updateUnits() {
        
    }
}

// Holds some defualt player setups

// Holds some default map setups
