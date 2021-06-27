//
//  PlaySoundEffect.swift
//  CloudClip
//
//  Created by Shravan Prasanth on 6/26/21.
//

import Foundation
import AVFoundation

class SoundEffects {
    var player: AVAudioPlayer!

    func playSound(effectType: EffectType) {
        let url = Bundle.main.url(forResource: effectType.rawValue, withExtension: "wav")!
            do {
                let player = try AVAudioPlayer(contentsOf: url)
                player.prepareToPlay()
                player.play()
            } catch let error {
                print(error.localizedDescription)
            }
    }
    
    enum EffectType: String {
        case startSession = "AUDIOStartSession"
        case endSession = "AUDIOEndSession"
        case clipped = "AUDIOClipped"
    }
}
