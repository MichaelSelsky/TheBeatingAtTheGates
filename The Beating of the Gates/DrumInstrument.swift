//
//  DrumInstrument.swift
//  The Beating at the Gates
//
//  Created by Grant Butler on 1/31/16.
//  Copyright © 2016 Grant J. Butler. All rights reserved.
//

import AudioKit

enum DrumVoiceType: String {
	
	case DownBeat
	case UpBeat
	case MidBeat
	
}

extension DrumVoiceType {
	
	static var allValues: [DrumVoiceType] {
		return [.DownBeat, .UpBeat, .MidBeat]
	}
	
	var path: String {
		return NSBundle(forClass: DrumVoice.self).pathForResource(self.rawValue, ofType: "wav")!
	}
	
}

public class DrumVoice: AKVoice {
	
	private let players: [DrumVoiceType: AKAudioPlayer]
	private let mixer = AKMixer()
	
	var selectedVoice: DrumVoiceType = .DownBeat
	private var selectedPlayer: AKAudioPlayer {
		return players[selectedVoice]!
	}
	
	override public init() {
		var players: [DrumVoiceType: AKAudioPlayer] = [:]
		for value in DrumVoiceType.allValues {
			let player = AKAudioPlayer(value.path)
			player.stop()
			mixer.connect(player)
			players[value] = player
		}
		self.players = players
		
		super.init()
		
		avAudioNode = mixer.avAudioNode
	}
	
	override public var isStarted: Bool {
        return selectedPlayer.isStarted
    }
    
    override public func start() {
		selectedPlayer.start()
    }
    
    override public func stop() {
        for (_, player) in players {
			player.stop()
		}
    }
    
    override public func duplicate() -> AKVoice {
        return DrumVoice()
    }
	
}

public class DrumMachine: AKPolyphonicInstrument {
	
	public init() {
		super.init(voice: DrumVoice(), voiceCount: 4)
	}
	
	override public func playVoice(voice: AKVoice, note: Int, velocity: Int) {
		let drumVoice = voice as! DrumVoice
		switch velocity {
			case 0...42:
				drumVoice.selectedVoice = .MidBeat
			case 43...82:
				drumVoice.selectedVoice = .UpBeat
			case 83...127:
				drumVoice.selectedVoice = .DownBeat
			default:
				break
		}
		
		drumVoice.start()
    }
	
	override public func stopVoice(voice: AKVoice, note: Int) {
        voice.stop()
    }
	
	override public func playNote(note: Int, velocity: Int) {
		var voice = availableVoices.popLast()
		if voice == nil,
			let firstActiveNote = activeNotes.first{
			stopNote(firstActiveNote)
			voice = availableVoices.popLast()
		}
		
		if let voice = voice {
			activeVoices.append(voice)
			activeNotes.append(note)
			playVoice(voice, note: note, velocity: velocity)
		}
    }
	
}
