//
//  PokemonDetailsAPI.swift
//  Pokemon
//
//  Created by Nicolle on 18/03/24.
//

import Combine
import UIKit

final class PokemonDetailsAPI {
    private let database: FirebaseDatabaseService<PokemonJSON>

    init(database: FirebaseDatabaseService<PokemonJSON>) {
        self.database = database
    }
}

extension PokemonDetailsAPI: PokemonDetailsService {
    func getPokemonDetails() -> AnyPublisher<PokemonDetails, Error> {
        database
            .getData()
            .map {
                PokemonDetails(json: $0)
            }
            .eraseToAnyPublisher()
    }
}
