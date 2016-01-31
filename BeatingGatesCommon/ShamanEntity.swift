//
//  ShamanEntity.swift
//  The Beating at the Gates
//
//  Created by Grant Butler on 1/31/16.
//  Copyright © 2016 Grant J. Butler. All rights reserved.
//

import GameplayKit
import SpriteKit

public protocol ShamanEntityDelegate: class {
	
	func summonMonster(monster: Monster, team: Team, laneIndex: Int) -> Bool
	
}

public class ShamanEntity: GKEntity, ControllerComponentDelegate {
	
	public weak var delegate: ShamanEntityDelegate?
	
	var teamComponent: TeamComponent {
		guard let teamComponent = componentForClass(TeamComponent.self) else { fatalError("A ShamanEntity must have a TeamComponent.") }
		return teamComponent
	}
	
	var controllerComponent: ControllerComponent {
		guard let controllerComponent = componentForClass(ControllerComponent.self) else { fatalError("A ShamanEntity must have a ControllerComponent.") }
		return controllerComponent
	}
	
	public init(team: Team) {
		super.init()
		
		let teamComponent = TeamComponent(team: team)
		addComponent(teamComponent)
		
		let renderComponent = RenderComponent(entity: self)
		addComponent(renderComponent)
		
		let controllerComponent = ControllerComponent(playerIndex: team.playerIndex)
		controllerComponent.delegate = self
		addComponent(controllerComponent)
		
		let orientationComponent = OrientationComponent(node: renderComponent.node)
		orientationComponent.direction = team.direction
		addComponent(orientationComponent)
		
		let spriteNode = SKSpriteNode(imageNamed: "Shaman")
		renderComponent.node.addChild(spriteNode)
	}
	
	public func performAction(gesture: Gesture) {
		switch gesture {
			case .Skeleton:
				delegate?.summonMonster(.Skeleton, team: teamComponent.team, laneIndex: controllerComponent.laneIndex)
			
			case .Snake:
				delegate?.summonMonster(.Snake, team: teamComponent.team, laneIndex: controllerComponent.laneIndex)
			
			case .Spider:
				delegate?.summonMonster(.Spider, team: teamComponent.team, laneIndex: controllerComponent.laneIndex)
			
			case .Attack:
				break
			
			default:
				break
		}
	}
	
}
