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

            var scanResponse = "You've found an invalid card."
            switch scanResult {
                case "Clue1":
                    scanResponse = self.getClue(0)
                    break
                case "Clue2":
                    scanResponse = self.getClue(1)
                    break
                case "Clue3":
                    scanResponse = self.getClue(2)
                    break
                case "Clue4":
                   scanResponse = self.getClue(3)
                    break
                case "Clue5":
                    scanResponse = self.getClue(4)
                    break
                case "Clue6":
                    scanResponse = self.getClue(5)
                    break
                case "Clue7":
                    scanResponse = self.getClue(6)
                    break
                default:
                    if (self.isSaboteur) {
                        if (scanResult.contains("enSabo")) {
                            if (self.sabos.contains(scanResult)) {
                                scanResponse = "You've found this card before."
                            } else {
                                self.sabos.insert(scanResult, at: 0)
                                self.sabotageChance += 1
                                scanResponse = "You've gained 1 sabotage chance!"
                            }
                        }
                    }
                    break
            }
            
            session.alertMessage = scanResponse
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
