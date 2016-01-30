//
//  TitleScene.swift
//  spritekitgame
//
//  Created by Grant Butler on 1/30/16.
//  Copyright (c) 2016 Grant J. Butler. All rights reserved.
//

import SpriteKit

class TitleScene: SKScene {
	
	private var titleLabelNode: SKLabelNode!
	private var statusLabelNode: SKLabelNode!
	
	var status: String? {
		get {
			return statusLabelNode.text
		}
		set {
			statusLabelNode.text = newValue
		}
	}
	
	private func commonInit() {
		titleLabelNode = childNodeWithName("TitleLabelNode") as? SKLabelNode
		titleLabelNode.position = CGPoint(x: self.frame.midX, y: self.frame.midY * 3 / 2)
		statusLabelNode = childNodeWithName("StatusLabelNode") as? SKLabelNode
		statusLabelNode.alpha = 0.0
		statusLabelNode.position = CGPoint(x: self.frame.midX, y: self.frame.midY / 2)
	}
	
	override func didMoveToView(view: SKView) {
		commonInit()
    }
    
}
