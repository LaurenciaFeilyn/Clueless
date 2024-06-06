//
//  GameOverView.swift
//  Clueless
//
//  Created by Kevin Nathanael Halim on 31/05/24.
//

import SwiftUI

struct GameOverView: View {
    @ObservedObject var matchManager: MatchManager
    
    var body: some View {
        VStack {
            Spacer()
            
            Text(matchManager.isWin ? "You Win" : "You Lose")
                .font(.largeTitle)
            
            Spacer()
            
            Text(matchManager.isSaboteur ? (matchManager.isWin ? "Less than \(Int(ceil(Double(matchManager.players?.count ?? 4) / 2))) investigators deducted \(matchManager.correctSuspect?.name ?? "") as the killer..." : "More than \(Int(ceil(Double(matchManager.players?.count ?? 4) / 2))) investigators correctly deducted \(matchManager.correctSuspect?.name ?? "") as the killer...") : (matchManager.isWin ? "You've correctly deducted \(matchManager.correctSuspect?.name ?? "") as the killer!" : "You've failed to deduct \(matchManager.correctSuspect?.name ?? "") as the killer, do better next time."))
                .font(.title3)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Spacer()
            
            Button {
                matchManager.isGameOver = false
            } label: {
                Text("Back to Menu")
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .font(.title3)
            }
            .buttonStyle(.borderedProminent)
            .tint(Color(UIColor.systemBrown))
            .padding(.top, 16)
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(Color(UIColor(named: "BG")!))
    }
}

#Preview {
    GameOverView(matchManager: MatchManager())
}
