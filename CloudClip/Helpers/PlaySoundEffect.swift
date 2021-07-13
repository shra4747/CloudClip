//
//  PlaySoundEffect.swift
//  CloudClip
//
//  Created by Shravan Prasanth on 6/26/21.
//

import Foundation

class SoundEffects {
    func playSound(effectType: EffectType) {
    }
    
    enum EffectType: String {
        case startSession = "AUDIOStartSession"
        case endSession = "AUDIOEndSession"
        case clipped = "AUDIOClipped"
    }
}
