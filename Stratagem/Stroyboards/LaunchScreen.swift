//
//  LaunchScreen.swift
//  Stratagem
//
//  Created by 90306997 on 10/25/20.
//

import Foundation
import UIKit
import SpriteKit
import GameplayKit

class LaunchScreen: UIViewController {
    override func viewDidLoad() {
        weak var activityIndicator: UIActivityIndicatorView!
        activityIndicator.style = .large
        activityIndicator.color = .red
        activityIndicator.startAnimating()
    }
}
