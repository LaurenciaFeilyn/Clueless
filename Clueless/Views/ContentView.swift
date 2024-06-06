//
//  ContentView.swift
//  Clueless
//
//  Created by Laurencia Feilyn on 31/05/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var matchManager = MatchManager()
    
    var body: some View {
        ZStack {
            if matchManager.isGameOver {
                GameOverView(matchManager: matchManager)
            } else if matchManager.inGame {
                if matchManager.isSaboteur {
                    SaboteurView(matchManager: matchManager)
                } else {
                    InvestigatorView(matchManager: matchManager)
                }
            } else {
                MenuView(matchManager: matchManager)
            }
        }.onAppear() {
            matchManager.authenticateUser()
        }
    }
}

#Preview {
    ContentView()
}
