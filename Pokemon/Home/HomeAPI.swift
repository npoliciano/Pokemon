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
    private let dataSource: PokemonsDataSource

    init(dataSource: PokemonsDataSource) {
        self.dataSource = dataSource
    }
}

extension HomeAPI: HomeService {
    func getPokemons() -> AnyPublisher<[Pokemon], Error> {
        dataSource
            .getData()
            .map { pokemonsJson in
                pokemonsJson.map { Pokemon(json: $0) }
            }
            .eraseToAnyPublisher()
    }
}

extension FirebaseDataSource<[PokemonJSON]>: PokemonsDataSource {}
