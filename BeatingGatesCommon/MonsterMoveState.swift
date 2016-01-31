//
//  MonsterMoveState.swift
//  The Beating at the Gates
//
//  Created by Grant Butler on 1/30/16.
//  Copyright © 2016 Grant J. Butler. All rights reserved.
//

import GameplayKit

class MonsterMoveState: GKState {
	
	override func isValidNextState(stateClass: AnyClass) -> Bool {
		return stateClass is MonsterIdleState.Type
	}
	
}
