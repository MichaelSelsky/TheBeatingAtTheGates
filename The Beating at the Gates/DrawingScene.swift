//
//  DrawingScene.swift
//  The Beating at the Gates
//
//  Created by MichaelSelsky on 1/30/16.
//  Copyright © 2016 Grant J. Butler. All rights reserved.
//

import UIKit
import SpriteKit

class DrawingScene: SKScene {
    // MARK: Touch Handling
    
    private var sparkles: [SKEmitterNode] = []
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        handleTouches(touches)
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        handleTouches(touches)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        handleTouches(touches)
    }
    
    private func handleTouches(touches: Set<UITouch>) {
//        var count = 0
        for touch in touches {
            let touchLocation = touch.locationInNode(self)
//            if count % 5 == 0 {
                guard let emitterNode = SKEmitterNode(fileNamed: "Magic") else {
                    break
                }
                emitterNode.position = touchLocation
                
                let waitAction = SKAction.waitForDuration(1.0, withRange: 0.1)
                let fadeAction = SKAction.fadeOutWithDuration(1.0)
                let removeAction = SKAction.removeFromParent()
                
                let combinedAction = SKAction.sequence([waitAction, fadeAction, removeAction])
                
                emitterNode.runAction(combinedAction)
                
                self.addChild(emitterNode)
                sparkles.append(emitterNode)

                
//            }
//            count += 1
        }
    }
}
