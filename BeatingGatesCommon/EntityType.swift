//
//  EntityType.swift
//  The Beating at the Gates
//
//  Created by Grant Butler on 1/30/16.
//  Copyright © 2016 Grant J. Butler. All rights reserved.
//

import GameplayKit

enum EntitySize {
	
	case OneByOne
	case OneByTwo
	case TwoByTwo
	
}

protocol EntityType {
	
	var size: EntitySize { get }
	
}

protocol EntityLookAheadType {
	
	func lookAhead(tileCount: Int) -> WhatsAhead 
	
}
