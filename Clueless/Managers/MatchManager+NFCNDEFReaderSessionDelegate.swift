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
            
            print("[\(scanResult)]")
            
            var scanResponse = "You've found an invalid card."
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
            } else {
                self.clues.insert(scanResult, at: self.clues.count)
                self.scanChance -= 1
                scanResponse = "You've found a new clue!"
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
