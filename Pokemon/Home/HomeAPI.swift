//
//  HomeAPI.swift
//  Pokemon
//
//  Created by Nicolle on 19/03/24.
//

import Combine
import Foundation
import UIKit

final class HomeAPI {
    private let database: FirebaseDatabaseService<[PokemonJSON]>

    init(database: FirebaseDatabaseService<[PokemonJSON]>) {
        self.database = database
    }

    func getPokemons() -> AnyPublisher<[Pokemon], Error> {
        database
            .getData()
            .map { pokemonsJson in
                pokemonsJson.map { Pokemon(json: $0) }
            }
            .eraseToAnyPublisher()
    }
}
