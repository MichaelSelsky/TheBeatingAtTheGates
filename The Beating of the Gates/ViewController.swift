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
    
    let controllerInput = ControllerInput()

	override func viewDidLoad() {
		super.viewDidLoad()
		
		if let scene = TitleScene(fileNamed: "TitleScene") {
            // Configure the view.
            let skView = self.view as! SKView
            skView.showsFPS = true
            skView.showsNodeCount = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            
            controllerInput.start()
            
            skView.presentScene(scene)
			
			if let gridScene = GridScene(fileNamed: "GridScene") {
				let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(5 * Double(NSEC_PER_SEC)))
				dispatch_after(delayTime, dispatch_get_main_queue()) {
					skView.presentScene(gridScene, transition: SKTransition.crossFadeWithDuration(1.0))
				}
			}
        }
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


}

