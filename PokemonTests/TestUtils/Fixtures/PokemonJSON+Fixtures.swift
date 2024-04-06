//
//  PokemonJSON+Extension.swift
//  PokemonTests
//
//  Created by Nicolle on 05/04/24.
//

import Foundation
@testable import Pokemon

extension PokemonJSON {
    static func fixture(
        id: Int = .anyValue,
        name: String = .anyValue,
        imageUrl: URL = .anyValue,
        primaryAttribute: String = .anyValue,
        secondaryAttribute: String? = nil,
        backgroundColor: String = .anyValue,
        specie: String = .anyValue,
        description: String = .anyValue,
        eggCycle: String = .anyValue,
        eggGroups: String = .anyValue,
        female: String = .anyValue,
        male: String = .anyValue,
        height: String = .anyValue,
        weight: String = .anyValue,
        hp: Int = .anyValue,
        attack: Int = .anyValue,
        defense: Int = .anyValue,
        speed: Int = .anyValue,
        statsTotal: Int = .anyValue,
        firstEvolutionChain: EvolutionChain = .fixture(),
        secondEvolutionChain: EvolutionChain = .fixture()
    ) -> PokemonJSON {
        PokemonJSON(
            id: id,
            name: name,
            imageUrl: imageUrl,
            primaryAttribute: primaryAttribute,
            secondaryAttribute: secondaryAttribute,
            backgroundColor: backgroundColor,
            specie: specie,
            description: description,
            eggCycle: eggCycle,
            eggGroups: eggGroups,
            female: female,
            male: male,
            height: height,
            weight: weight,
            hp: hp,
            attack: attack,
            defense: defense,
            speed: speed,
            statsTotal: statsTotal,
            firstEvolutionChain: firstEvolutionChain,
            secondEvolutionChain: secondEvolutionChain
        )
    }
}

extension PokemonJSON.EvolutionChain {
    static func fixture(
        from: Pokemon = .fixture(),
        to: Pokemon = .fixture()
    ) -> PokemonJSON.EvolutionChain {
        PokemonJSON.EvolutionChain(
            from: from,
            to: to
        )
    }
}

extension PokemonJSON.EvolutionChain.Pokemon {
    static func fixture(
        name: String = .anyValue,
        imageUrl: URL = .anyValue
    ) -> PokemonJSON.EvolutionChain.Pokemon {
        PokemonJSON.EvolutionChain.Pokemon(
            name: name,
            imageUrl: imageUrl
        )
    }
}
