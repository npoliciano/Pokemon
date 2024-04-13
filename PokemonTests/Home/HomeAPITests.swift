//
//  HomeAPITests.swift
//  PokemonTests
//
//  Created by Nicolle on 02/04/24.
//

import XCTest
import Combine
@testable import Pokemon

final class HomeAPITests: XCTestCase {
    func testInitDoesNotPerformAnyRequest() {
        let dataSource = PokemonsDataSourceSpy()
        let sut = HomeAPI(dataSource: dataSource)
        trackForMemoryLeaks(sut, dataSource)

        XCTAssertEqual(dataSource.getDataCalls, 0)
    }

    func testFailsToGetPokemons() {
        let dataSource = PokemonsDataSourceSpy()
        let sut = HomeAPI(dataSource: dataSource)
        trackForMemoryLeaks(sut, dataSource)
        dataSource.expectedResult = .failure(ErrorDummy())

        var actualError: Error?
        _ = sut.getPokemons()
            .sink(
                receiveCompletion: { completion in
                    if case.failure(let error) = completion {
                        actualError = error
                    }
                },
                receiveValue: { _ in }
            )

        XCTAssertEqual(actualError as? ErrorDummy, ErrorDummy())
    }

    func testMapsPokemonsJsonOnSuccess() {
        let dataSource = PokemonsDataSourceSpy()
        let sut = HomeAPI(dataSource: dataSource)
        trackForMemoryLeaks(sut, dataSource)

        let firstExpectedPokemonJSON = PokemonJSON(
            id: 0,
            name: "0",
            imageUrl: URL(filePath: "0"),
            primaryAttribute: "0",
            secondaryAttribute: "0",
            backgroundColor: "0",
            specie: "0",
            description: "0",
            eggCycle: "0",
            eggGroups: "0",
            female: "0",
            male: "0",
            height: "0",
            weight: "0",
            hp: 0,
            attack: 0,
            defense: 0,
            speed: 0,
            statsTotal: 0,
            firstEvolutionChain: PokemonJSON.EvolutionChain(
                from: .init(name: "0", imageUrl: URL(filePath: "0")),
                to: .init(name: "0", imageUrl: URL(filePath: "0"))
            ),
            secondEvolutionChain: PokemonJSON.EvolutionChain(
                from: .init(name: "0", imageUrl: URL(filePath: "0")),
                to: .init(name: "0", imageUrl: URL(filePath: "0"))
            )
        )

        let secondExpectedPokemonJSON = PokemonJSON(
            id: 1,
            name: "1",
            imageUrl: URL(filePath: "1"),
            primaryAttribute: "1",
            secondaryAttribute: "1",
            backgroundColor: "1",
            specie: "1",
            description: "1",
            eggCycle: "1",
            eggGroups: "1",
            female: "1",
            male: "1",
            height: "1",
            weight: "1",
            hp: 1,
            attack: 1,
            defense: 1,
            speed: 1,
            statsTotal: 1,
            firstEvolutionChain: PokemonJSON.EvolutionChain(
                from: .init(name: "1", imageUrl: URL(filePath: "1")),
                to: .init(name: "1", imageUrl: URL(filePath: "1"))
            ),
            secondEvolutionChain: PokemonJSON.EvolutionChain(
                from: .init(name: "1", imageUrl: URL(filePath: "1")),
                to: .init(name: "1", imageUrl: URL(filePath: "1"))
            )
        )

        dataSource.expectedResult = .success([firstExpectedPokemonJSON, secondExpectedPokemonJSON])

        var actualPokemons: [Pokemon]?
        _ = sut.getPokemons()
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { pokemons in
                    actualPokemons = pokemons
                }
            )

        XCTAssertEqual(actualPokemons, [
            Pokemon(json: firstExpectedPokemonJSON),
            Pokemon(json: secondExpectedPokemonJSON)
        ])
    }
}


final class PokemonsDataSourceSpy: PokemonsDataSource {
    private(set) var getDataCalls = 0

    var expectedResult = Result<[PokemonJSON], Error>.failure(ErrorDummy())

    func getData() -> AnyPublisher<[PokemonJSON], Error> {
        getDataCalls += 1
        return expectedResult
            .publisher
            .eraseToAnyPublisher()
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
