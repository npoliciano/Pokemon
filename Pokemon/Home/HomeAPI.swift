//
//  HomeAPI.swift
//  Pokemon
//
//  Created by Nicolle on 19/03/24.
//

import Combine
import UIKit

protocol PokemonsDataSource {
    func getData() -> AnyPublisher<[PokemonJSON], Error>
}

final class HomeAPI {
    private let database: PokemonsDataSource

    init(database: PokemonsDataSource) {
        self.database = database
    }
}

extension HomeAPI: HomeService {
    func getPokemons() -> AnyPublisher<[Pokemon], Error> {
        database
            .getData()
            .map { pokemonsJson in
                pokemonsJson.map { Pokemon(json: $0) }
            }
            .eraseToAnyPublisher()
    }
}

extension FirebaseDatabaseService<[PokemonJSON]>: PokemonsDataSource {}
