//
//  GameViewController.swift
//  Stratagem
//
//  Created by 90306997 on 10/20/20.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        gameWindowOpen(isTrue: true)
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func gameWindowOpen(isTrue: Bool){
        if isTrue{
            // Load 'GameScene.sks' as a GKScene. This provides gameplay related content
            if let scene = GKScene(fileNamed: "GameScene") {
                // Get the SKScene from the loaded GKScene
                if let sceneNode = scene.rootNode as! GameScene? {
                    // Set the scale mode to scale to fit the window
                    sceneNode.scaleMode = .aspectFill
                    // Present the scene
                    if let view = self.view as! SKView? {
                        view.presentScene(sceneNode)
                    }
                }
            }
        } else {
            // Excact same proceduce with MenuScene
            if let scene = GKScene(fileNamed: "MenuScene") {
                if let sceneNode = scene.rootNode as! GameScene? {
                    sceneNode.scaleMode = .aspectFill
                    if let view = self.view as! SKView? {
                        view.presentScene(sceneNode)
                    }
                }
            }
        }
    }
}
