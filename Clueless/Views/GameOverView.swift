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
            
            Text("Game Over!")
                .font(.largeTitle)
            
            Spacer()
            
            Button {
                matchManager.resetGame()
            } label: {
                Text("MENU")
                    .font(.largeTitle)
                    .bold()
            }
            
            Spacer()
        }
    }
}

#Preview {
    GameOverView(matchManager: MatchManager())
}
