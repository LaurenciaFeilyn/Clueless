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
                    
                    VStack {
                        ZStack {
                            Image("Cork Bulletin")
                                .resizable()
                                .scaledToFit()
                                .padding()
                            
                            Image(matchManager.clues.count >= 1 ? matchManager.clues[0].image : "None")
                                .resizable()
                                .frame(width: 110, height: 130)
                                .position(x: 120, y: 364)
                                
                            Image(matchManager.clues.count >= 2 ? matchManager.clues[1].image : "None")
                                .resizable()
                                .frame(width: 110, height: 130)
                                .position(x: 100, y: 135)
                            
                            Image(matchManager.clues.count >= 3 ? matchManager.clues[2].image : "None")
                                .resizable()
                                .frame(width: 110, height: 130)
                                .position(x: 310, y: 135)
                            
                            Image(matchManager.clues.count >= 4 ? matchManager.clues[3].image : "None")
                                .resizable()
                                .frame(width: 110, height: 130)
                                .position(x: 75, y: 250)
                            
                            Image(matchManager.clues.count >= 5 ? matchManager.clues[4].image : "None")
                                .resizable()
                                .frame(width: 110, height: 130)
                                .position(x: 320, y: 350)
                            
                            Image(matchManager.clues.count >= 6 ? matchManager.clues[5].image : "None")
                                .resizable()
                                .frame(width: 110, height: 130)
                                .position(x: 218, y: 300)
                            
                            Image(matchManager.clues.count >= 7 ? matchManager.clues[6].image : "None")
                                .resizable()
                                .frame(width: 110, height: 130)
                                .position(x: 210, y: 160)
                        }
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
