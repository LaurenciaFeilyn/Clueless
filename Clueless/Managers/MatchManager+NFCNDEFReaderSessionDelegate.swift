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
            
            self.clues.insert(scanResult, at: self.clues.count)
            
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
