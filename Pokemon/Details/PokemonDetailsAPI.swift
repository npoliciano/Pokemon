//
//  PokemonDetailsAPI.swift
//  Pokemon
//
//  Created by Nicolle on 18/03/24.
//

import Combine
import UIKit

protocol PokemonDetailsDataSource {
    func getData() -> AnyPublisher<PokemonJSON, Error>
}

final class PokemonDetailsAPI {
    private let dataSource: PokemonDetailsDataSource

    init(dataSource: PokemonDetailsDataSource) {
        self.dataSource = dataSource
    }
}

extension PokemonDetailsAPI: PokemonDetailsService {
    func getPokemonDetails() -> AnyPublisher<PokemonDetails, Error> {
        dataSource
            .getData()
            .map {
                PokemonDetails(json: $0)
            }
            .eraseToAnyPublisher()
    }
}

extension FirebaseDataSource<PokemonJSON>: PokemonDetailsDataSource {}
