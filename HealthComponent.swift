//
//  HealthComponent.swift
//  The Beating at the Gates
//
//  Created by MichaelSelsky on 1/31/16.
//  Copyright © 2016 Grant J. Butler. All rights reserved.
//

import GameKit

public class HealthComponent: GKComponent {
    private(set) var health: Int
    private let maxHealth: Int
    
    init(health: Int) {
        self.health = health
        self.maxHealth = health
    }
    
    func damage(damage: Int) {
        health -= damage
    }
    
    func heal(regen: Int) {
        health += regen
        if health > maxHealth {
            health = maxHealth
        }
    }
    
    public func isDead() -> Bool {
        return health <= 0
    }

}
