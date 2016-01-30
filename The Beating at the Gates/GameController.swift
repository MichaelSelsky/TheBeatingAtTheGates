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

typealias Peripheral = VirtualGameController.Peripheral
typealias PeripheralConnectionHandler = (Peripheral) -> Void

class GameController {
    
    let peripheralConnectionHandler: PeripheralConnectionHandler
    let peripheralDisconnectionHandler: PeripheralConnectionHandler
    
    init(connectionHandler: PeripheralConnectionHandler, disconnectionHandler: PeripheralConnectionHandler) {
        
        peripheralConnectionHandler = connectionHandler
        peripheralDisconnectionHandler = disconnectionHandler
        
        VgcManager.startAs(.Peripheral, appIdentifier: VgcAppIdentifier, includesPeerToPeer: true)
        
        VgcManager.peripheral.deviceInfo = DeviceInfo(deviceUID: "", vendorName: "", attachedToDevice: false, profileType: .Gamepad, controllerType: .Software, supportsMotion: false)
    }
    
    func start() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "foundService:", name: VgcPeripheralFoundService, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "lostService:", name: VgcPeripheralLostService, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "peripheralDidConnect:", name: VgcPeripheralDidConnectNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "peripheralDidDisconnect:", name: VgcPeripheralDidDisconnectNotification, object: nil)
        VgcManager.peripheral.browseForServices()
    }
    
    func stop() {
        VgcManager.peripheral.disconnectFromService()
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func test() {
        let a = VgcManager.elements.buttonA
        a.value = 1.0
        VgcManager.peripheral.sendElementState(a)
        a.value = 0.0
        VgcManager.peripheral.sendElementState(a)
    }
    
    @objc func foundService(note: NSNotification) {
        guard let service = VgcManager.peripheral.availableServices.first else {
            return
        }
        
        let peripheral = VgcManager.peripheral
        peripheralConnectionHandler(peripheral)
        
        VgcManager.peripheral.connectToService(service)
        VgcManager.peripheral.stopBrowsingForServices()
    }
    
    @objc func lostService(note: NSNotification) {
        
    }
    
    @objc func peripheralDidConnect(note: NSNotification) {
        let peripheral = VgcManager.peripheral
        peripheralConnectionHandler(peripheral)
    }
    
    @objc func peripheralDidDisconnect(note: NSNotification) {
        let peripheral = VgcManager.peripheral
        peripheralDisconnectionHandler(peripheral)
    }
    
    deinit {
        stop()
    }
}
