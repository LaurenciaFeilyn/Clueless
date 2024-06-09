//
//  SaboteurView.swift
//  Clueless
//
//  Created by Kevin Nathanael Halim on 04/06/24.
//

import SwiftUI

struct SaboteurView: View {
    @ObservedObject var matchManager: MatchManager
    @State private var playerDisplays: [PlayerDisplay] = []
    
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
                    
                    Text("\(matchManager.sabotageChance) chance(s) remaining")
                        .font(.footnote)
                        .foregroundStyle(Color(UIColor.secondaryLabel))
                    
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                        ForEach(Array(playerDisplays.enumerated()), id: \.offset) { index, player in
                            VStack {
                                Image(uiImage: player.image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width:metrics.size.width * 0.20, height:metrics.size.width * 0.20)
                                    .clipped()
                                    .clipShape(Circle())
                                    .padding(.bottom, 8)
                                
                                Text(player.name)
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .padding(.bottom, 8)
                                
                                Button {
                                    matchManager.sabotageChance -= 1
                                    matchManager.sendString("sabotage:\(player.id)")
                                    playerDisplays[index].isDisabled = true
                                } label: {
                                    Image(systemName: "person.crop.circle.fill.badge.xmark")
                                }
                                .buttonStyle(.borderedProminent)
                                .tint(Color(UIColor.systemBrown))
                                .clipShape(Circle())
                                .disabled(player.isDisabled || matchManager.sabotageChance <= 0)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                    
                    
                    Spacer()
                    
                    Button {
                        matchManager.readTag()
                    } label: {
                        HStack{
                            Image(systemName: "wave.3.right")
                                .padding(.top, 1)
                            Text("Scan Card")
                        }
                        .padding(.horizontal, 116)
                        .padding(.vertical, 8)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(Color(UIColor.systemBrown))
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .background(Color(UIColor(named: "BG")!))
            }
            .navigationTitle("Sabotage")
        }
        .tint(Color(UIColor.systemBrown))
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
        .task {
            print(matchManager.players ?? [])
            for pl in (matchManager.players ?? []) {
                pl.loadPhoto(for: .small) { image, error in
                    if let error = error {
                        print(error.localizedDescription)
                    } else if let image = image {
                        playerDisplays.insert(PlayerDisplay(id: pl.gamePlayerID, name: pl.displayName, image: image), at: 0)
                    }
                }
            }
        }
    }
}

#Preview {
    SaboteurView(matchManager: MatchManager())
}
