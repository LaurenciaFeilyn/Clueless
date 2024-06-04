//
//  MatchManager.swift
//  Clueless
//
//  Created by Kevin Nathanael Halim on 31/05/24.
//

import Foundation
import GameKit

class MatchManager: NSObject, ObservableObject {
    @Published var inGame = false
    @Published var isGameOver = false
    @Published var isDeducting = false
    @Published var authState = AuthState.authenticating
    
    @Published var isTimeKeeper = false
    @Published var remainingTime = 60 {
        willSet {
            if isTimeKeeper { sendString("timer:\(newValue)") }
        }
    }
    
    @Published var canScan = true
    @Published var scanChance = 2
    
    var match: GKMatch?
    var players: [GKPlayer]?
    var playerIdx = 0
    var localPlayer = GKLocalPlayer.local
    
    var deductors: [String] = []
    
    var playerUUIDKey = UUID().uuidString
    
    var rootViewController: UIViewController? {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        return windowScene?.windows.first?.rootViewController
    }
    
    func authenticateUser() {
        localPlayer.authenticateHandler = { [self] vc, e in
            if let viewController = vc {
                rootViewController?.present(viewController, animated: true)
                return
            }
            
            if let error = e {
                authState = .error
                print(error.localizedDescription)
                return
            }
            
            if localPlayer.isAuthenticated {
                if localPlayer.isMultiplayerGamingRestricted {
                    authState = .restricted
                } else {
                    authState = .authenticated
                    localPlayer.register(self)
                }
            } else {
                authState = .unauthenticated
            }
        }
    }
    
    func startMatchmaking() {
        let request = GKMatchRequest()
        request.minPlayers = 2
        request.maxPlayers = 5
        
        let matchMakingVC = GKMatchmakerViewController(matchRequest: request)
        matchMakingVC?.matchmakingMode = GKMatchmakingMode.inviteOnly
        matchMakingVC?.matchmakerDelegate = self
        
        rootViewController?.present(matchMakingVC!, animated: true)
    }
    
    func startGame(newMatch: GKMatch) {
        match = newMatch
        match?.delegate = self
        players = match?.players
        
        sendString("began:\(playerUUIDKey)")
    }
    
    func gameOver() {
        isGameOver = true
        match?.disconnect()
    }
    
    func resetGame() {
        DispatchQueue.main.async { [self] in
            isGameOver = false
            inGame = false
            remainingTime = 60
        }
        
        isTimeKeeper = false
        match?.delegate = nil
        match = nil
        players = nil
        playerIdx = 0
        playerUUIDKey = UUID().uuidString
    }
    
    func toggleDeductor(playerID: String) {
        if (deductors.contains(playerID)) {
            let index = deductors.firstIndex(of: playerID)
            deductors.remove(at: index!)
        } else {
            deductors.insert(playerID, at: 0)
        }
        sendString("deduct:\(playerID)")
        
        if (deductors.count >= ((players!.count + 1) * 3 / 4)) {
            isDeducting = true
        }
    }
    
    func receivedString(_ message: String) {
        let messageSplit = message.split(separator: ":")
        guard let messagePrefix = messageSplit.first else {return}
        
        let parameter = String(messageSplit.last ?? "")
        
        switch messagePrefix {
        case "began":
            if playerUUIDKey == parameter {
                playerUUIDKey = UUID().uuidString
                sendString("began:\(playerUUIDKey)")
                break
            }
            
            inGame = true
            isTimeKeeper = true
            
            if isTimeKeeper {
                countdownTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
            }
            
        case "deduct":
            toggleDeductor(playerID: parameter)
            
        case "finish":
            gameOver()
            
        default:
            break
        }
    }
}
