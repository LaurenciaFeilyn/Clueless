//
//  DeductView.swift
//  Clueless
//
//  Created by Kevin Nathanael Halim on 03/06/24.
//

import SwiftUI

struct DeductView: View {
    @ObservedObject var matchManager: MatchManager
    
    var body: some View {
        VStack {
            Button {
                matchManager.gameOver()
                matchManager.sendString("finish:")
            } label: {
                Text("DEDUCT")
                    .font(.largeTitle)
                    .bold()
            }
            .padding()
        }
        .interactiveDismissDisabled()
    }
}

#Preview {
    DeductView(matchManager: MatchManager())
}
