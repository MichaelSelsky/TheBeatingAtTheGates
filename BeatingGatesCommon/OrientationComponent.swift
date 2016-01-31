//
//  OrientationComponent.swift
//  The Beating at the Gates
//
//  Created by Grant Butler on 1/30/16.
//  Copyright © 2016 Grant J. Butler. All rights reserved.
//

import GameplayKit
import SpriteKit

public enum Direction: Int {
	
	case Left = -1
	case Right = 1
	
}

public class OrientationComponent: GKComponent {
	
	public var direction: Direction = .Right {
		didSet {
			self.node?.xScale *= CGFloat(direction.rawValue)
		}
	}
	
	public private(set) weak var node: SKNode?
	
	public init(node: SKNode) {
		self.node = node
	}
	
}
