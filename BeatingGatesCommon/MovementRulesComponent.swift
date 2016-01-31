/*
    Copyright (C) 2015 Apple Inc. All Rights Reserved.
    See LICENSE.txt for this sample’s licensing information
    
    Abstract:
    A `GKComponent` and associated delegate that manage and respond to a `GKRuleSystem` for an entity.
*/

import GameplayKit

public protocol MovementRulesComponentDelegate: class {
    // Called whenever the rules component finishes evaluating its rules.
    func rulesComponent(rulesComponent: MovementRulesComponent, didFinishEvaluatingRuleSystem ruleSystem: GKRuleSystem)
}

struct EntitySnapshot {
	
	let isEnemyAhead: Bool
	let isEmptyAhead: Bool
	
}

public class MovementRulesComponent: GKComponent {
    // MARK: Properties
    
    public weak var delegate: MovementRulesComponentDelegate?
    
    public var ruleSystem: GKRuleSystem
    
    // MARK: Initializers
    
    public override init() {
        ruleSystem = GKRuleSystem()
    }
    
    public init(rules: [GKRule]) {
        ruleSystem = GKRuleSystem()
        ruleSystem.addRulesFromArray(rules)
    }
	
	public func updateWithTick(tick: UInt) {
		guard let entity = entity as? EntityLookAheadType else {
            return
        }
		
		ruleSystem.reset()
        
        let ahead = entity.lookAhead()
        ruleSystem.state["forwardIsEnemy"] = false
        ruleSystem.state["forwardIsEmpty"] = false
        
        switch ahead {
        case .Enemy(_):
           ruleSystem.state["forwardIsEnemy"] = true
        case .Empty:
            ruleSystem.state["forwardIsEmpty"] = true
        default:
            break
        }
		
		ruleSystem.evaluate()
		
		delegate?.rulesComponent(self, didFinishEvaluatingRuleSystem: ruleSystem)
    }
    
}
