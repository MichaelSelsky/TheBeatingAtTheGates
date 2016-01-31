//
//  WallEntity.swift
//  The Beating at the Gates
//
//  Created by Grant Butler on 1/31/16.
//  Copyright © 2016 Grant J. Butler. All rights reserved.
//

import GameplayKit
import SpriteKit

public class WallEntity: GKEntity {
	
	private lazy var minorDamageSmokeNode: SKEmitterNode = { [unowned self] in
		guard let smokePath = NSBundle(forClass: self.dynamicType).pathForResource("CastleDamagedParticle", ofType: "sks") else { fatalError("Missing CastleDamagedParticle") }
		let node = NSKeyedUnarchiver.unarchiveObjectWithFile(smokePath) as! SKEmitterNode
		node.hidden = true
		node.paused = true
		node.zPosition = 30
		return node
	}()
	
	private lazy var majorDamageSmokeNode: SKEmitterNode = { [unowned self] in
		guard let smokePath = NSBundle(forClass: self.dynamicType).pathForResource("CastleDamagedParticle", ofType: "sks") else { fatalError("Missing CastleDamagedParticle") }
		let node = NSKeyedUnarchiver.unarchiveObjectWithFile(smokePath) as! SKEmitterNode
		node.hidden = true
		node.paused = true
		node.zPosition = 30
		return node
	}()
	
	private lazy var explosionNode: SKEmitterNode = { [unowned self] in
		guard let smokePath = NSBundle(forClass: self.dynamicType).pathForResource("CastleExplosionParticle", ofType: "sks") else { fatalError("Missing CastleExplosionParticle") }
		let node = NSKeyedUnarchiver.unarchiveObjectWithFile(smokePath) as! SKEmitterNode
		node.hidden = true
		node.paused = true
		node.zPosition = 30
		return node
	}()
	
	var renderComponent: RenderComponent {
		guard let renderComponent = componentForClass(RenderComponent.self) else { fatalError("A WallEntity must have a RenderComponent.") }
		return renderComponent
	}
	
	var teamComponent: TeamComponent {
		guard let teamComponent = componentForClass(TeamComponent.self) else { fatalError("A WallEntity must have a TeamComponent.") }
		return teamComponent
	}
    
	public init(team: Team) {
		super.init()
		
		let teamComponent = TeamComponent(team: team)
		addComponent(teamComponent)
		
        let healthComponent = HealthComponent(health: 10)
        addComponent(healthComponent)
        
		let renderComponent = RenderComponent(entity: self)
		addComponent(renderComponent)
		
		let orientationComponent = OrientationComponent(node: renderComponent.node)
		orientationComponent.direction = team.direction
		addComponent(orientationComponent)
		
		let spriteNode = SKSpriteNode(imageNamed: "CastleWall")
		spriteNode.name = "CastleWall"
		renderComponent.node.addChild(spriteNode)
	}
	
	override public func updateWithDeltaTime(seconds: NSTimeInterval) {
		if let health = self.componentForClass(HealthComponent.self) {
			// Dead. Do some particle effects or something?
			
			if health.isDead() {
				if explosionNode.parent == nil {
					minorDamageSmokeNode.hidden = true
					minorDamageSmokeNode.paused = true
					minorDamageSmokeNode.removeFromParent()
					
					majorDamageSmokeNode.hidden = true
					majorDamageSmokeNode.paused = true
					majorDamageSmokeNode.removeFromParent()
					
					renderComponent.node.addChild(explosionNode)
					explosionNode.hidden = false
					explosionNode.paused = false
					
					let delay = SKAction.waitForDuration(0.25)
					let remove = SKAction.removeFromParent()
					renderComponent.node.runAction(SKAction.sequence([delay, remove]))
				}
			}
			else {
				switch health.health {
					case 4...7 where minorDamageSmokeNode.hidden:
						let castleWall = renderComponent.node.childNodeWithName("CastleWall")!
						let frame = castleWall.calculateAccumulatedFrame()
						let initialOffset = frame.width / 4.0

						minorDamageSmokeNode.position = CGPoint(x: initialOffset , y: frame.height / 4.0)
						renderComponent.node.addChild(minorDamageSmokeNode)
						minorDamageSmokeNode.hidden = false
						minorDamageSmokeNode.paused = false
					
					case 0...3 where majorDamageSmokeNode.hidden:
						let castleWall = renderComponent.node.childNodeWithName("CastleWall")!
						let frame = castleWall.calculateAccumulatedFrame()
						let initialOffset = frame.width / 4.0
						
						majorDamageSmokeNode.position = CGPoint(x: initialOffset , y: -frame.height /  4.0)
						
						renderComponent.node.addChild(majorDamageSmokeNode)
						majorDamageSmokeNode.hidden = false
						majorDamageSmokeNode.paused = false
					
					default:
						break
				}
			}
		}
	}
	
}
