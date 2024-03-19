//
//  PokemonDetailsAPI.swift
//  Pokemon
//
//  Created by Nicolle on 18/03/24.
//

import Combine
import UIKit

final class PokemonDetailsAPI {
    private let selectedPokemonId: Int

    init(selectedPokemonId: Int) {
        self.selectedPokemonId = selectedPokemonId
    }

    func getPokemonDetails() -> AnyPublisher<Pokemon, Error> {
        let pokemon = Pokemon(
            name: "Pikachu",
            primaryAttribute: "Electric",
            secondaryAttribute: nil,
            specie: "Mouse",
            image: .pikachu,
            predominantColor: UIColor(named: "Pikachu")!,
            description: """
                Pikachu is an Electric type Pokémon introduced in Generation 1.

                Pikachu has a Gigantamax form available in Pokémon Sword/Shield, with an exclusive G-Max move, G-Max Volt Crash.
                """,
            eggCycle: "10 (2,314–2,570 steps)",
            eggGroups: "Fairy, Field",
            female: "50%",
            male: "50%",
            height: "0.4 m (1′04″)",
            weight: "6.0 kg (13.2 lbs)",
            hp: 35,
            attack: 55,
            defense: 40,
            speed: 90,
            statsTotal: 220,
            firstEvolutionChain: EvolutionChain(
                from: EvolutionChain.Pokemon(
                    name: "Pichu",
                    image: .pikachu
                ),
                to: EvolutionChain.Pokemon(
                    name: "Pikachu",
                    image: .pikachu
                )
            ),
            secondEvolutionChain: EvolutionChain(
                from: EvolutionChain.Pokemon(
                    name: "Pikachu",
                    image: .pikachu
                ),
                to: EvolutionChain.Pokemon(
                    name: "Raichu",
                    image: .pikachu
                )
            )
        )

        return Future { promise in
            promise(.success(pokemon))
        }
        .eraseToAnyPublisher()
    }
}
