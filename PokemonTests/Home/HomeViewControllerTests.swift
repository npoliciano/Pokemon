//
//  HomeViewControllerTests.swift
//  PokemonTests
//
//  Created by Nicolle on 06/04/24.
//

import XCTest

@testable import Pokemon

final class HomeViewControllerTests: XCTestCase {
    func testInitDoesNotPerformAnyRequest() {
        let service = HomeServiceSpy()
        _ = HomeViewController(viewModel: HomeViewModel(
            service: service,
            scheduler: .immediate
        ))

        XCTAssertEqual(service.getPokemonsCalls, 0)
    }
}
