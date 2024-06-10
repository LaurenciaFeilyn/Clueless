//
//  MatchManager+NFCNDEFReaderSessionDelegate.swift
//  Clueless
//
//  Created by Kevin Nathanael Halim on 07/06/24.
//

import Foundation
import CoreNFC

extension MatchManager: NFCNDEFReaderSessionDelegate {
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        DispatchQueue.main.async {
            let scanResult = messages.map {
                $0.records.map {
                    String(decoding: $0.payload, as: UTF8.self)
                }.joined(separator: "\n")
            }.joined(separator: " ")
            
            switch scanResult {
            case "Clue1":
                self.clues.insert(clueList[0], at: self.clues.count)
            case "Clue2":
                self.clues.insert(clueList[1], at: self.clues.count)
            case "Clue3":
                self.clues.insert(clueList[2], at: self.clues.count)
            case "Clue4":
                self.clues.insert(clueList[3], at: self.clues.count)
            case "Clue5":
                self.clues.insert(clueList[4], at: self.clues.count)
            case "Clue6":
                self.clues.insert(clueList[5], at: self.clues.count)
            case "Clue7":
                self.clues.insert(clueList[6], at: self.clues.count)
            case "Mastermind":
                if self.isSaboteur {
                    MatchManager().sabotageChance += 1
                } else {
                    break
                }
            default:
                break
            }
            
//            self.clues.insert(scanResult, at: self.clues.count)
            
            session.alertMessage = self.endAlert != "" ? self.endAlert : "Read \(messages.count) NDEF Messages, and \(messages[0].records.count) Records."
        }
    }
    
    public func readerSessionDidBecomeActive(_ session: NFCNDEFReaderSession) {
    }
    
    public func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        if let nfcError = error as? NFCReaderError, nfcError.code == .readerSessionInvalidationErrorFirstNDEFTagRead {
            print("First NDEF tag read.")
        } else {
            print("Session did invalidate with error: \(error)")
        }
        self.session = nil
    }
}
