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

    // MARK: Details

    let specie: String
    let description: String
    let eggCycle: String
    let eggGroups: String
    let female: String
    let male: String
    let height: String
    let weight: String
    let hp: Int
    let attack: Int
    let defense: Int
    let speed: Int
    let statsTotal: Int
    let firstEvolutionChain: EvolutionChain
    let secondEvolutionChain: EvolutionChain

    struct EvolutionChain: Decodable {
        struct Pokemon: Decodable {
            let name: String
            let imageUrl: URL
        }

        let from: Pokemon
        let to: Pokemon
    }
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

extension PokemonDetails {
    init(json: PokemonJSON) {
        self.name = json.name
        self.imageUrl = json.imageUrl
        self.primaryAttribute = json.primaryAttribute
        self.secondaryAttribute = json.secondaryAttribute
        self.backgroundColor = UIColor(hex: json.backgroundColor) ?? .clear

        self.specie = json.specie
        self.description = json.description
        self.eggCycle = json.eggCycle
        self.eggGroups = json.eggGroups
        self.female = json.female
        self.male = json.male
        self.height = json.height
        self.weight = json.weight
        self.hp = json.hp
        self.attack = json.attack
        self.defense = json.defense
        self.speed = json.speed
        self.statsTotal = json.statsTotal
        self.firstEvolutionChain = EvolutionChain(json: json.firstEvolutionChain)
        self.secondEvolutionChain = EvolutionChain(json: json.secondEvolutionChain)
    }
}

extension EvolutionChain {
    init(json: PokemonJSON.EvolutionChain) {
        self.from = Pokemon(name: json.from.name, imageUrl: json.from.imageUrl)
        self.to = Pokemon(name: json.to.name, imageUrl: json.to.imageUrl)
    }
}
