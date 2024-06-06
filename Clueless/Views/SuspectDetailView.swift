//
//  SuspectDetailView.swift
//  Clueless
//
//  Created by Kevin Nathanael Halim on 06/06/24.
//

import SwiftUI

struct SuspectDetailView: View {
    var suspect: Suspect
    
    var body: some View {
        NavigationStack {
            VStack {
                Image(suspect.detail)
                    .resizable()
                    .scaledToFill()
            }
            .ignoresSafeArea()
            .navigationTitle("Suspect Detail")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    SuspectDetailView(suspect: Suspect(name: "Alex Miller", image: "Alex Miller 1", detail: "Alex Miller Detail"))
}
