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

	override func viewDidLoad() {
		super.viewDidLoad()
		
//		if let scene = TitleScene(fileNamed: "TitleScene") {
//            // Configure the view.
//            let skView = self.view as! SKView
//            skView.showsFPS = true
//            skView.showsNodeCount = true
//            
//            /* Sprite Kit applies additional optimizations to improve rendering performance */
//            skView.ignoresSiblingOrder = true
//            
//            /* Set the scale mode to scale to fit the window */
//            scene.scaleMode = .AspectFill
//			
//            skView.presentScene(scene)
//			
//			scene.status = "Looking for Games..."
//        }
        if let gameScene = DrawingScene(fileNamed: "DrawingScene") {
        
            let skView = self.view as! SKView
            skView.showsFPS = true
            skView.showsNodeCount = true
            
            skView.ignoresSiblingOrder = true
            
            gameScene.scaleMode = .AspectFill
            skView.presentScene(gameScene)
        }
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


}

