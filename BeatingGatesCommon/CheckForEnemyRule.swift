//
//  CheckForEnemyRule.swift
//  The Beating at the Gates
//
//  Created by Grant Butler on 1/30/16.
//  Copyright © 2016 Grant J. Butler. All rights reserved.
//

import GameplayKit

class CheckForEnemyRule: GKRule {
	
	let entity: EntityType
	
	init(entity: EntityType) {
		self.entity = entity
	}
	
	override func evaluatePredicateWithSystem(system: GKRuleSystem) -> Bool {
		return false
	}
	
	override func performActionWithSystem(system: GKRuleSystem) {
		
	}
	
}
