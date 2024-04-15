//
//  PokemonDetailsViewControllerTests.swift
//  PokemonTests
//
//  Created by Nicolle on 13/04/24.
//

import Combine
import XCTest
@testable import Pokemon

final class PokemonDetailsViewControllerTests: XCTestCase {
    func testInitDoesNotPerformAnyRequests() {
        let (_, service) = makeSUT()

        XCTAssertEqual(service.getPokemonDetailsCalls, 0)
    }

    func testStartsLoadingOnAppear() {
        let (sut, service) = makeSUT()

        sut.simulateAppearance()

        XCTAssertEqual(service.getPokemonDetailsCalls, 1)
        XCTAssertEqual(sut.title, "")
        XCTAssertEqual(sut.pokemonColor, .systemBackground)
        XCTAssertTrue(sut.scrollView.isHidden)
        XCTAssertFalse(sut.loadingView.isHidden)
        XCTAssertFalse(sut.isShowingErrorAlert)
    }

    func testPresentErrorAlertOnFailure() {
        let (sut, service) = makeSUT()

        sut.simulateAppearance()
        service.complete(with: .failure(ErrorDummy()))

        XCTAssertEqual(service.getPokemonDetailsCalls, 1)
        XCTAssertTrue(sut.isShowingErrorAlert)
    }
    
    func testPresentPokemonDetailsOnSuccess() {
        let (sut, service) = makeSUT()

        let pokemon = PokemonDetails.fixture(
            secondaryAttribute: .anyValue,
            backgroundColor: UIColor.orange
        )

        sut.simulateAppearance()
        service.complete(with: .success(pokemon))

        XCTAssertEqual(service.getPokemonDetailsCalls, 1)
        XCTAssertEqual(sut.title, pokemon.name)
        XCTAssertEqual(sut.pokemonColor, pokemon.backgroundColor)
        XCTAssertEqual(sut.specie, "\(pokemon.specie) Pokémon")
        XCTAssertEqual(sut.primaryAttributeLabel.text, pokemon.primaryAttribute)
        XCTAssertEqual(sut.secondaryAttributeLabel.text, pokemon.secondaryAttribute)
        XCTAssertFalse(sut.scrollView.isHidden)
        XCTAssertTrue(sut.loadingView.isHidden)
        XCTAssertFalse(sut.isShowingErrorAlert)
    }

    private func makeSUT(
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (
        TestablePokemonDetailsViewController,
        PokemonDetailsServiceSpy
    ) {
        let service = PokemonDetailsServiceSpy()
        let viewModel = PokemonDetailsViewModel(service: service, scheduler: .immediate)
        let sut = TestablePokemonDetailsViewController(viewModel: viewModel)

        trackForMemoryLeaks(sut, viewModel, service, file: file, line: line)

        return (sut, service)
    }
}


final class TestablePokemonDetailsViewController: PokemonDetailsViewController {
    private(set) var viewControllerToPresent: UIViewController?

    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        self.viewControllerToPresent = viewControllerToPresent
    }

    /// Simulates the ViewController life-cycle
    /// - Will run the viewDidLoad, viewWillAppear, viewIsAppearing, and viewDidAppear
    func simulateAppearance() {
        if !isViewLoaded {
            loadViewIfNeeded()
        }

        beginAppearanceTransition(true, animated: false)
        endAppearanceTransition()
    }

    var isShowingErrorAlert: Bool {
        viewControllerToPresent is UIAlertController
    }

    var specie: String? {
        specieLabel.text
    }

    var pokemonColor: UIColor? {
        if view.backgroundColor != headerBackgroundView.backgroundColor {
            return nil
        }

        return view.backgroundColor
    }
}

final class PokemonDetailsServiceSpy: PokemonDetailsService {
    private(set) var getPokemonDetailsCalls = 0

    private var promise: ((Result<PokemonDetails, Error>) -> Void)?

    func getPokemonDetails() -> AnyPublisher<PokemonDetails, Error> {
        getPokemonDetailsCalls += 1
        return Future { promise in
            self.promise = promise
        }
        .eraseToAnyPublisher()
    }
    func complete(with result: Result<PokemonDetails, Error>) {
        promise?(result)
    }
}
