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
}

final class FirebaseDatabaseServiceSpy: FirebaseDatabaseServiceProtocol{
    private(set) var getDataCalls = 0

    func getData() -> AnyPublisher<PokemonJSON, Error> {
        getDataCalls += 1
        fatalError()
    }
}
