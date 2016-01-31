//
//  DrawingScene.swift
//  The Beating at the Gates
//
//  Created by MichaelSelsky on 1/30/16.
//  Copyright © 2016 Grant J. Butler. All rights reserved.
//

import UIKit
import SpriteKit
import CoreGraphics
import CMUnistrokeGestureRecognizer
import BeatingGatesCommon

class DrawingScene: SKScene {
    // MARK: Touch Handling
    var magicNodes: Set<SKEmitterNode> = []
    var gestureRecognizer: CMUnistrokeGestureRecognizer!
    
    var gestureHandler: (Gesture -> Void)?
    
    func commonInit() {
        
        let crossPath = UIBezierPath()
        crossPath.moveToPoint(CGPoint(x:5.0,y:0))
        crossPath.addLineToPoint(CGPoint(x:5.0,y:10.0))
        crossPath.addLineToPoint(CGPoint(x:0.0,y:5.0))
        crossPath.addLineToPoint(CGPoint(x:10.0, y:5.0))
        
        let linePath = UIBezierPath()
        linePath.moveToPoint(CGPoint(x: 0.0, y: 0.0))
        linePath.addLineToPoint(CGPoint(x:0, y: 5))
        
        let circlePath = UIBezierPath(ovalInRect: CGRect(x: 0.0, y: 0.0, width: 10.0, height: 10.0))
        
        let squigglePath = UIBezierPath()
        squigglePath.moveToPoint(CGPoint(x:0.0, y: 10.0))
        squigglePath.addLineToPoint(CGPoint(x:5.0, y: 0.0))
        squigglePath.addLineToPoint(CGPoint(x:10.0, y: 10.0))
        squigglePath.addLineToPoint(CGPoint(x:15.0, y: 0.0))
        squigglePath.addLineToPoint(CGPoint(x:20.0, y: 10.0))
        
        let upPath = UIBezierPath()
        upPath.moveToPoint(CGPoint(x: 5.0, y: 0.0))
        upPath.addLineToPoint(CGPoint(x: 5.0, y: 10.0))
        upPath.addLineToPoint(CGPoint(x: 10.0, y: 5.0))
        upPath.addLineToPoint(CGPoint(x: 5.0, y: 10.0))
        upPath.addLineToPoint(CGPoint(x: 0.0, y: 5.0))
        
        let downPath = UIBezierPath()
        downPath.moveToPoint(CGPoint(x: 5.0, y: 10.0))
        downPath.addLineToPoint(CGPoint(x: 5.0, y: 0.0))
        downPath.addLineToPoint(CGPoint(x: 10.0, y: 5.0))
        downPath.addLineToPoint(CGPoint(x: 5.0, y: 0.0))
        downPath.addLineToPoint(CGPoint(x: 0.0, y: 5.0))
        
        let pausePath = UIBezierPath(ovalInRect: CGRect(x: 0, y: 0, width: 3, height: 3))
        pausePath.addLineToPoint(CGPoint(x:3.0, y:6.0))
        let mirrorTransform = CGAffineTransformMakeScale(1.0, -1.0)
        pausePath.applyTransform(mirrorTransform)
        
        let attackPath1 = UIBezierPath()
        attackPath1.moveToPoint(CGPoint(x: 5.0, y: 0.0))
        attackPath1.addLineToPoint(CGPoint(x: 0.0, y: 5.0))
        attackPath1.addLineToPoint(CGPoint(x: 5.0, y: 10.0))
        
        let attackPath2 = UIBezierPath()
        attackPath2.moveToPoint(CGPoint(x: 0.0, y: 0.0))
        attackPath2.addLineToPoint(CGPoint(x: 5.0, y: 5.0))
        attackPath2.addLineToPoint(CGPoint(x: 0.0, y: 10.0))
        
        
        gestureRecognizer = CMUnistrokeGestureRecognizer(target: self, action: "recognizedShape:")
        gestureRecognizer.registerUnistrokeWithName("cross", bezierPath:crossPath, bidirectional: true)
        gestureRecognizer.registerUnistrokeWithName("circle", bezierPath:circlePath, bidirectional: true)
        gestureRecognizer.registerUnistrokeWithName("squiggle", bezierPath:squigglePath)
        gestureRecognizer.registerUnistrokeWithName("down", bezierPath:downPath)
        gestureRecognizer.registerUnistrokeWithName("up", bezierPath:upPath)
        gestureRecognizer.registerUnistrokeWithName("pause", bezierPath:pausePath, bidirectional: true)
        gestureRecognizer.registerUnistrokeWithName("attack", bezierPath:attackPath1)
        gestureRecognizer.registerUnistrokeWithName("attack", bezierPath:attackPath2)
        
        gestureRecognizer.minimumScoreThreshold = 0.70
//        gestureRecognizer.registerUnistrokeWithName("line", bezierPath:linePath)
        
        self.view?.addGestureRecognizer(gestureRecognizer)
        
    }
    
    override func didMoveToView(view: SKView) {
        commonInit()
    }
    
//    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        handleTouches(touches)
//    }
//    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        handleTouches(touches)
    }
    
    private func handleTouches(touches: Set<UITouch>) {

        for touch in touches {
            let touchLocation = touch.locationInNode(self)
                guard let emitterNode = SKEmitterNode(fileNamed: "Magic") else {
                    break
                }
                emitterNode.position = touchLocation
                
                let waitAction = SKAction.waitForDuration(1.5, withRange: 0.1)
                let fadeAction = SKAction.fadeOutWithDuration(1.0)
                let removeAction = SKAction.removeFromParent()
                
                let combinedAction = SKAction.sequence([waitAction, fadeAction, removeAction])
                
                emitterNode.runAction(combinedAction)
                
                self.addChild(emitterNode)
                magicNodes.insert(emitterNode)
        }
    }
    
    func recognizedShape(recognizer: CMUnistrokeGestureRecognizer) {
        print(recognizer.result.recognizedStrokeName)
        for node in magicNodes {
            node.particleColor = UIColor.redColor()
            node.particleColorSequence = nil
        }
        
        var gesture: Gesture?
        
        switch recognizer.result.recognizedStrokeName {
        case "cross":
            gesture = .Skeleton
        case "squiggle":
            gesture = .Snake
        case "circle":
            gesture = .Spider
        case "up":
            gesture = .Up
        case "down":
            gesture = .Down
        case "pause":
            gesture = .Pause
        case "attack":
            gesture = .Attack
        default:
            gesture = nil
        }
        
        if let gesture = gesture, gestureHandler = gestureHandler {
            gestureHandler(gesture)
        }
    }
}
