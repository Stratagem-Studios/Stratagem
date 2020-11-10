//
//  CityView.swift
//  Stratagem
//
//  Created by 64004080 on 11/9/20.
//

import SwiftUI
import SpriteKit

struct CityView: View {
    @EnvironmentObject var gameVariables: GameVariables
    
    var scene: SKScene {
        let scene = GameScene(fileNamed: "GameScene")
        //let scene = BasicScene()
        if let scene = scene {
            scene.size = CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
            //scene.scaleMode = .fill
            //scene.setContentView(tempContentView: self)
            return scene
        }
        return SKScene()
    }
    
    var body: some View {
        SpriteView(scene: scene)
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            .edgesIgnoringSafeArea(.all)
    }
}

struct CityView_Previews: PreviewProvider {
    static var previews: some View {
        CityView()
            .environmentObject(GameVariables())
            .previewLayout(.fixed(width: 896, height: 414))
    }
}
