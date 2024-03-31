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
 - se quando obtém sucesso do getPokemon empty, o state é alterado para content com lista vazia
 - ✅ se quando getPokemon falha, o state é alterado .error


 Structural / Non-functional

 - ✅ se getPokemons está sendo chamado (Spy)
 - se getPokemons conclui na main thread
 - se não memory leak / retain cycle
 */

final class HomeViewModelTests: XCTestCase {
    func testInitDoesNotPerformAnyRequest() {
        let service = HomeServiceSpy()
        _ = HomeViewModel(service: service, scheduler: .immediate)

        XCTAssertEqual(service.getPokemonsCalls, 0)
    }

    func testInitialStateIsEmpty() {
        let service = HomeServiceSpy()
        let sut = HomeViewModel(service: service, scheduler: .immediate)

        XCTAssertEqual(sut.state, .content([]))
    }

    func testGetsPokemonOnAppear() {
        // Arrange / Given
        let service = HomeServiceSpy()
        let sut = HomeViewModel(service: service, scheduler: .immediate)

        // Act / When
        sut.onAppear()

        // Assert / Then
        XCTAssertEqual(service.getPokemonsCalls, 1)
    }

    func testStateIsErrorOnFailureToGetPokemons() {
        // Arrange / Given
        let service = HomeServiceSpy()
        let sut = HomeViewModel(service: service, scheduler: .immediate)
        service.expectedResult = .failure(ErrorDummy())

        // Act / When
        sut.onAppear()

        // Assert
        XCTAssertEqual(sut.state, .error)
    }

    func testStateIsEmptyContentOnSuccessWithEmptyPokemonList() {
        // Arrange / Given
        let service = HomeServiceSpy()
        let sut = HomeViewModel(service: service, scheduler: .immediate)
        service.expectedResult = .success([])

        // Act / When
        sut.onAppear()

        // Assert
        XCTAssertEqual(sut.state, .content([]))
    }
}

final class HomeServiceSpy: HomeService {
    private(set) var getPokemonsCalls = 0

    var expectedResult = Result<[Pokemon], Error>.failure(ErrorDummy())

    func getPokemons() -> AnyPublisher<[Pokemon], Error> {
        getPokemonsCalls += 1
        return expectedResult
            .publisher
            .eraseToAnyPublisher()
    }
}

struct ErrorDummy: Error { }

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
