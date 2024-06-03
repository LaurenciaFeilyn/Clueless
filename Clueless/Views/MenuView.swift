//
//  MenuView.swift
//  Clueless
//
//  Created by Kevin Nathanael Halim on 31/05/24.
//

import SwiftUI

struct MenuView: View {
    @ObservedObject var matchManager: MatchManager
    
    var body: some View {
        VStack {
            Spacer()
            
            Button {
                playButtonSFX()
                matchManager.startMatchmaking()
            } label: {
                Text("PLAY")
                    .font(.largeTitle)
                    .bold()
            }
            .disabled(matchManager.authState != .authenticated || matchManager.inGame)
            .padding()
            .background(
                Capsule(style: .circular)
                    .fill(matchManager.authState != .authenticated || matchManager.inGame ? .gray : Color(UIColor.systemYellow))
            )
            
            Text(matchManager.authState.rawValue)
                .padding()
            
            Spacer()
        }
        .background(
            Color(UIColor.systemBlue)
                .scaledToFill()
        )
        .ignoresSafeArea()
        .onAppear() {
            playBGMMusic()
        }
    }
}

#Preview {
    MenuView(matchManager: MatchManager())
}
