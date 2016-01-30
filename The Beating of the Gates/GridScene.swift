//
//  GridScene.swift
//  The Beating at the Gates
//
//  Created by Grant Butler on 1/30/16.
//  Copyright © 2016 Grant J. Butler. All rights reserved.
//

import SpriteKit
import BeatingGatesCommon

class GridScene: SKScene {
	
	override func didMoveToView(view: SKView) {
		setupLanes(inView: view)
    }
	
	private func setupLanes(inView view: SKView) {
		removeAllChildren()
		
		let offset = round((view.frame.height - 640) / 2.0)
		for laneIndex in 0 ..< 5 {
			let laneNode = LaneNode(length: 10, alternate: laneIndex % 2 == 0)
			
			let calculatedFrame = laneNode.calculateAccumulatedFrame()
			laneNode.position = CGPoint(x: round((view.frame.width - calculatedFrame.width) / 2.0), y: CGFloat(laneIndex) * calculatedFrame.height + offset)
			
			addChild(laneNode)
		}
	}
	
}
