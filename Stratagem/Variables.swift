//
//  Variables.swift
//  Stratagem
//
//  Created by 90306997 on 10/20/20.
//

// This file contains all the game variables locally
// Should consist of mostly structs
// Needs to be implemented

import Foundation

// enum keeps track of all possible materials
// Not sure if nessasary
enum materialTypes {
    case metal, gold
}

// Materials follow this pattern
// [enum, cooldownMax, timerLive, actual count]
var materialDefaultStats = [
    [materialTypes.metal, 2.0, 2.0, 0],
    [materialTypes.gold, 7.0, 7.0, 0]
]

class Variables {
    
    
    // Sets up the gameResourceList to contain all resource values
    var gameResources: [resourceStatsList] = []
    init() {
        for a in materialDefaultStats {
            gameResources.append(resourceStatsList(materialType: a[0] as? materialTypes, materialCooldown: a[1] as! Double, materialLiveTimer: a[2] as? Double))
        }
    }
}

struct resourceStatsList {
    var materialType: materialTypes?
    var materialCooldown: Double
    var materialLiveTimer: Double?
    var materialQuantity = 0
    

}

