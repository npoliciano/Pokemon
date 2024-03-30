//
//  PokemonTests.swift
//  PokemonTests
//
//  Created by Nicolle on 05/03/24.
//

import Combine
import XCTest
@testable import Pokemon

/*
 Testar:

 Behavioral / Functional

 - ✅ init não chama nada
 - ✅ se o estado inicial é content([])
 - que o onRefresh executa o onAppear

 - Stubbing:
 - se quando obtém sucesso do getPokemon, o state é alterado para content e recebe a pokemon list
 - se quando getPokemon falha, o state é alterado .error


 Structural / Non-functional

 - se getPokemons está sendo chamado (Spy)
 - se getPokemons conclui na main thread
 - se não memory leak / retain cycle
 */

final class HomeViewModelTests: XCTestCase {
    func testInitDoesNotPerformAnyRequest() {
        let service = HomeServiceSpy()
        _ = HomeViewModel(service: service)

        XCTAssertEqual(service.getPokemonsCalls, 0)
    }

    func testInitialStateIsEmpty() {
        let service = HomeServiceSpy()
        let sut = HomeViewModel(service: service)

        XCTAssertEqual(sut.state, .content([]))
    }

    func testGetsPokemonOnAppear() {
        // Arrange / Given
        let service = HomeServiceSpy()
        let sut = HomeViewModel(service: service)

        // Act / When
        sut.onAppear()

        // Assert / Then
        XCTAssertEqual(service.getPokemonsCalls, 1)
    }
}

final class HomeServiceSpy: HomeService {
    var getPokemonsCalls = 0

    func getPokemons() -> AnyPublisher<[Pokemon], Error> {
        getPokemonsCalls += 1
        return Result.success([])
            .publisher
            .eraseToAnyPublisher()
    }
}

extension HomeViewState: Equatable {
    public static func ==(lhs: HomeViewState, rhs: HomeViewState) -> Bool {
        switch (lhs, rhs) {
        case (.error, .error):
            return true
        case (.content(let lhsPokemons), .content(let rhsPokemons)):
            return lhsPokemons == rhsPokemons
        default:
            return false
        }
    }
}

extension Pokemon: Equatable {
    public static func ==(lhs: Pokemon, rhs: Pokemon) -> Bool {
        lhs.id == rhs.id &&
        lhs.name == rhs.name &&
        lhs.imageUrl == rhs.imageUrl &&
        lhs.primaryAttribute == rhs.primaryAttribute &&
        lhs.secondaryAttribute == rhs.secondaryAttribute &&
        lhs.backgroundColor == rhs.backgroundColor
    }
}
