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
let noBottle = Clue(name: "Nothing", image: "No Bottle")
let cigarettes = Clue(name: "Cigarettes", image: "Cigarettes")
let noCigarettes = Clue(name: "Nothing", image: "No Cigarettes")
let gum = Clue(name: "Gum Wrap", image: "Gum Wrap")
let noGum = Clue(name: "Nothing", image: "No Gum")
let tieClip = Clue(name: "Tie Clip", image: "Tie Clip")
let noTieClip = Clue(name: "Nothing", image: "No Tie Clip")
let glass = Clue(name: "Glasses", image: "Glasses")
let noGlass = Clue(name: "Nothing", image: "No Glasses")
let inhaler = Clue(name: "Inhaler", image: "Inhaler")
let noInhaler = Clue(name: "Nothing", image: "No Inhaler")
let medicine = Clue(name: "Medicine", image: "Medicine")
let noMedicine = Clue(name: "Nothing", image: "No Medicine")

