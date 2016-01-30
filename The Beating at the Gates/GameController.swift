//
//  GameController.swift
//  The Beating at the Gates
//
//  Created by MichaelSelsky on 1/30/16.
//  Copyright © 2016 Grant J. Butler. All rights reserved.
//

import Foundation
import VirtualGameController

let VgcAppIdentifier: String = "BeatingAtTheGates"

class GameController {
    init() {
        VgcManager.startAs(.Peripheral, appIdentifier: VgcAppIdentifier, includesPeerToPeer: true)
        
        VgcManager.peripheral.deviceInfo = DeviceInfo(deviceUID: "", vendorName: "", attachedToDevice: false, profileType: .Gamepad, controllerType: .Software, supportsMotion: false)
    }
    
    func start() {
        VgcManager.peripheral.browseForServices()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "foundService:", name: VgcPeripheralFoundService, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "lostService:", name: VgcPeripheralLostService, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "peripheralDidConnect:", name: VgcPeripheralDidConnectNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "peripheralDidDisconnect:", name: VgcPeripheralDidDisconnectNotification, object: nil)
    }
    
    func stop() {
        VgcManager.peripheral.disconnectFromService()
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func test() {
        let a = VgcManager.elements.buttonA
        a.value = 1.0
        VgcManager.peripheral.sendElementState(a)

    }
    
    private func foundService(note: NSNotification) {
        guard let service = VgcManager.peripheral.availableServices.first else {
            return
        }
        
        VgcManager.peripheral.connectToService(service)
        VgcManager.peripheral.stopBrowsingForServices()
        test()
    }
    
    private func lostService(note: NSNotification) {
        
    }
    
    private func peripheralDidConnect(note: NSNotification) {
        
    }
    
    private func peripheralDidDisconnect(note: NSNotification) {
        
    }
}
