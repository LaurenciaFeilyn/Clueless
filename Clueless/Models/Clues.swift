//
//  Clues.swift
//  Clueless
//
//  Created by Kevin Nathanael Halim on 07/06/24.
//

import Foundation

struct Clue {
    var name: String
    var image: String
}

var clueList: [Clue] = [] //for NFC tags

let nothing = Clue(name: "Nothing", image: "Nothing")
let bottle = Clue(name: "Bottle", image: "Bottle")
let cigarettes = Clue(name: "Cigarettes", image: "Cigarettes")
let gum = Clue(name: "Gum", image: "Gum")
let tieClip = Clue(name: "Tie Clip", image: "Tie Clip")
let glass = Clue(name: "Glasses", image: "Glasses")
let inhaler = Clue(name: "Inhaler", image: "Inhaler")
let medicine = Clue(name: "Medicine", image: "Medicine")

