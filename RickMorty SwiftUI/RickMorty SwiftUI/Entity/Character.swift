//
//  Character.swift
//  RickMorty SwiftUI
//
//  Created by Dani on 25/12/22.
//

import Foundation

struct Character: Identifiable, Equatable, Codable{
    static func == (lhs: Character, rhs: Character) -> Bool {
            return lhs.id == rhs.id
    }

    let id: Int
    let name: String
    let gender: String
    let image: String
}

struct CharacterList: Codable {
    var results: [Character]
}
