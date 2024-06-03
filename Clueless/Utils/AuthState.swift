//
//  AuthState.swift
//  Clueless
//
//  Created by Kevin Nathanael Halim on 31/05/24.
//

import Foundation

enum AuthState: String {
    case authenticating = "Logging into Game Center..."
    case unauthenticated = "Please sign in to Game Center first."
    case authenticated = ""
    
    case error = "Failed to login to Game Center."
    case restricted = "You are not allowed to play multiplayer games!"
}
