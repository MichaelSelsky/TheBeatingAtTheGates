//
//  GridScene.swift
//  The Beating at the Gates
//
//  Created by Grant Butler on 1/30/16.
//  Copyright © 2016 Grant J. Butler. All rights reserved.
//

import SpriteKit
import BeatingGatesCommon
import GameplayKit
import BBGroover
import AudioKit

private let MaxLaneCount = 5
private let MaxTileCount = 10

class GridScene: SKScene, BBGrooverDelegate, ShamanEntityDelegate {
	
	private var entities: Set<GKEntity> = Set()
	var previousTime = NSTimeIntervalSince1970
	
	var inputHandler: ControllerInputHandler {
		return { (input: InputButton, playerIndex: Int) -> Void in
			self.handleInput(input, playerIndex: playerIndex)
		}
	}
	
	private lazy var groover: BBGroover = { [unowned self] in
		let voice = BBVoice(values: [true, true, true, true], andVelocities: [127, 80, 40, 80])
		
		let groove = BBGroove()
		groove.tempo = 105
		groove.beatUnit = BBGrooverBeat(rawValue: 4)
		groove.beats = 4
		groove.addVoice(voice)
		
		let groover = BBGroover(groove: groove)
		groover.delegate = self
		return groover
	}()
	
	private let drumMachine = DrumMachine()
	
	private let rulesComponentSystem = GKComponentSystem(componentClass: MovementRulesComponent.self)
	private let controllerComponentSystem = GKComponentSystem(componentClass: ControllerComponent.self)
	
	override func didMoveToView(view: SKView) {
		AudioKit.output = drumMachine
		AudioKit.start()
		
		reset()
    }
	
	func reset() {
		removeAllChildren()
		
		entities = Set()
		
		if let view = view {
			setupLanes(inView: view)
			setupCastles(inView: view)
			setupShamans(inView: view)
		}
		
		groover.groove.tempo = 105
		groover.startGrooving()
	}
	
	private func setupLanes(inView view: SKView) {
		let offset = round((view.frame.height - 640) / 2.0)
		for laneIndex in 0 ..< MaxLaneCount {
			let laneNode = LaneNode(length: MaxTileCount, alternate: laneIndex % 2 == 0)
			laneNode.name = "Lane\(laneIndex)"
			
			let calculatedFrame = laneNode.calculateAccumulatedFrame()
			laneNode.position = CGPoint(x: round((view.frame.width - calculatedFrame.width) / 2.0), y: CGFloat(laneIndex) * calculatedFrame.height + offset)
			
			addChild(laneNode)
		}
	}
	
	private func setupCastles(inView view: SKView) {
		for team in Team.allValues {
			let wallEntity = WallEntity(team: team)
			
			entities.insert(wallEntity)
			
			if let renderNode = wallEntity.componentForClass(RenderComponent.self)?.node {
				guard let middleLane = childNodeWithName("Lane3") else { return }
			
				let x: CGFloat = {
					let middleLaneFrame = middleLane.calculateAccumulatedFrame()
					switch team.direction {
						case .Left:
							return middleLaneFrame.maxX + renderNode.calculateAccumulatedFrame().width / 2.0 - 26.0
						
						case .Right:
							return middleLaneFrame.minX - renderNode.calculateAccumulatedFrame().width / 2.0 + 26.0
					}
				}()
				
				renderNode.position = CGPoint(x: x, y: view.frame.midY)
				renderNode.zPosition = 20
				addChild(renderNode)
			}
		}
	}
	
