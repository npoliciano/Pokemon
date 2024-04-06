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
        let (_, service) = makeSUT()

        XCTAssertEqual(service.getPokemonsCalls, 0)
    }

    func testStartLoadingAndRequestPokemonsOnAppear() {
        let (sut, service) = makeSUT()

        sut.simulateAppearance()

        XCTAssertTrue(sut.collectionView.isHidden)
        XCTAssertFalse(sut.loadingView.isHidden)
        XCTAssertFalse(sut.refreshControl.isRefreshing)
        XCTAssertEqual(sut.numberOfPokemons, 0)
        XCTAssertEqual(service.getPokemonsCalls, 1)
    }

    func testPresentPokemonOnSuccess() {
        let (sut, service) = makeSUT()
        service.expectedResult = .success([
            Pokemon.fixture(),
            Pokemon.fixture(),
        ])

        sut.simulateAppearance()

        XCTAssertFalse(sut.collectionView.isHidden)
        XCTAssertTrue(sut.loadingView.isHidden)
        XCTAssertEqual(service.getPokemonsCalls, 1)
        XCTAssertEqual(sut.numberOfPokemons, 2)
    }

    // MARK: Helpers
    private func makeSUT(
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (HomeViewController, HomeServiceSpy) {
        let service = HomeServiceSpy()
        let viewModel = HomeViewModel(
            service: service,
            scheduler: .immediate
        )
        let sut = HomeViewController(viewModel: viewModel)

        trackForMemoryLeaks(sut, viewModel, service, file: file, line: line)

        return (sut, service)
    }
}

extension HomeViewController {
    func simulateAppearance() {
        if !isViewLoaded {
            loadViewIfNeeded()
        }

        beginAppearanceTransition(true, animated: false)
        endAppearanceTransition()
    }

    var numberOfPokemons: Int {
        collectionView.numberOfItems(inSection: 0)
    }
}

extension Pokemon {
    static func fixture(
        id: Int = .anyValue,
        name: String = .anyValue,
        imageUrl: URL = .anyValue,
        primaryAttribute: String = .anyValue,
        secondaryAttribute: String? = nil,
        backgroundColor: UIColor = .clear
    ) -> Pokemon {
        Pokemon(
            id: id,
            name: name,
            imageUrl: imageUrl,
            primaryAttribute: primaryAttribute,
            secondaryAttribute: secondaryAttribute,
            backgroundColor: backgroundColor
        )
    }
}
