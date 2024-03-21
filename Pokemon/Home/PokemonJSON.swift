//
//  PokemonJSON.swift
//  Pokemon
//
//  Created by Nicolle on 20/03/24.
//

import UIKit

struct PokemonJSON: Decodable {
    let id: Int
    let name: String
    let imageUrl: URL
    let primaryAttribute: String
    let secondaryAttribute: String?
    let backgroundColor: String
}

extension Pokemon {
    init(json: PokemonJSON) {
        self.id = json.id
        self.name = json.name
        self.imageUrl = json.imageUrl
        self.primaryAttribute = json.primaryAttribute
        self.secondaryAttribute = json.secondaryAttribute
        self.backgroundColor = UIColor(hex: json.backgroundColor) ?? .clear
    }
}
