//
//  MatchManager.swift
//  Clueless
//
//  Created by Kevin Nathanael Halim on 31/05/24.
//

import Foundation
import GameKit
import CoreNFC

class MatchManager: NSObject, ObservableObject {
    @Published var inGame = false
    @Published var isGameOver = false
    @Published var isDeducting = false
    @Published var isWin = false
    @Published var authState = AuthState.authenticating
    
    @Published var isTimeKeeper = false
    @Published var remainingTime = MatchConfig.GAME_DURATION {
        willSet {
            if isTimeKeeper { sendString("timer:\(newValue)") }
        }
    }
    
    // Investigator
    @Published var canScan = true
    @Published var scanChance = MatchConfig.SCAN_CHANCE
    @Published var isScanDisabled = false
    @Published var clues: [Clue] = [] //ones that players collected
    
    // Mastermind
    @Published var isSaboteur = false
    @Published var sabotageChance = 0
    @Published var sabos: [String] = []
    
    // NFC
    var session: NFCNDEFReaderSession?
    var startAlert = "Hold your iPhone near the card."
    
    var match: GKMatch?
    var players: [GKPlayer]?
    var localPlayer = GKLocalPlayer.local
    
    var hostID: String?
    
    var deductors: [String] = []
    var doneDeductCount = 0
    
    var playerUUIDKey = UUID().uuidString
    
    var correctSuspect: Suspect?
    var correctCount = 0
    
    let pattern = "\\d$"
    
    var rootViewController: UIViewController? {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        return windowScene?.windows.first?.rootViewController
    }
    
    func resetGame() {
        DispatchQueue.main.async { [self] in
            inGame = false
            remainingTime = MatchConfig.GAME_DURATION
        }
        
        isTimeKeeper = false
        match?.delegate = nil
        match = nil
        playerUUIDKey = UUID().uuidString
        isDeducting = false
        deductors = []
        isScanDisabled = false
        sabotageChance = 0
        sabos = []
        canScan = true
        scanChance = MatchConfig.SCAN_CHANCE
        clues = []
        doneDeductCount = 0
        correctCount = 0
        session = nil
        hostID = nil
    }
    
    func resetRemnants() {
        isGameOver = false
        players = nil
        isWin = false
        isSaboteur = false
        correctSuspect = nil
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
        request.minPlayers = MatchConfig.MIN_PLAYERS
        request.maxPlayers = MatchConfig.MAX_PLAYERS
        
        let matchMakingVC = GKMatchmakerViewController(matchRequest: request)
        matchMakingVC?.matchmakingMode = GKMatchmakingMode.inviteOnly
        matchMakingVC?.matchmakerDelegate = self
        
        hostID = localPlayer.gamePlayerID
        
        rootViewController?.present(matchMakingVC!, animated: true)
    }
    
    func startGame(newMatch: GKMatch) {
        resetRemnants()
        
        match = newMatch
        match?.delegate = self
        players = match?.players
        
        sendString("began:\(playerUUIDKey)")
        
        if localPlayer.gamePlayerID == hostID {
            var playerIds: [String] = []
            for p in players! {
                playerIds.insert(p.gamePlayerID, at: 0)
            }
            playerIds.insert(localPlayer.gamePlayerID, at: 0)
            
            let saboteurId: String = playerIds.randomElement()!
            if (saboteurId == localPlayer.gamePlayerID) {
                isSaboteur = true
                isWin = true
            } else {
                sendString("saboteur:\(saboteurId)")
            }
            
            let suspectIdx = Int.random(in: 0..<suspectList.count)
            correctSuspect = suspectList[suspectIdx]
            sendString("suspect:\(suspectIdx)")
            assignClue()
            print(correctSuspect!)
        }
    }
    
