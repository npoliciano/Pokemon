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
        let (_, service, _) = makeSUT()

        XCTAssertEqual(service.getPokemonsCalls, 0)
    }

    func testStartLoadingAndRequestPokemonsOnAppear() {
        let (sut, service, _) = makeSUT()

        sut.simulateAppearance()

        XCTAssertTrue(sut.collectionView.isHidden)
        XCTAssertFalse(sut.loadingView.isHidden)
        XCTAssertFalse(sut.refreshControl.isRefreshing)
        XCTAssertEqual(sut.numberOfPokemons, 0)
        XCTAssertEqual(service.getPokemonsCalls, 1)
    }

    func testPresentPokemonOnSuccess() {
        let (sut, service, _) = makeSUT()
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

    func testSetCellContentAndFetchImages() throws {
        let (sut, service, imageFetcher) = makeSUT()
        let pokemon1 = Pokemon.fixture()
        let pokemon2 = Pokemon.fixture(backgroundColor: .brown)
        let expectedImage1 = UIImage(resource: .pikachu)
        let expectedImage2 = UIImage(resource: .bulbasaur)

        service.expectedResult = .success([
            pokemon1,
            pokemon2,
        ])
        imageFetcher.expectedImages[pokemon1.imageUrl] = expectedImage1
        imageFetcher.expectedImages[pokemon2.imageUrl] = expectedImage2

        sut.simulateAppearance()

        let firstPokemonCell = try sut.getPokemonCell(at: 0)
        let secondPokemonCell = try sut.getPokemonCell(at: 1)
        XCTAssertEqual(firstPokemonCell.name, pokemon1.name)
        XCTAssertEqual(firstPokemonCell.primaryAttribute, pokemon1.primaryAttribute)
        XCTAssertEqual(firstPokemonCell.secondaryAttribute, pokemon1.secondaryAttribute)
        XCTAssertEqual(firstPokemonCell.background, pokemon1.backgroundColor)
        XCTAssertEqual(firstPokemonCell.image, expectedImage1)

        XCTAssertEqual(secondPokemonCell.name, pokemon2.name)
        XCTAssertEqual(secondPokemonCell.primaryAttribute, pokemon2.primaryAttribute)
        XCTAssertEqual(secondPokemonCell.secondaryAttribute, pokemon2.secondaryAttribute)
        XCTAssertEqual(secondPokemonCell.background, pokemon2.backgroundColor)
        XCTAssertEqual(secondPokemonCell.image, expectedImage2)

        XCTAssertEqual(imageFetcher.fetchCalls, 2)
    }

    // MARK: Helpers

    private func makeSUT(
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (HomeViewController, HomeServiceSpy, ImageFetcherSpy) {
        let service = HomeServiceSpy()
        let viewModel = HomeViewModel(
            service: service,
            scheduler: .immediate
        )
        let imageFecher = ImageFetcherSpy()
        let sut = HomeViewController(
            viewModel: viewModel,
            imageFetcher: imageFecher
        )

        trackForMemoryLeaks(sut, viewModel, service, imageFecher, file: file, line: line)

        return (sut, service, imageFecher)
    }
}

final class ImageFetcherSpy: ImageFetcher {
    private(set) var fetchCalls = 0
    var expectedImages: [URL: UIImage?] = [:]

    func fetch(from url: URL, completion: @escaping (UIImage?) -> Void) {
        fetchCalls += 1
        let image = expectedImages[url]!
        completion(image)
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

    var image: UIImage? {
        imageView.image
    }
}
