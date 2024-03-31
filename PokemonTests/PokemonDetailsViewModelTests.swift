//
//  PokemonDetailsViewModelTests.swift
//  PokemonTests
//
//  Created by Nicolle on 30/03/24.
//

import Combine
import XCTest
@testable import Pokemon

final class PokemonDetailsViewModelTests: XCTestCase {
    func testInitDoesNotPerformAnyRequest() {
        let service = PokemonDetailsServiceSpy()
        let sut = PokemonDetailsViewModel(service: service)

        XCTAssertEqual(service.getPokemonDetailsCalls, 0)
    }
}

final class PokemonDetailsServiceSpy: PokemonDetailsService {
    private(set) var getPokemonDetailsCalls = 0

    func getPokemonDetails() -> AnyPublisher<PokemonDetails, Error> {
        getPokemonDetailsCalls += 1
        fatalError()
    }

}
