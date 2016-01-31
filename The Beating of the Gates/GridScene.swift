//
//  GridScene.swift
//  The Beating at the Gates
//
//  Created by Grant Butler on 1/30/16.
//  Copyright © 2016 Grant J. Butler. All rights reserved.
//

import SpriteKit
import BeatingGatesCommon
import GameplayKit

class GridScene: SKScene {
	
	private var entities: Set<GKEntity> = Set()
	
	override func didMoveToView(view: SKView) {
		setupLanes(inView: view)
    }
	
	private func setupLanes(inView view: SKView) {
		removeAllChildren()
		
		let offset = round((view.frame.height - 640) / 2.0)
		for laneIndex in 0 ..< 5 {
			let laneNode = LaneNode(length: 10, alternate: laneIndex % 2 == 0)
			laneNode.name = "Lane\(laneIndex)"
			
			let calculatedFrame = laneNode.calculateAccumulatedFrame()
			laneNode.position = CGPoint(x: round((view.frame.width - calculatedFrame.width) / 2.0), y: CGFloat(laneIndex) * calculatedFrame.height + offset)
			
			addChild(laneNode)
		}
		
		let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(2 * Double(NSEC_PER_SEC)))
		dispatch_after(delayTime, dispatch_get_main_queue()) {
			self.spawnMonster(AlliedMonster(team: .Blue, monster: .Skeleton), lane: 0, column: 8)
		}
	}
	
	func spawnMonster(monster: AlliedMonster, lane: Int, column: Int) {
		guard let laneNode = childNodeWithName("Lane\(lane)") as? LaneNode else { return }
		guard column < laneNode.length else { return }
		guard let tileNode = laneNode.childNodeWithName("Tile\(column)") else { return }
		
		let calculatedTileNode = tileNode.calculateAccumulatedFrame()
		
		let entity = SkeletonEntity(team: monster.team)
		entities.insert(entity)
		
		if let renderNode = entity.componentForClass(RenderComponent.self)?.node {
			renderNode.position = CGPoint(x: calculatedTileNode.midX, y: calculatedTileNode.midY)
			renderNode.zPosition = 10
			laneNode.addChild(renderNode)
		}
	}
	
}
