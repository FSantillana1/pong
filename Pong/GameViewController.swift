//
//  GameViewController.swift
//  Pong
//
//  Created by Fernando Santillana on 20/10/26.
//
import UIKit
import SpriteKit

final class GameViewController: UIViewController {
    
    private var hasPresentedScene = false
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard !hasPresentedScene, let skView = view as? SKView else { return }
        hasPresentedScene = true
        
        let scene = GameScene(size: skView.bounds.size)
        scene.scaleMode = .resizeFill
        
        skView.ignoresSiblingOrder = true
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.presentScene(scene)
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask { .portrait }
    override var prefersStatusBarHidden: Bool { true }
    override var prefersHomeIndicatorAutoHidden: Bool { true }
}
