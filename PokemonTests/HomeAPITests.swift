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
}

final class PokemonsDataSourceSpy: PokemonsDataSource {
    private(set) var getDataCalls = 0

    func getData() -> AnyPublisher<[PokemonJSON], Error> {
        getDataCalls += 1
        fatalError()
    }
}
