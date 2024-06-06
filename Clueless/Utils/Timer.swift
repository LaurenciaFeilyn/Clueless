//
//  Timer.swift
//  Clueless
//
//  Created by Kevin Nathanael Halim on 07/06/24.
//

import Foundation

func minutesString(timer: Int) -> String {
    let minutes = timer / 60
    return String(format: "%02i", minutes)
}

func secondsString(timer: Int) -> String {
    let seconds = timer % 60
    return String(format: "%02i", seconds)
}
