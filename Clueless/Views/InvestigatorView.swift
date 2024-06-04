//
//  GameView.swift
//  Clueless
//
//  Created by Kevin Nathanael Halim on 31/05/24.
//

import SwiftUI

var countdownTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

struct InvestigatorView: View {
    @ObservedObject var matchManager: MatchManager

    var body: some View {
        NavigationStack {
            GeometryReader { metrics in
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
                                
                            } label: {
                                HStack{
                                    Image(systemName: "wave.3.right")
                                        .padding(.top, 1)
                                    Text("Scan Clue")
                                }
                                .padding(.horizontal, 24)
                                .padding(.vertical, 8)
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(Color(UIColor.systemBrown))
                            .padding(.bottom, 4)
                            .disabled(!matchManager.canScan)

                            
                            Text("\(matchManager.scanChance) chance(s) left")
                                .font(.caption)
                                .foregroundStyle(Color(UIColor.secondaryLabel))
                        }
                        
                        Spacer()
                        
                        VStack {
                            Button {
                                matchManager.toggleDeductor(playerID: matchManager.localPlayer.gamePlayerID)
                            } label: {
                                HStack{
                                    Image(systemName: "scope")
                                        .padding(.top, 1)
                                    Text("Deduct Killer")
                                }
                                .padding(.horizontal, 8)
                                .padding(.vertical, 8)
                            }
                            .buttonStyle(.bordered)
                            .tint(Color(UIColor.systemBrown))
                            .padding(.bottom, 4)
                            
                            Text("\(matchManager.deductors.count) of \(matchManager.players?.count ?? 0 + 1)")
                                .font(.caption)
                                .foregroundStyle(Color(UIColor.secondaryLabel))
                        }
                        
                        Spacer()
                    }
                    
                    Spacer()
                }
            }
            .navigationTitle("Investigate")
            .toolbar {
                Button {
                    
                } label: {
                    HStack{
                        Image(systemName: "person.and.background.striped.horizontal")
                            .padding(.top, 1)
                        Text("Suspects")
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 8)
                }
                .tint(Color(UIColor.systemBrown))
            }
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
        .sheet(isPresented: $matchManager.isDeducting) {
            DeductView(matchManager: matchManager)
        }
    }
}

#Preview {
    InvestigatorView(matchManager: MatchManager())
}
