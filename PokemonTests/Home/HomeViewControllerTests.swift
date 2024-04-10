//
//  HomeViewControllerTests.swift
//  PokemonTests
//
//  Created by Nicolle on 06/04/24.
//

import Combine
import XCTest

@testable import Pokemon

final class HomeViewControllerTests: XCTestCase {
    func testInitDoesNotPerformAnyRequest() {
        let (_, service, _, _) = makeSUT()

        XCTAssertEqual(service.getPokemonsCalls, 0)
    }

    func testStartLoadingAndRequestPokemonsOnAppear() {
        let (sut, service, _, _) = makeSUT()

        sut.simulateAppearance()

        XCTAssertTrue(sut.collectionView.isHidden)
        XCTAssertFalse(sut.loadingView.isHidden)
        XCTAssertFalse(sut.refreshControl.isRefreshing)
        XCTAssertEqual(sut.numberOfPokemons, 0)
        XCTAssertEqual(service.getPokemonsCalls, 1)
    }

    func testPresentPokemonOnSuccess() {
        let (sut, service, _, _) = makeSUT()

        sut.simulateAppearance()
        service.complete(with: .success([
            Pokemon.fixture(),
            Pokemon.fixture(),
        ]))

        XCTAssertFalse(sut.collectionView.isHidden)
        XCTAssertTrue(sut.loadingView.isHidden)
        XCTAssertEqual(service.getPokemonsCalls, 1)
        XCTAssertEqual(sut.numberOfPokemons, 2)
    }

    func testSetCellContentAndFetchImages() throws {
        let (sut, service, imageFetcher, _) = makeSUT()
        let pokemon1 = Pokemon.fixture()
        let pokemon2 = Pokemon.fixture(backgroundColor: .brown)
        let expectedImage1 = UIImage(resource: .pikachu)
        let expectedImage2 = UIImage(resource: .bulbasaur)

        imageFetcher.expectedImages[pokemon1.imageUrl] = expectedImage1
        imageFetcher.expectedImages[pokemon2.imageUrl] = expectedImage2

        sut.simulateAppearance()
        service.complete(with: .success([
            pokemon1,
            pokemon2,
        ]))

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

    func testRefreshStartsAndEnds() {
        let (sut, service, _, _) = makeSUT()

        sut.simulateAppearance()

        XCTAssertFalse(sut.isRefreshing, "Should not refresh on appear")

        service.complete(with: .failure(ErrorDummy()))

        XCTAssertFalse(sut.isRefreshing, "Refresh should keep hidden after the service responds")
        XCTAssertEqual(service.getPokemonsCalls, 1)

        sut.simulatePullToRefresh()
        
        XCTAssertTrue(sut.isRefreshing, "Should start refreshing after a pull-to-refresh")

        service.complete(with: .failure(ErrorDummy()))

        XCTAssertFalse(sut.isRefreshing, "Should end refreshing on service failures")
        XCTAssertEqual(service.getPokemonsCalls, 2)

        sut.simulatePullToRefresh()

        XCTAssertTrue(sut.isRefreshing, "Should start refreshing after a pull-to-refresh")

        service.complete(with: .success([Pokemon.fixture()]))

        XCTAssertFalse(sut.isRefreshing, "Should end refreshing on service success")
        XCTAssertEqual(service.getPokemonsCalls, 3)

        sut.simulatePullToRefresh()

        XCTAssertTrue(sut.isRefreshing, "Should start refreshing after a pull-to-refresh")

        service.complete(with: .success([]))

        XCTAssertFalse(sut.isRefreshing, "Should end refreshing when service succeed with no pokemon")
        XCTAssertEqual(service.getPokemonsCalls, 4)
    }

    func testSelectsPokemon() {
        let (sut, service, _, selection) = makeSUT()
        let pokemon1 = Pokemon.fixture()

        sut.simulateAppearance()

        service.complete(with: .success([
            .fixture(),
            pokemon1,
            .fixture(),
            .fixture(),
        ]))

        sut.selectPokemon(at: 1)

        XCTAssertEqual(selection.onSelectPokemonCalls, 1)
        XCTAssertEqual(selection.receivedId, pokemon1.id)
    }

    // MARK: Helpers

    private func makeSUT(
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (
        HomeViewController,
        HomeViewControllerServiceSpy,
        ImageFetcherSpy,
        PokemonSelectionSpy
    ) {
        let service = HomeViewControllerServiceSpy()
        let selection = PokemonSelectionSpy()
        let viewModel = HomeViewModel(
            service: service,
            scheduler: .immediate, 
            onSelectPokemon: selection.onSelectPokemon
        )
        let imageFecher = ImageFetcherSpy()
        let sut = HomeViewController(
            viewModel: viewModel,
            imageFetcher: imageFecher,
            refreshControl: FakeUIRefreshControl()
        )

        trackForMemoryLeaks(sut, viewModel, service, imageFecher, selection, file: file, line: line)

        return (sut, service, imageFecher, selection)
    }
}

final class PokemonSelectionSpy {
    private(set) var receivedId: PokemonId?
    private(set) var onSelectPokemonCalls = 0

    func onSelectPokemon(_ id: PokemonId) {
        onSelectPokemonCalls += 1
        receivedId = id
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

final class HomeViewControllerServiceSpy: HomeService {
    private(set) var getPokemonsCalls = 0

    private var promise: ((Result<[Pokemon], Error>) -> Void)?

    func getPokemons() -> AnyPublisher<[Pokemon], Error> {
        getPokemonsCalls += 1

        return Future { promise in
            self.promise = promise
        }
        .eraseToAnyPublisher()
    }

    func complete(with result: Result<[Pokemon], Error>) {
        promise?(result)
    }
}

extension HomeViewController {
    /// Simulates the ViewController life-cycle
    /// - Will run the viewDidLoad, viewWillAppear, viewIsAppearing, and viewDidAppear
    func simulateAppearance() {
        if !isViewLoaded {
            loadViewIfNeeded()
        }

        beginAppearanceTransition(true, animated: false)
        endAppearanceTransition()
    }

    func simulatePullToRefresh() {
        refreshControl.simulate(event: .valueChanged)
    }

    var isRefreshing: Bool {
        refreshControl.isRefreshing
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

    func selectPokemon(at index: Int) {
        collectionView(collectionView, didSelectItemAt: .init(item: index, section: 0))
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
