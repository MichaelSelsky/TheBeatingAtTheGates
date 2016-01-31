//
//  SkeletonEntity.swift
//  The Beating at the Gates
//
//  Created by Grant Butler on 1/30/16.
//  Copyright © 2016 Grant J. Butler. All rights reserved.
//

import GameplayKit
import SpriteKit
import Foundation

enum WhatsAhead {
    case Empty
    case Friendly
    case Enemy(GKEntity)
}

public class SkeletonEntity: GKEntity, EntityType, EntityLookAheadType, MovementRulesComponentDelegate {
	
	var renderComponent: RenderComponent {
		guard let renderComponent = componentForClass(RenderComponent.self) else { fatalError("A SkeletonEntity must have a RenderComponent.") }
		return renderComponent
	}
	
	var teamComponent: TeamComponent {
		guard let teamComponent = componentForClass(TeamComponent.self) else { fatalError("A SkeletonEntity must have a TeamComponent.") }
		return teamComponent
	}
    
    var movementRulesComponent: MovementRulesComponent
    var intelligenceComponent: IntelligenceComponent
	
	var size: EntitySize {
		return .OneByOne
	}
	
	public init(team: Team) {
        intelligenceComponent = IntelligenceComponent(states: [
            MonsterIdleState(),
            MonsterMoveState(),
            MonsterAttackState()
            ])
        
        var rules: [GKRule] = []
        
        let enemyPredicate = NSPredicate(format: "$forwardIsEnemy==true")
        let enemyRule = GKRule(predicate: enemyPredicate, assertingFact: "attack", grade: 1.0)
        rules.append(enemyRule)
        
        let emptyPredicate = NSPredicate(format: "$forwardIsEmpty==true")
        let emptyRule = GKRule(predicate: emptyPredicate, assertingFact: "move", grade: 1.0)
        rules.append(emptyRule)
        
        movementRulesComponent = MovementRulesComponent(rules: rules)
		
		super.init()
		
		let teamComponent = TeamComponent(team: team)
		addComponent(teamComponent)
		
        let healthComponent = HealthComponent(health: 3)
        addComponent(healthComponent)
        
		let renderComponent = RenderComponent(entity: self)
		addComponent(renderComponent)
		
		let orientationComponent = OrientationComponent(node: renderComponent.node)
		orientationComponent.direction = team.direction
		addComponent(orientationComponent)
		
		
		addComponent(intelligenceComponent)
        addComponent(movementRulesComponent)
        
        
        movementRulesComponent.delegate = self
		
		let spriteNode = SKSpriteNode(imageNamed: "\(team)Skeleton")
		renderComponent.node.addChild(spriteNode)
	}
    
    public func rulesComponent(rulesComponent: MovementRulesComponent, didFinishEvaluatingRuleSystem ruleSystem: GKRuleSystem) {
        if ruleSystem.gradeForFact("attack") == 1.0 {
            self.intelligenceComponent.stateMachine.enterState(MonsterAttackState.self)
        }
        if ruleSystem.gradeForFact("move") == 1.0 {
            self.intelligenceComponent.stateMachine.enterState(MonsterMoveState.self)
        }
    }
    
    func lookAhead() -> WhatsAhead {
        let point = ahead()
        let unknownNode = self.renderComponent.node.parent?.nodeAtPoint(point)
        guard let node =  unknownNode?.parent as? EntityNode else {
            return .Empty
        }
		guard let aheadTeamComponent = node.entity.componentForClass(TeamComponent.self) else {
			return .Empty
		}
        if aheadTeamComponent.team == teamComponent.team {
            return .Friendly
        } else {
            return .Enemy(node.entity)
        }
    }
    
    public override func updateWithDeltaTime(seconds: NSTimeInterval) {
        guard let state = self.intelligenceComponent.stateMachine.currentState else {
            return
        }
        defer {
            self.intelligenceComponent.enterInitialState()
        }
        if let _ = state as? MonsterMoveState {
            let f = SKAction.moveByX(deltaX(), y: 0.0, duration: 1.0)
            self.renderComponent.node.runAction(f)
        }
        else if let _ = state as? MonsterAttackState {
            let enemyAhead = lookAhead()
            switch enemyAhead{
            case .Enemy(let entity):
                let f = SKAction.moveByX(deltaX()/3.0, y: 0, duration: 0.5)
                let b = SKAction.moveByX(-1*deltaX()/3.0, y: 0, duration: 0.5)
                self.renderComponent.node.runAction(SKAction.sequence([f, b])) {
                    let healthComponent = entity.componentForClass(HealthComponent.self)
                    healthComponent?.damage(1)
                }
            default:
                return
            }
            if let health = self.componentForClass(HealthComponent.self) where health.isDead() {
                let d = SKAction.rotateByAngle(CGFloat(M_PI_2), duration: 0.5)
                let resize = SKAction.scaleBy(0.5, duration: 0.5)
                let combo = SKAction.group([d, resize])
                let r = SKAction.removeFromParent()
                self.renderComponent.node.runAction(SKAction.sequence([combo, r]))
                
            }
        }
    }
    
    public func ahead() -> CGPoint {
        let currentX = self.renderComponent.node.position.x
        let dX = deltaX()
        let x = currentX + dX
        return CGPoint(x: x, y: self.renderComponent.node.position.y)
    }
    
    private func deltaX() -> CGFloat {
        var deltaX = self.renderComponent.node.children.first!.frame.width
        if teamComponent.team.direction == .Left {
            deltaX *= -1
        }
        return deltaX
    }

	
}
