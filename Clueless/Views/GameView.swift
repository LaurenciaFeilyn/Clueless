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
            
            Text("Time Left : \(matchManager.remainingTime) seconds..")
                .font(.largeTitle)
                .padding()
            
            Spacer()
            
            HStack {
                Spacer()
                
                VStack {
                    Button {
                        matchManager.toggleDeductor()
                    } label: {
                        HStack{
                            Image(systemName: "scope")
                                .padding(.top, 2)
                            Text("Deduct Killer")
                        }
                    }
                    .buttonStyle(.bordered)
                    .tint(Color(UIColor.systemBrown))
                    
                    Text("\(matchManager.deductors.count) of 4")
                        .font(.caption)
                        .foregroundStyle(Color(UIColor.secondaryLabel))
                }
                
                Spacer()
                
                VStack {
                    Button {
                        matchManager.toggleKicker()
                    } label: {
                        HStack{
                            Image(systemName: "figure.kickboxing")
                                .padding(.top, 2)
                            Text("Kick Impostor")
                        }
                    }
                    .buttonStyle(.bordered)
                    .tint(Color(UIColor.systemBrown))
                    
                    Text("\(matchManager.kickers.count) of 4")
                        .font(.caption)
                        .foregroundStyle(Color(UIColor.secondaryLabel))
                }
                
                Spacer()
            }
            
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
