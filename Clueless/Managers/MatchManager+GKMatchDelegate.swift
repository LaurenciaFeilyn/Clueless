//
//  MatchManager+GKMatchDelegate.swift
//  Clueless
//
//  Created by Kevin Nathanael Halim on 31/05/24.
//

import Foundation
import GameKit

extension MatchManager: GKMatchDelegate {
    func match(_ match: GKMatch, didReceive data: Data, fromRemotePlayer player: GKPlayer) {
        let content = String(decoding: data, as: UTF8.self)
        
        if content.starts(with: "strData:") {
            let message = content.replacing("strData:", with:"")
            receivedString(message)
        }
    }
    
    func sendString(_ message: String) {
        guard let encoded = "strData:\(message)".data(using: .utf8) else {return}
        sendData(encoded, mode: .reliable)
    }
    
    func sendData(_ data: Data, mode: GKMatch.SendDataMode) {
        do {
            try match?.sendData(toAllPlayers: data, with: mode)
        } catch {
            print(error)
        }
    }
    
    func match(_ match: GKMatch, player: GKPlayer, didChange state: GKPlayerConnectionState) {
        switch state {
        case .connected:
            print("\(player.displayName) Connected")
            if match.expectedPlayerCount == 0 {
                players = match.players
            }
        case .disconnected:
            print("\(player.displayName) Disconnected")
            if !isGameOver {
                let alert = UIAlertController(title: "Player Disconnected", message: "\(player.displayName) disconnected from the game..", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                    self.match?.disconnect()
                })
                
                DispatchQueue.main.async {
                    self.resetGame()
                    self.rootViewController?.present(alert, animated: true)
                }
            }
        default:
            print("\(player.displayName) Connection Unknown")
        }
    }
}