	private func setupShamans(inView view: SKView) {
		for team in Team.allValues {
			let shamanEntity = ShamanEntity(team: team)
			shamanEntity.delegate = self
			
			entities.insert(shamanEntity)
			
			if let renderNode = shamanEntity.componentForClass(RenderComponent.self)?.node {
				guard let middleLane = childNodeWithName("Lane3") else { return }
			
				let x: CGFloat = {
					let middleLaneFrame = middleLane.calculateAccumulatedFrame()
					switch team.direction {
						case .Left:
							return middleLaneFrame.maxX + renderNode.calculateAccumulatedFrame().width
						
						case .Right:
							return middleLaneFrame.minX - renderNode.calculateAccumulatedFrame().width
					}
				}()
				
				renderNode.position = CGPoint(x: x, y: view.frame.midY)
				renderNode.zPosition = 15
				addChild(renderNode)
			}
			
			if let controllerComponent = shamanEntity.componentForClass(ControllerComponent.self) {
				controllerComponentSystem.addComponent(controllerComponent)
			}
		}
	}
	
	func spawnMonster(monster: AlliedMonster, lane: Int, column: Int) -> Bool {
		guard let laneNode = childNodeWithName("Lane\(lane)") as? LaneNode else { return false }
		guard column < laneNode.length else { return false }
		guard let tileNode = laneNode.childNodeWithName("Tile\(column)") else { return false }
		
		let calculatedTileNode = tileNode.calculateAccumulatedFrame()
		let tileNodeCenter = CGPoint(x: calculatedTileNode.midX, y: calculatedTileNode.midY)
		let entityCenter = self.convertPoint(tileNodeCenter, fromNode: laneNode)
		
		guard let nodeName = self.nodeAtPoint(entityCenter).name where nodeName.hasPrefix("Tile") else { return false }
		
		let entity = SkeletonEntity(team: monster.team)
		
		if let rulesComponent = entity.componentForClass(MovementRulesComponent.self) {
			rulesComponentSystem.addComponent(rulesComponent)
		}
		
		entities.insert(entity)
		
		if let renderNode = entity.componentForClass(RenderComponent.self)?.node {
			renderNode.position = entityCenter
			renderNode.zPosition = 25
			addChild(renderNode)
		}
		
		return true
	}
	
	func summonMonster(monster: Monster, team: Team, laneIndex: Int) -> Bool {
		let alliedMonster = AlliedMonster(team: team, monster: monster)
		switch team {
			case .Blue:
				return spawnMonster(alliedMonster, lane: laneIndex, column: MaxTileCount - 1)
			
			case .Red:
				return spawnMonster(alliedMonster, lane: laneIndex, column: 0)
		}
	}
    
    override func update(currentTime: NSTimeInterval) {
        let deltaTime = currentTime - previousTime
        previousTime = currentTime
        for entity in entities {
            entity.updateWithDeltaTime(deltaTime)
//            guard let skeletonEntity = entity as? SkeletonEntity else {
//                return
//            }
            guard let render = entity.componentForClass(RenderComponent.self) else {
                return
            }
            if render.node.parent == nil {
				if entity is WallEntity {
					win()
				}
				
				entities.remove(entity)
            }
        }
    }
	
	func win() {
		groover.groove.tempo = 200
		
		let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(3.3 * Double(NSEC_PER_SEC)))
		dispatch_after(delayTime, dispatch_get_main_queue()) {
			self.reset()
		}
	}
	
	func groover(groover: BBGroover, didTick tick: UInt) {
		// TODO: Trigger idle?
		
		let voice = groover.groove.voices.first!
		let velocity = voice.velocities[Int(tick % 4)] as Int
		drumMachine.playNote(60, velocity: velocity)
		
		if tick % 4 == 0 {
			if let components = rulesComponentSystem.components as? [MovementRulesComponent] {
				for component in components {
					component.updateWithTick(tick)
				}
			}
				groover.groove.tempo += 1
				print("Increasing tempo to \(groover.groove.tempo)")
		}
	}
	
	func groover(groover: BBGroover, voicesDidTick voices: [BBVoice]) {
		
	}
	
	private func handleInput(input: InputButton, playerIndex: Int) {
		if let components = controllerComponentSystem.components as? [ControllerComponent] {
			for component in components {
				guard component.playerIndex == playerIndex else { continue }
				component.handleInput(input)
			}
		}
		
		print("Got \(input) from player \(playerIndex)")
	}
	
}
