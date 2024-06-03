//
//  MusicManager.swift
//  Clueless
//
//  Created by Kevin Nathanael Halim on 31/05/24.
//

import Foundation
import AVFoundation

var music: AVAudioPlayer!
var sfx: AVAudioPlayer?

func playBGMMusic() {
    stopAllMusic()
    
    if let musicURL = Bundle.main.url(forResource: "MenuBGM", withExtension: "mp3") {
        if let audioPlayer = try? AVAudioPlayer(contentsOf: musicURL) {
            music = audioPlayer
            music.numberOfLoops = -1
            music.play()
        }
    }
}

func playGameMusic() {
    stopAllMusic()
    
    if let musicURL = Bundle.main.url(forResource: "GameBGM", withExtension: "mp3") {
        if let audioPlayer = try? AVAudioPlayer(contentsOf: musicURL) {
            music = audioPlayer
            music.numberOfLoops = -1
            music.play()
        }
    }
}

func playButtonSFX() {
    if let sfxPlayer = sfx {
        sfxPlayer.play()
    } else {
        if let musicURL = Bundle.main.url(forResource: "ButtonSFX", withExtension: "mp3") {
            if let audioPlayer = try? AVAudioPlayer(contentsOf: musicURL) {
                sfx = audioPlayer
                sfx?.numberOfLoops = 1
                sfx?.play()
            }
        }
    }
}

func stopAllMusic() {
    if let musicPlayer = music {
        musicPlayer.stop()
    }
}
