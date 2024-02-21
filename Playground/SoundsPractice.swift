//
//  SoundsPractice.swift
//  Playground
//
//  Created by Jason on 2024/2/21.
//

import SwiftUI
//Audio + Video Kit
import AVKit

class SoundManager {
    static let instance = SoundManager() // <- Singleton
    private init() { }
    
    var player: AVAudioPlayer?
    
    enum SoundOption: String {
        case tada
        case badum
    }
    
    func playSound(_ sound: SoundOption) {
        guard let url = Bundle.main.url(forResource: sound.rawValue, withExtension: ".mp3") else { return }
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        } catch let error {
            print("Error playing sound, \(error)")
        }
    }
}

struct SoundsPractice: View {
    var soundManager = SoundManager.instance
    
    var body: some View {
        VStack(spacing: 40.0) {
            Button("Play sound 1") {
                soundManager.playSound(.tada)
            }
            Button("Play sound 2") {
                soundManager.playSound(.badum)
            }
        }
    }
}

#Preview {
    SoundsPractice()
}
