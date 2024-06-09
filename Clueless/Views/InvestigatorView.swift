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
    @State private var isReadyToDeduct = false

    var body: some View {
        NavigationStack {
            GeometryReader { metrics in
                VStack {
                    Spacer()
                    
                    HStack {
                        Text("\(minutesString(timer: matchManager.remainingTime))")
                            .font(.system(size: 52, weight: .bold))
                        Text(":")
                            .font(.system(size: 52, weight: .bold))
                        Text("\(secondsString(timer: matchManager.remainingTime))")
                            .font(.system(size: 52, weight: .bold))
                    }
                    
                    Spacer()
                    
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                        ForEach(Array(matchManager.clues.enumerated()), id: \.offset) { index, clue in
                            Text(clue)
                        }
                        .padding(.vertical, 8)
                    }
                    
                    Spacer()
                    
                    HStack {
                        Spacer()
                        
                        VStack {
                            Button {
                                matchManager.readTag()
                            } label: {
                                HStack{
                                    Image(systemName: "wave.3.right")
                                        .padding(.top, 1)
                                    Text("Scan Clue")
                                }
                                .padding(.horizontal, 28)
                                .padding(.vertical, 8)
                                .font(.callout)
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(Color(UIColor.systemBrown))
                            .padding(.bottom, 4)
                            .disabled(!matchManager.canScan || matchManager.scanChance <= 0)

                            
                            Text(matchManager.canScan ? "\(matchManager.scanChance) chance(s) left" : "Your device is sabotaged..")
                                .font(.caption)
                                .foregroundStyle(Color(UIColor.secondaryLabel))
                        }
                        
                        Spacer()
                        
                        VStack {
                            Button {
                                matchManager.toggleDeductor(playerID: matchManager.localPlayer.gamePlayerID, doBroadcast: true)
                                isReadyToDeduct.toggle()
                            } label: {
                                HStack{
                                    Image(systemName: "scope")
                                        .padding(.top, 1)
                                    Text(isReadyToDeduct ? "Cancel Vote" : "Vote to Deduct")
                                }
                                .padding(.horizontal, (isReadyToDeduct ? 17 : 6))
                                .padding(.vertical, 8)
                                .font(.callout)
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(Color(UIColor.systemBrown))
                            .padding(.bottom, 4)
                            
                            Text("\(matchManager.deductors.count) of \(matchManager.players?.count ?? 0)")
                                .font(.caption)
                                .foregroundStyle(Color(UIColor.secondaryLabel))
                        }
                        
                        Spacer()
                    }
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .background(Color(UIColor(named: "BG")!))
            }
            .navigationTitle("Investigate")
            .toolbar {
                NavigationLink {
                    SuspectsView()
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
        .tint(Color(UIColor(named: "BW")!))
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
        .alert("Your clue scanner device is disabled!", isPresented: $matchManager.isScanDisabled) {
            Button("OK") {
                matchManager.isScanDisabled = false
            }
        }
        .sheet(isPresented: $matchManager.isDeducting) {
            DeductView(matchManager: matchManager)
        }
    }
}

#Preview {
    InvestigatorView(matchManager: MatchManager())
}
