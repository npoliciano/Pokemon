//
//  PokemonDetails+Fixtures.swift
//  PokemonTests
//
//  Created by Nicolle on 15/04/24.
//

import Foundation
import UIKit
@testable import Pokemon

extension PokemonDetails {
    static func fixture(
        name: String = .anyValue,
        imageUrl: URL = .anyValue,
        primaryAttribute: String = .anyValue,
        secondaryAttribute: String? = nil,
        backgroundColor: UIColor = .clear,
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
    ) -> PokemonDetails {
        PokemonDetails(
            name: name,
            primaryAttribute: primaryAttribute,
            secondaryAttribute: secondaryAttribute,
            specie: specie,
            imageUrl: imageUrl,
            backgroundColor: backgroundColor,
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

extension EvolutionChain {
    static func fixture(
        from: Pokemon = .fixture(),
        to: Pokemon = .fixture()
    ) -> EvolutionChain {
        EvolutionChain(
            from: from,
            to: to
        )
    }
}

extension EvolutionChain.Pokemon {
    static func fixture(
        name: String = .anyValue,
        imageUrl: URL = .anyValue
    ) -> EvolutionChain.Pokemon {
        EvolutionChain.Pokemon(
            name: name,
            imageUrl: imageUrl
        )
    }
}
