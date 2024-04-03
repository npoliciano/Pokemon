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
        let service = PokemonsDataSourceSpy()
        let sut = HomeAPI(database: service)
        trackForMemoryLeaks(sut, service)

        XCTAssertEqual(service.getDataCalls, 0)
    }

    func testFailsToGetPokemons() {
        let service = PokemonsDataSourceSpy()
        let sut = HomeAPI(database: service)
        trackForMemoryLeaks(sut, service)
        service.expectedResult = .failure(ErrorDummy())

        var actualError: Error?
        let subscription = sut.getPokemons()
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
