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

        XCTAssertEqual(service.getDataCalls, 0)
    }

    func testIsErrorOnFailureToGetJSONData() {
        let service = FirebaseDatabaseServiceSpy()
        let sut = PokemonDetailsAPI(database: service)

        _ = sut.getPokemonDetails()

        XCTAssertEqual(service.getDataCalls, 1)
    }
}

final class FirebaseDatabaseServiceSpy: FirebaseDatabaseServiceProtocol{
    private(set) var getDataCalls = 0

    func getData() -> AnyPublisher<PokemonJSON, Error> {
        getDataCalls += 1
        return Result.failure(ErrorDummy())
            .publisher
            .eraseToAnyPublisher()
    }
}
