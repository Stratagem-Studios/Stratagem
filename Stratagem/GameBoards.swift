import Foundation
import GameKit

enum TileType {
    case Rocky
}

class GameBoard {
    
    // Reference to tilemapNode
    var gameBoardTileNode: SKTileMapNode
    
    // This will get a ref to the tilemapNode
    init(tileMapNode: SKTileMapNode) {
        gameBoardTileNode = tileMapNode
    }
    
    // This variable holds the game Board array
    var gameBoard = gameBoardEmpty
    
    // These variables hold lists of the players units
    var player1Units = playerUnits(unitEnums: [UnitType.swordsman, UnitType.swordsman],
                                   unitPosition: [[0,0],[0,1]] as [[Int]] )
    var player2Units = playerUnits(unitEnums: [UnitType.swordsman, UnitType.swordsman],
                                   unitPosition: [[0,0],[0,1]] as [[Int]] )
    
    func TileTypeToGroup(tileType: TileType) -> SKTileGroup {
        switch tileType {
        case TileType.Rocky:
            return gameBoardTileNode.tileSet.tileGroups[0]
        default:
            exit(1)
        }
    }
}

struct GameCluster {
    var tilePiece: TileType?
    var isOccupied = false
}

// This struct is a list of units held by the players
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
let gameBoardEmpty =
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

