//
//  SkeletonEntity.swift
//  The Beating at the Gates
//
//  Created by Grant Butler on 1/30/16.
//  Copyright © 2016 Grant J. Butler. All rights reserved.
//

import GameplayKit
import SpriteKit

public class SkeletonEntity: GKEntity, EntityType {
	
	var renderComponent: RenderComponent {
		guard let renderComponent = componentForClass(RenderComponent.self) else { fatalError("A SkeletonEntity must have a RenderComponent.") }
		return renderComponent
	}
	
	public let team: Team
	
	var size: EntitySize {
		return .OneByOne
	}
	
	public init(team: Team) {
		self.team = team
		
		super.init()
		
		let renderComponent = RenderComponent(entity: self)
		addComponent(renderComponent)
		
		let orientationComponent = OrientationComponent(node: renderComponent.node)
		orientationComponent.direction = team.direction
		addComponent(orientationComponent)
		
		let intelligenceComponent = IntelligenceComponent(states: [
			MonsterIdleState(),
			MonsterMoveState(),
			MonsterAttackState()
		])
		addComponent(intelligenceComponent)
		
		let rulesComponent = RulesComponent(rules: [
			
		])
		
		let spriteNode = SKSpriteNode(imageNamed: "\(team)Skeleton")
		renderComponent.node.addChild(spriteNode)
	}
	
}