    func assignClue() {
        switch correctSuspect?.name {
        case "Alex Miller":
            clueList = [bottle, nothing, nothing, tieClip, glass, inhaler, medicine]
        case "Jamie Walker":
            clueList = [nothing, nothing, gum, tieClip, glass, inhaler, medicine]
        case "Riley Thomas":
            clueList = [bottle, cigarettes, gum, tieClip, nothing, inhaler, nothing]
        case "Robin Wright":
            clueList = [bottle, cigarettes, nothing, nothing, glass, inhaler, medicine]
        case "Taylor Brooks":
            clueList = [nothing, cigarettes, gum, nothing, glass, inhaler, medicine]
        case "Nova Lawson":
            clueList = [nothing, cigarettes, gum, tieClip, glass, nothing, medicine]
        case "Blair Davies":
            clueList = [bottle, cigarettes, nothing, tieClip, glass, inhaler, nothing]
        case "Cameron Lee":
            clueList = [bottle, cigarettes, gum, nothing, nothing, inhaler, medicine]
        case "Morgan Blake":
            clueList = [bottle, cigarettes, gum, tieClip, nothing, nothing, medicine]
        case "Avery Baker":
            clueList = [bottle, nothing, gum, tieClip, glass, nothing, medicine]
        case "Dakota Quinn":
            clueList = [nothing, cigarettes, gum, tieClip, glass, inhaler, nothing]
        case "Skylar Moore":
            clueList = [bottle, nothing, gum, tieClip, nothing, inhaler, medicine]
        case "Leslie Carter":
            clueList = [bottle, cigarettes, nothing, tieClip, glass, nothing, medicine]
        case "Rowan Gray":
            clueList = [bottle, cigarettes, gum, nothing, glass, inhaler, nothing]
        default: break
        }
    }

    
    func readTag() {
        guard NFCNDEFReaderSession.readingAvailable else {
            print("Error")
            return
        }
        session = NFCNDEFReaderSession(delegate: self, queue: nil, invalidateAfterFirstRead: true)
        session?.alertMessage = startAlert
        session?.begin()
    }
    
    func gameOver() {
        isGameOver = true
        match?.disconnect()
        resetGame()
    }

    func toggleDeductor(playerID: String, doBroadcast: Bool = false) {
        if (deductors.contains(playerID)) {
            let index = deductors.firstIndex(of: playerID)
            deductors.remove(at: index!)
        } else {
            deductors.insert(playerID, at: 0)
        }
        
        if (doBroadcast) {
            sendString("deduct-ready:\(playerID)")
        }
        
        if (deductors.count >= players!.count) {
            isDeducting = true
        }
    }
    
    func deductKiller(suspect: Suspect) {
        doneDeductCount += 1
        if (suspect.name == correctSuspect?.name) {
            isWin = true
            sendString("correct:\(localPlayer.gamePlayerID)")
        }
        sendString("deducted:")
        print("\(doneDeductCount) | \(players!.count)")
        if (doneDeductCount >= players!.count) {
            gameOver()
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
        
        case "saboteur":
            isSaboteur = false
            if (localPlayer.gamePlayerID.suffix(localPlayer.gamePlayerID.count - 2) == parameter) {
                isSaboteur = true
                isWin = true
            }
        
        case "suspect":
            print("[\(parameter)]")
            correctSuspect = suspectList[Int(parameter) ?? 0]
            assignClue()
            
        case "clue":
            clues.insert(clueList[Int(parameter)!], at: self.clues.count)
            
        case "deduct-ready":
            if (!isSaboteur) {
                toggleDeductor(playerID: parameter)
            }
            
        case "deducted":
            doneDeductCount += 1
            print("\(doneDeductCount) | \(players!.count)")
            if (doneDeductCount >= players!.count) {
                if (isSaboteur && correctCount > Int(ceil(Double(players?.count ?? 4) / 2))) {
                    isWin = false
                }
                gameOver()
            }
            
        case "correct":
            if (isSaboteur) {
                correctCount += 1
            }
            
        case "sabotage":
            if (localPlayer.gamePlayerID.suffix(localPlayer.gamePlayerID.count - 2) == parameter) {
                canScan = false
                isScanDisabled = true
            }
            
        case "finish":
            gameOver()
            
        default:
            break
        }
    }
}
