//
//  GameStructures.swift
//  The Beating at the Gates
//
//  Created by Grant Butler on 1/30/16.
//  Copyright © 2016 Grant J. Butler. All rights reserved.
//

import UIKit

public enum Team: String {
	
	case Red
	case Blue
	
}

extension Team {
	
	public var color: UIColor {
		switch self {
			case .Blue:
				return .blueColor()
			
			case .Red:
				return .redColor()
		}
	}
	
	public var direction: Direction {
		switch self {
			case .Blue:
				return .Left
			
			case .Red:
				return .Right
		}
	}
	
}

public enum Role: String {
	
	case Summoner
	case Drummer
	
}

public enum Monster: String {

	case Skeleton
	case Snake
	case Spider
	
}

public struct AlliedMonster {
	
	public let team: Team
	public let monster: Monster
	
	public init(team: Team, monster: Monster) {
		self.team = team
		self.monster = monster
	}
	
}

extension AlliedMonster {
	
	public var assetName: String {
		return "\(team)\(monster)"
	}
	
}
