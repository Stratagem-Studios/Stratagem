//
//  GameBoardStruct.swift
//  Stratagem
//
//  Created by 90306997 on 10/21/20.
//

import Foundation

enum tileTypes {
    case metalBonus, goldBonus
    case forrest, clearing, river
}

class GameBoardStruct {
    var gameBoard = planets()
}

struct planets {
    var citiesLayout = [cities(), cities(), cities()]
}

struct cities {
    var tileLayout = [
        [tileTypes.forrest, tileTypes.forrest, tileTypes.forrest, tileTypes.forrest, tileTypes.forrest, tileTypes.forrest, tileTypes.forrest,],
        [tileTypes.forrest, tileTypes.forrest, tileTypes.forrest, tileTypes.forrest, tileTypes.forrest, tileTypes.forrest, tileTypes.forrest,],
        [tileTypes.forrest, tileTypes.forrest, tileTypes.forrest, tileTypes.forrest, tileTypes.forrest, tileTypes.forrest, tileTypes.forrest,],
        [tileTypes.forrest, tileTypes.forrest, tileTypes.forrest, tileTypes.forrest, tileTypes.forrest, tileTypes.forrest, tileTypes.forrest,],
        [tileTypes.forrest, tileTypes.forrest, tileTypes.forrest, tileTypes.forrest, tileTypes.forrest, tileTypes.forrest, tileTypes.forrest,],
        [tileTypes.forrest, tileTypes.forrest, tileTypes.forrest, tileTypes.forrest, tileTypes.forrest, tileTypes.forrest, tileTypes.forrest,],
        [tileTypes.forrest, tileTypes.forrest, tileTypes.forrest, tileTypes.forrest, tileTypes.forrest, tileTypes.forrest, tileTypes.forrest,],
    ]
}


