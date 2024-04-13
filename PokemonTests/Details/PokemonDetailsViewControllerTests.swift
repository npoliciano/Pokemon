//
//  PokemonDetailsViewControllerTests.swift
//  PokemonTests
//
//  Created by Nicolle on 13/04/24.
//

import XCTest
@testable import Pokemon

final class PokemonDetailsViewControllerTests: XCTestCase {
    func testInitDoesNotPerformAnyRequests() {
        let service = PokemonDetailsServiceSpy()
        let viewModel = PokemonDetailsViewModel(service: service, scheduler: .immediate)
        let sut = PokemonDetailsViewController(viewModel: viewModel)

        XCTAssertEqual(service.getPokemonDetailsCalls, 0)
    }

}
