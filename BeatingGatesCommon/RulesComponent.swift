/*
    Copyright (C) 2015 Apple Inc. All Rights Reserved.
    See LICENSE.txt for this sample’s licensing information
    
    Abstract:
    A `GKComponent` and associated delegate that manage and respond to a `GKRuleSystem` for an entity.
*/

import GameplayKit

public protocol RulesComponentDelegate: class {
    // Called whenever the rules component finishes evaluating its rules.
    func rulesComponent(rulesComponent: RulesComponent, didFinishEvaluatingRuleSystem ruleSystem: GKRuleSystem)
}

public class RulesComponent: GKComponent {
    // MARK: Properties
    
    public weak var delegate: RulesComponentDelegate?
    
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
		ruleSystem.reset()
		
//		ruleSystem.state["snapshot"] = entitySnapshot
		
		ruleSystem.evaluate()
		
		delegate?.rulesComponent(self, didFinishEvaluatingRuleSystem: ruleSystem)
    }
}
