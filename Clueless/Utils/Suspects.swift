//
//  Suspects.swift
//  Clueless
//
//  Created by Kevin Nathanael Halim on 05/06/24.
//

import Foundation

struct Suspect {
    var name: String
    var image: String
    var detail: String
    var isAlcoholic: Bool = true
    var isSmoker: Bool = true
    var likesGum: Bool = true
    var wearsTie: Bool = true
    var wearsGlasses: Bool = true
    var hasAsthma: Bool = true
    var hasMentalIllness: Bool = true
}

var suspectList: [Suspect] = [
    Suspect(name: "Alex Miller", image: "Alex Miller 1", detail: "Alex Miller Detail", isSmoker: false, likesGum: false),
    Suspect(name: "Jamie Walker", image: "Jamie Walker 1", detail: "Jamie Walker Detail", isAlcoholic: false, isSmoker: false),
    Suspect(name: "Riley Thomas", image: "Riley Thomas 1", detail: "Riley Thomas Detail", wearsGlasses: false, hasMentalIllness: false),
    Suspect(name: "Robin Wright", image: "Robin Wright 1", detail: "Robin Wright Detail", likesGum: false, wearsTie: false),
    Suspect(name: "Taylor Brooks", image: "Taylor Brooks 1", detail: "Taylor Brooks Detail", isAlcoholic: false, wearsTie: false),
    Suspect(name: "Nova Lawson", image: "Nova Lawson 1", detail: "Nova Lawson Detail", isAlcoholic: false, hasAsthma: false),
    Suspect(name: "Blair Davies", image: "Blair Davies 1", detail: "Blair Davies Detail", likesGum: false, hasMentalIllness: false),
    Suspect(name: "Cameron Lee", image: "Cameron Lee 1", detail: "Cameron Lee Detail", wearsTie: false, wearsGlasses: false),
    Suspect(name: "Morgan Blake", image: "Morgan Blake 1", detail: "Morgan Blake Detail", wearsGlasses: false, hasAsthma: false),
    Suspect(name: "Avery Baker", image: "Avery Baker 1", detail: "Avery Baker Detail", isSmoker: false, hasAsthma: false),
    Suspect(name: "Dakota Quinn", image: "Dakota Quinn 1", detail: "Dakota Quinn Detail", isAlcoholic: false, hasMentalIllness: false),
    Suspect(name: "Skylar Moore", image: "Skylar Moore 1", detail: "Skylar Moore Detail", isSmoker: false, wearsGlasses: false),
    Suspect(name: "Leslie Carter", image: "Leslie Carter 1", detail: "Leslie Carter Detail", likesGum: false, hasAsthma: false),
    Suspect(name: "Rowan Gray", image: "Rowan Gray 1", detail: "Rowan Gray Detail", wearsTie: false, hasMentalIllness: false)
]

