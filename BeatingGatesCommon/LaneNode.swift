//
//  LaneNode.swift
//  The Beating at the Gates
//
//  Created by Grant Butler on 1/30/16.
//  Copyright © 2016 Grant J. Butler. All rights reserved.
//

import SpriteKit

public class LaneNode: SKNode {
	
	public init(length: Int, alternate: Bool = false) {
		super.init()
		
		var xOffset: CGFloat = 0.0
		for tileIndex in 0 ..< length {
			let variant: Int = ((tileIndex + Int(alternate)) % 2) + 1
			let spriteNode = SKSpriteNode(imageNamed: "Dirt\(variant)")
			spriteNode.xScale = 0.5
			spriteNode.yScale = 0.5
			
			let calculatedFrame = spriteNode.calculateAccumulatedFrame()
			spriteNode.position = CGPoint(x: xOffset + calculatedFrame.maxX, y: calculatedFrame.height / 2.0)
			addChild(spriteNode)
			xOffset += calculatedFrame.width
		}
	}

	public required init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
	
	
	
}
