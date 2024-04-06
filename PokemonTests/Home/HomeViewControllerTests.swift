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

        // Act
        sut.simulateAppearance()

        XCTAssertTrue(sut.collectionView.isHidden)
        XCTAssertFalse(sut.loadingView.isHidden)
        XCTAssertEqual(service.getPokemonsCalls, 1)
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
}
