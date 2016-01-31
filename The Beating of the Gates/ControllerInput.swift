//
//  ControllerInput.swift
//  The Beating at the Gates
//
//  Created by MichaelSelsky on 1/30/16.
//  Copyright © 2016 Grant J. Butler. All rights reserved.
//

import Foundation

import GameController
import VirtualGameController

let VgcAppIdentifier: String = "BeatingAtTheGates"

enum InputButton {
	
	case A
	case B
	case X
	case Y
	case DpadUp
	case DpadDown
	
}

typealias ControllerInputHandler = (input: InputButton, playerIndex: Int) -> Void

class ControllerInput {
    
    var controllers: Set<VgcController> = []
	var inputHandler: ControllerInputHandler? = nil
	
    func start() {
        startLooking()
    }
    
    func startLooking() {
        VgcManager.startAs(.Central, appIdentifier: VgcAppIdentifier)
        VgcController.startWirelessControllerDiscoveryWithCompletionHandler(nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "controllerDidConnect:", name: VgcControllerDidConnectNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"controllerDidDisconnect:" , name: VgcControllerDidDisconnectNotification, object: nil)
        
    }
    
    @objc func controllerDidConnect(note: NSNotification) {
        guard let controller = note.object as? VgcController else {
            return
        }
        
        guard setUpController(controller) else {
            return
        }
        
        controllers.insert(controller)
        
        guard controllers.count <= 4 else {
            return
        }
        
        controller.playerIndex = GCControllerPlayerIndex(rawValue: controllers.count)!
    }
    
    @objc func controllerDidDisconnect(note: NSNotification) {
        guard let controller = note.object as? VgcController else {
            return
        }
        controllers.remove(controller)
    }
    
    func setUpController(controller: VgcController) -> Bool {
        guard controller.profileType == .Gamepad else {
            return false
        }
        
        guard let profile = controller.gamepad else {
            return false
        }
        
        profile.valueChangedHandler = { [weak controller] (gamepad: GCGamepad, element: GCControllerElement) in
			guard let controller = controller else { return }
			self.handleInput(controller, gamepad: gamepad, element: element)
        }
        return true
    }
	
	private func handleInput(controller: VgcController, gamepad: GCGamepad, element: GCControllerElement) {
		let playerIndex = controller.playerIndex.rawValue
		
		if gamepad.buttonA == element && gamepad.buttonA.pressed {
			inputHandler?(input: .A, playerIndex: playerIndex)
		}
		if gamepad.buttonB == element && gamepad.buttonB.pressed {
			inputHandler?(input: .B, playerIndex: playerIndex)
		}
		if gamepad.buttonX == element && gamepad.buttonX.pressed {
			inputHandler?(input: .X, playerIndex: playerIndex)
		}
		if gamepad.buttonY == element && gamepad.buttonY.pressed {
			inputHandler?(input: .Y, playerIndex: playerIndex)
		}
		if gamepad.dpad.yAxis == element && gamepad.dpad.yAxis.value > 0.25 {
			inputHandler?(input: .DpadUp, playerIndex: playerIndex)
		}
		if gamepad.dpad.yAxis == element && gamepad.dpad.yAxis.value < -0.25{
			inputHandler?(input: .DpadDown, playerIndex: playerIndex)
		}
	}
}
