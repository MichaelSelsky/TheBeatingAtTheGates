//
//  ControllerComponent.swift
//  The Beating at the Gates
//
//  Created by Grant Butler on 1/31/16.
//  Copyright © 2016 Grant J. Butler. All rights reserved.
//

import GameplayKit
import SpriteKit

public protocol ControllerComponentDelegate: class {
	
	func performAction(gesture: Gesture)
	
}

public enum InputButton {
	
	case A
	case B
	case X
	case Y
	case DpadUp
	case DpadDown
	
}

extension InputButton {
	
	public var gesture: Gesture {
		switch self {
			case .A:
				return .Skeleton
			
			case .B:
				return .Snake
			
			case .X:
				return .Spider
			
			case .Y:
				return .Attack
			
			case .DpadDown:
				return .Down
			
			case .DpadUp:
				return .Up
		}
	}
	
	var isDirectional: Bool {
		switch self.gesture {
			case .Up, .Down:
				return true
			
			default:
				return false
		}
	}
	
}

public class ControllerComponent: GKComponent {
	
	public let playerIndex: Int
	public let laneCount = 5
	public private(set) var laneIndex = 2
	
	public weak var delegate: ControllerComponentDelegate?
	
	public init(playerIndex: Int) {
		self.playerIndex = playerIndex
		
		super.init()
	}
	
	public func handleInput(input: InputButton) {
		if input.isDirectional {
			if input == .DpadUp {
				guard laneIndex < laneCount - 1 else { return }
			}
			
			if input == .DpadDown {
				guard laneIndex > 0 else { return }
			}
			
			guard let entity = entity else { return }
			guard let renderComponent = entity.componentForClass(RenderComponent.self) else { return }
			var increment = renderComponent.node.calculateAccumulatedFrame().height
			if input == .DpadDown {
				increment *= -1.0
			}
			let action = SKAction.moveByX(0, y: increment, duration: 0.5)
			renderComponent.node.runAction(action)
			
			if input == .DpadUp {
				laneIndex += 1
			}
			else if input == .DpadDown {
				laneIndex -= 1
			}
		}
		else {
			delegate?.performAction(input.gesture)
		}
	}
	
}
