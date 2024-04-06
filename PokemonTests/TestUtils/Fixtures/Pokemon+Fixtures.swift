//
//  Pokemon+Fixtures.swift
//  PokemonTests
//
//  Created by Nicolle on 06/04/24.
//

import UIKit

@testable import Pokemon

extension Pokemon {
    static func fixture(
        id: Int = .anyValue,
        name: String = .anyValue,
        imageUrl: URL = .anyValue,
        primaryAttribute: String = .anyValue,
        secondaryAttribute: String? = nil,
        backgroundColor: UIColor = .clear
    ) -> Pokemon {
        Pokemon(
            id: id,
            name: name,
            imageUrl: imageUrl,
            primaryAttribute: primaryAttribute,
            secondaryAttribute: secondaryAttribute,
            backgroundColor: backgroundColor
        )
    }
}
