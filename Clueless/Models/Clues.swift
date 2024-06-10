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

let bottle = Clue(name: "Beer Can", image: "Beer Can")
let nothing = Clue(name: "Nothing", image: "Nothing")
let cigarettes = Clue(name: "Cigarettes", image: "Cigarettes")
let gum = Clue(name: "Gum Wrap", image: "Gum Wrap")
let tieClip = Clue(name: "Tie Clip", image: "Tie Clip")
let glass = Clue(name: "Glasses", image: "Glasses")
let inhaler = Clue(name: "Inhaler", image: "Inhaler")
let medicine = Clue(name: "Medicine", image: "Medicine")

