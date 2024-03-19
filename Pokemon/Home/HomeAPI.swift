//
//  HomeAPI.swift
//  Pokemon
//
//  Created by Nicolle on 19/03/24.
//

import Combine
import Foundation

final class HomeAPI {
    func getPokemons() -> AnyPublisher<[Pokemon], Error> {
        let pokemons: [Pokemon] = [
            .init(
                id: 0,
                name: "Pikachu",
                imageUrl: URL(string: "https://firebasestorage.googleapis.com/v0/b/pokedex-bb36f.appspot.com/o/pokemon_images%2F62CDB87E-9A76-4184-B82A-4FB38CDA2BD0?alt=media&token=82726149-f9a6-4299-8837-6bae1ecb1081")!,
                primaryAttribute: "Grass",
                secondaryAttribute: "Poison",
                backgroundColor: .pikachu
            ),
            .init(
                id: 1,
                name: "Pikachu",
                imageUrl: URL(string: "https://firebasestorage.googleapis.com/v0/b/pokedex-bb36f.appspot.com/o/pokemon_images%2FAE45F260-9012-45F5-BE75-5C8972014EAA?alt=media&token=55b2ea2f-d525-47c0-95ae-7ddf01e879d3")!,
                primaryAttribute: "Electric",
                secondaryAttribute: nil,
                backgroundColor: .pikachu
            )
        ]
        return Future { promise in
            promise(.success(pokemons))
        }
        .eraseToAnyPublisher()
    }
}
