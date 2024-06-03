//
//  GameView.swift
//  Clueless
//
//  Created by Kevin Nathanael Halim on 31/05/24.
//

import SwiftUI

var countdownTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

struct GameView: View {
    @ObservedObject var matchManager: MatchManager

    var body: some View {
        VStack {
            Spacer()
            
            Text("Player List:")
            
            Text(matchManager.localPlayer.displayName)
                .padding(.bottom, 2)
                .foregroundStyle(Color(UIColor.systemCyan))
            
            
            ForEach(matchManager.players ?? [], id: \.self) { player in
                Text(player.displayName)
                    .padding(.bottom, 2)
            }
            
            Spacer()
            
            Text("Time Left : \(matchManager.remainingTime) seconds..")
                .font(.largeTitle)
                .padding()
            
            Spacer()
        }
        .onReceive(countdownTimer) { _ in
            guard matchManager.isTimeKeeper else { return }
            if matchManager.remainingTime > 0 {
                matchManager.remainingTime -= 1
            } else {
                matchManager.gameOver()
                countdownTimer.upstream.connect().cancel()
            }
        }
        .onAppear {
            playGameMusic()
        }
    }
}

#Preview {
    GameView(matchManager: MatchManager())
}
