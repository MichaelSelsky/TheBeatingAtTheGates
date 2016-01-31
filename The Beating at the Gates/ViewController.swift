//
//  ViewController.swift
//  The Beating of the Gates
//
//  Created by Grant Butler on 1/29/16.
//  Copyright © 2016 Grant J. Butler. All rights reserved.
//

import UIKit
import SpriteKit
import BeatingGatesCommon

class ViewController: UIViewController {
    
    var gameController: GameController!
    var peripheral: Peripheral?

	override func viewDidLoad() {
		super.viewDidLoad()
        
        gameController = GameController(connectionHandler: { (peripheral) -> Void in
            self.peripheral = peripheral
            self.connected()
            }, disconnectionHandler: { (peripheral) -> Void in
                self.peripheral = nil
                self.showTitleScene()
        })
		
		showTitleScene()
	}
    
    func connected() {
        playSummoner()
    }
    
    func playSummoner() {
        if let gameScene = DrawingScene(fileNamed: "DrawingScene") {
            gameScene.gestureHandler = { (gesture) in
                self.gameController.handleGesture(gesture)
            }
            let skView = self.view as! SKView
            skView.showsFPS = true
            skView.showsNodeCount = true
            
            skView.ignoresSiblingOrder = true
            
            gameScene.scaleMode = .AspectFill
            skView.presentScene(gameScene)
        }
    }
    
    func showTitleScene() {
        if let scene = TitleScene(fileNamed: "TitleScene") {
            // Configure the view.
            let skView = self.view as! SKView
            skView.showsFPS = true
            skView.showsNodeCount = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            
            gameController.start()
            
            skView.presentScene(scene)
            
            scene.status = "Looking for Games..."
        }
    }
    

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


}

