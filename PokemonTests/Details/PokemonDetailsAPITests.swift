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
        let service = PokemonDetailsDataSourceSpy()
        let sut = PokemonDetailsAPI(database: service)
        trackForMemoryLeaks(sut, service)

        XCTAssertEqual(service.getDataCalls, 0)
    }

    func testFailsToGetPokemonDetails() {
        let service = PokemonDetailsDataSourceSpy()
        let sut = PokemonDetailsAPI(database: service)
        trackForMemoryLeaks(sut, service)
        service.expectedResult = .failure(ErrorDummy())

        var actualError: Error?
        _ = sut.getPokemonDetails()
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
        let service = PokemonDetailsDataSourceSpy()
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
        _ = sut.getPokemonDetails()
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { pokemonDetails in
                    actualPokemonDetails = pokemonDetails
                }
            )

        XCTAssertEqual(actualPokemonDetails, PokemonDetails(json: expectedPokemonJSON))
    }
}

final class PokemonDetailsDataSourceSpy: PokemonDetailsDataSource {
    private(set) var getDataCalls = 0

    var expectedResult = Result<PokemonJSON, Error>.failure(ErrorDummy())

    func getData() -> AnyPublisher<PokemonJSON, Error> {
        getDataCalls += 1
        return expectedResult
            .publisher
            .eraseToAnyPublisher()
    }
}

extension PokemonDetails: Equatable {
    public static func ==(lhs: PokemonDetails, rhs: PokemonDetails) -> Bool {
        lhs.name == rhs.name &&
        lhs.primaryAttribute == rhs.primaryAttribute &&
        lhs.secondaryAttribute == rhs.secondaryAttribute &&
        lhs.specie == rhs.specie &&
        lhs.imageUrl == rhs.imageUrl &&
        lhs.backgroundColor == rhs.backgroundColor &&
        lhs.description == rhs.description &&
        lhs.eggCycle == rhs.eggCycle &&
        lhs.eggGroups == rhs.eggGroups &&
        lhs.female == rhs.female &&
        lhs.male == rhs.male &&
        lhs.height == rhs.height &&
        lhs.weight == rhs.weight &&
        lhs.hp == rhs.hp &&
        lhs.attack == rhs.attack &&
        lhs.defense == rhs.defense &&
        lhs.speed == rhs.speed &&
        lhs.statsTotal == rhs.statsTotal &&
        lhs.firstEvolutionChain == rhs.firstEvolutionChain &&
        lhs.secondEvolutionChain == rhs.secondEvolutionChain
    }
}

extension EvolutionChain: Equatable {
    public static func == (lhs: EvolutionChain, rhs: EvolutionChain) -> Bool {
        lhs.from == rhs.from &&
        lhs.to == rhs.to
    }
}

extension EvolutionChain.Pokemon: Equatable {
    public static func == (lhs: EvolutionChain.Pokemon, rhs: EvolutionChain.Pokemon) -> Bool {
        lhs.name == rhs.name &&
        lhs.imageUrl == rhs.imageUrl
    }
}
