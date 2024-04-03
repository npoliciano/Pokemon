//
//  PokemonDetailsAPITests.swift
//  PokemonTests
//
//  Created by Nicolle on 02/04/24.
//

import XCTest
import Combine
@testable import Pokemon

final class PokemonDetailsAPITests: XCTestCase {
    func testInitDoesNotPerformAnyRequest() {
        let service = FirebaseDatabaseServiceSpy()
        let sut = PokemonDetailsAPI(database: service)
        trackForMemoryLeaks(sut, service)

        XCTAssertEqual(service.getDataCalls, 0)
    }

    func testFailsToGetPokemonDetails() {
        let service = FirebaseDatabaseServiceSpy()
        let sut = PokemonDetailsAPI(database: service)
        trackForMemoryLeaks(sut, service)
        service.expectedResult = .failure(ErrorDummy())

        var actualError: Error?
        let subscription = sut.getPokemonDetails()
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

    func testMapsPokemonJsonOnSuccess() {
        let service = FirebaseDatabaseServiceSpy()
        let sut = PokemonDetailsAPI(database: service)
        trackForMemoryLeaks(sut, service)
        let expectedPokemonJSON = PokemonJSON(
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
        service.expectedResult = .success(expectedPokemonJSON)

        var actualPokemonDetails: PokemonDetails?
        let subscription = sut.getPokemonDetails()
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { pokemonDetails in
                    actualPokemonDetails = pokemonDetails
                }
            )

        XCTAssertEqual(actualPokemonDetails, PokemonDetails(json: expectedPokemonJSON))
    }
}

final class FirebaseDatabaseServiceSpy: FirebaseDatabaseServiceProtocol{
    private(set) var getDataCalls = 0

    var expectedResult = Result<PokemonJSON, Error>.failure(ErrorDummy())

    func getData() -> AnyPublisher<PokemonJSON, Error> {
        getDataCalls += 1
        return expectedResult
            .publisher
            .eraseToAnyPublisher()
    }
}
