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
        XCTAssertEqual(sut.view.backgroundColor, .systemBackground)
        XCTAssertEqual(sut.headerBackgroundView.backgroundColor, .systemBackground)
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
