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

class ControllerInput {
    
    var controllers: Set<VgcController> = []
    
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
        
        profile.valueChangedHandler = { (gamepad: GCGamepad, element: GCControllerElement) in
            if gamepad.buttonA == element && gamepad.buttonA.pressed {
                print("a")
            }
            if gamepad.buttonB == element && gamepad.buttonB.pressed {
                print("b")
            }
            if gamepad.buttonX == element && gamepad.buttonX.pressed {
                print("x")
            }
            if gamepad.buttonY == element && gamepad.buttonY.pressed {
                print("y")
            }
            if gamepad.dpad.up == element && gamepad.dpad.up.pressed {
                print("up")
            }
            if gamepad.dpad.down == element && gamepad.dpad.down.pressed {
                print("down")
            }
        }
        return true
    }
}
