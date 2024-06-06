//
//  SuspectsView.swift
//  Clueless
//
//  Created by Kevin Nathanael Halim on 05/06/24.
//

import SwiftUI

struct SuspectsView: View {
    var body: some View {
        NavigationStack {
            GeometryReader { metrics in
                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                        ForEach(suspectList, id: \.name) { suspect in
                            NavigationLink {
                                // DetailView(history: history)
                            } label: {
                                VStack {
                                    Image(suspect.image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width:metrics.size.width * 0.43, height:metrics.size.width * 0.45)
                                        .clipped()
                                        .padding(.bottom, 8)
                                    
                                    Text(suspect.name)
                                        .font(.headline)
                                        .fontWeight(.bold)
                                        .foregroundStyle(.white)
                                }
                                .padding(.bottom, 16)
                                .background(Color(UIColor.systemBrown))
                                .clipShape(RoundedRectangle(cornerRadius: 8.0))
                            }
                        }
                        .padding(.vertical, 8)
                    }
                }
            }
            .padding(.horizontal, 12)
            .background(Color(UIColor.secondarySystemBackground))
            .navigationTitle("Suspects")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    SuspectsView()
}
