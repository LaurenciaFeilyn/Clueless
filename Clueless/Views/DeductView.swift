//
//  DeductView.swift
//  Clueless
//
//  Created by Kevin Nathanael Halim on 03/06/24.
//

import SwiftUI

struct DeductView: View {
    @ObservedObject var matchManager: MatchManager
    @State private var chosenSuspect: Suspect?
    @State private var hasDeducted: Bool = false
    
    var body: some View {
        ZStack {
            Color(UIColor.secondarySystemBackground)
                .ignoresSafeArea()
            
            VStack {
                Text("Deduct the Killer")
                    .bold()
                    .padding()
                
                GeometryReader { metrics in
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                            ForEach(suspectList, id: \.name) { suspect in
                                Button {
                                    chosenSuspect = suspect
                                } label: {
                                    VStack {
                                        Image(suspect.image)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width:metrics.size.width * 0.41, height:metrics.size.width * 0.43)
                                            .clipped()
                                            .padding(.bottom, 8)
                                        
                                        Text(suspect.name)
                                            .font(.headline)
                                            .fontWeight(.bold)
                                            .foregroundStyle(chosenSuspect?.name == suspect.name ? .white : Color(UIColor.systemBrown))
                                    }
                                    .padding(.bottom, 16)
                                    .background(chosenSuspect?.name == suspect.name ? Color(UIColor.systemBrown) : Color(UIColor.systemBackground))
                                    .clipShape(RoundedRectangle(cornerRadius: 8.0))
                                }
                            }
                            .padding(.vertical, 8)
                        }
                    }
                    .padding(.horizontal, 12)
                }
                
                Button {
                    matchManager.deductKiller(suspect: chosenSuspect!)
                    hasDeducted = true
                } label: {
                    Text(chosenSuspect == nil ? "Choose a Suspect" : (hasDeducted ? "Waiting for others..." : "Vote \(chosenSuspect?.name ?? "")"))
                        .padding(.horizontal, 80)
                        .padding(.vertical, 8)
                }
                .buttonStyle(.borderedProminent)
                .tint(Color(UIColor.systemBrown))
                .disabled(chosenSuspect == nil || hasDeducted)
                .padding(.top, 16)
            }
        }
        .interactiveDismissDisabled()
    }
}

#Preview {
    DeductView(matchManager: MatchManager())
}
