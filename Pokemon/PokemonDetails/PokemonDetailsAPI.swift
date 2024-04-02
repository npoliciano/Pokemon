//
//  PokemonDetailsAPI.swift
//  Pokemon
//
//  Created by Nicolle on 18/03/24.
//

import Combine
import UIKit

protocol FirebaseDatabaseServiceProtocol {
    func getData() -> AnyPublisher<PokemonJSON, Error>
}

final class PokemonDetailsAPI {
    private let database: FirebaseDatabaseServiceProtocol

    init(database: FirebaseDatabaseServiceProtocol) {
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

extension FirebaseDatabaseService<PokemonJSON>: FirebaseDatabaseServiceProtocol {}
