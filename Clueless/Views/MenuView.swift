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
        VStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/) {
            Image("Main")
                .resizable()
                .scaledToFit()
            
            Spacer()
            
            Text("Clueless")
                .font(.system(size: 48, weight: .bold))
                .padding(.bottom, 48)
            
            Button {
                playButtonSFX()
                matchManager.startMatchmaking()
            } label: {
                HStack{
                    Image(systemName: "play.fill")
                        .padding(.top, 1)
                    Text("Play")
                }
                .padding(.horizontal, 64)
                .padding(.vertical, 6)
            }
            .font(.headline)
            .buttonStyle(.borderedProminent)
            .tint(Color(UIColor.systemBrown))
            .disabled(matchManager.authState != .authenticated || matchManager.inGame)
            
            Text(matchManager.authState.rawValue)
                .padding(.top, 4)
                .font(.caption)
                .foregroundStyle(Color(UIColor.secondaryLabel))
            
            Spacer()
        }
        .ignoresSafeArea()
        .frame(maxWidth: .infinity)
        .background(Color(UIColor(named: "BG")!))
        .onAppear() {
            playBGMMusic()
        }
    }
}

#Preview {
    MenuView(matchManager: MatchManager())
}
