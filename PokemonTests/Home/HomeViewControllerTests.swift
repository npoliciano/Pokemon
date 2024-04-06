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

    func testSetCellContent() throws {
        let (sut, service) = makeSUT()
        let pokemon1 = Pokemon.fixture()
        let pokemon2 = Pokemon.fixture(backgroundColor: .brown)

        service.expectedResult = .success([
            pokemon1,
            pokemon2,
        ])

        sut.simulateAppearance()

        let firstPokemonCell = try sut.getPokemonCell(at: 0)
        let secondPokemonCell = try sut.getPokemonCell(at: 1)
        XCTAssertEqual(firstPokemonCell.name, pokemon1.name)
        XCTAssertEqual(firstPokemonCell.primaryAttribute, pokemon1.primaryAttribute)
        XCTAssertEqual(firstPokemonCell.secondaryAttribute, pokemon1.secondaryAttribute)
        XCTAssertEqual(firstPokemonCell.background, pokemon1.backgroundColor)

        XCTAssertEqual(secondPokemonCell.name, pokemon2.name)
        XCTAssertEqual(secondPokemonCell.primaryAttribute, pokemon2.primaryAttribute)
        XCTAssertEqual(secondPokemonCell.secondaryAttribute, pokemon2.secondaryAttribute)
        XCTAssertEqual(secondPokemonCell.background, pokemon2.backgroundColor)
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

    func getPokemonCell(
        at item: Int,
        file: StaticString = #filePath,
        line: UInt = #line
    ) throws -> PokemonCell {
        try XCTUnwrap(
            collectionView(
                collectionView,
                cellForItemAt: IndexPath(item: item, section: 0)
            ) as? PokemonCell,
            file: file,
            line: line
        )
    }

    var numberOfPokemons: Int {
        collectionView.numberOfItems(inSection: 0)
    }
}

extension PokemonCell {
    var name: String? {
        nameLabel.text
    }

    var primaryAttribute: String? {
        primaryAttributeView.valueLabel.text
    }

    var secondaryAttribute: String? {
        secondaryAttributeView.valueLabel.text
    }

    var background: UIColor? {
        contentView.backgroundColor
    }
}
