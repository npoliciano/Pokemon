//
//  PokemonTests.swift
//  PokemonTests
//
//  Created by Nicolle on 05/03/24.
//

import Combine
import XCTest
@testable import Pokemon

final class HomeViewModelTests: XCTestCase {
    func testInitDoesNotPerformAnyRequest() {
        let service = HomeServiceSpy()
        let sut = HomeViewModel(service: service, scheduler: .immediate)
        trackForMemoryLeaks(sut, service)

        XCTAssertEqual(service.getPokemonsCalls, 0)
    }

    func testInitialStateIsEmpty() {
        let service = HomeServiceSpy()
        let sut = HomeViewModel(service: service, scheduler: .immediate)
        trackForMemoryLeaks(sut, service)

        XCTAssertEqual(sut.state, .content([]))
    }

    func testGetsPokemonOnAppear() {
        // Arrange / Given
        let service = HomeServiceSpy()
        let sut = HomeViewModel(service: service, scheduler: .immediate)
        trackForMemoryLeaks(sut, service)

        // Act / When
        sut.onAppear()

        // Assert / Then
        XCTAssertEqual(service.getPokemonsCalls, 1)
    }

    func testStateIsErrorOnFailureToGetPokemons() {
        // Arrange / Given
        let service = HomeServiceSpy()
        let sut = HomeViewModel(service: service, scheduler: .immediate)
        trackForMemoryLeaks(sut, service)
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
        trackForMemoryLeaks(sut, service)
        service.expectedResult = .success([])

        // Act / When
        sut.onAppear()

        // Assert
        XCTAssertEqual(sut.state, .content([]))
    }
    func testStateIsContentWithPokemonsOnSuccessWithPokemonList() {
        // Arrange / Given
        let service = HomeServiceSpy()
        let sut = HomeViewModel(service: service, scheduler: .immediate)
        trackForMemoryLeaks(sut, service)
        let expectedPokemons = [
            Pokemon(id: 0, name: "0", imageUrl: URL(fileURLWithPath: "0"), primaryAttribute: "0", secondaryAttribute: "0", backgroundColor: .black),
            Pokemon(id: 1, name: "1", imageUrl: URL(fileURLWithPath: "1"), primaryAttribute: "1", secondaryAttribute: nil, backgroundColor: .blue)
        ]
        service.expectedResult = .success(expectedPokemons)

        // Act / When
        sut.onAppear()

        // Assert
        XCTAssertEqual(sut.state, .content(expectedPokemons))
    }

    func testGetsPokemonOnRefresh() {
        // Arrange / Given
        let service = HomeServiceSpy()
        let sut = HomeViewModel(service: service, scheduler: .immediate)
        trackForMemoryLeaks(sut, service)

        // Act / When
        sut.onRefresh()

        // Assert / Then
        XCTAssertEqual(service.getPokemonsCalls, 1)
    }

    func testStateIsErrorOnRefreshFailureToGetPokemons() {
        // Arrange / Given
        let service = HomeServiceSpy()
        let sut = HomeViewModel(service: service, scheduler: .immediate)
        trackForMemoryLeaks(sut, service)
        service.expectedResult = .failure(ErrorDummy())

        // Act / When
        sut.onRefresh()

        // Assert
        XCTAssertEqual(sut.state, .error)
    }

    func testStateIsEmptyContentOnRefreshSuccessWithEmptyPokemonList() {
        // Arrange / Given
        let service = HomeServiceSpy()
        let sut = HomeViewModel(service: service, scheduler: .immediate)
        trackForMemoryLeaks(sut, service)
        service.expectedResult = .success([])

        // Act / When
        sut.onRefresh()

        // Assert
        XCTAssertEqual(sut.state, .content([]))
    }
    func testStateIsContentWithPokemonsOnRefreshSuccessWithPokemonList() {
        // Arrange / Given
        let service = HomeServiceSpy()
        let sut = HomeViewModel(service: service, scheduler: .immediate)
        trackForMemoryLeaks(sut, service)
        let expectedPokemons = [
            Pokemon(id: 0, name: "0", imageUrl: URL(fileURLWithPath: "0"), primaryAttribute: "0", secondaryAttribute: "0", backgroundColor: .black),
            Pokemon(id: 1, name: "1", imageUrl: URL(fileURLWithPath: "1"), primaryAttribute: "1", secondaryAttribute: nil, backgroundColor: .blue)
        ]
        service.expectedResult = .success(expectedPokemons)

        // Act / When
        sut.onRefresh()

        // Assert
        XCTAssertEqual(sut.state, .content(expectedPokemons))
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
