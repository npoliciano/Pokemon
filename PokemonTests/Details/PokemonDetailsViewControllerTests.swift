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
        let service = PokemonDetailsServiceSpy()
        let viewModel = PokemonDetailsViewModel(service: service, scheduler: .immediate)
        let sut = PokemonDetailsViewController(viewModel: viewModel)

        XCTAssertEqual(service.getPokemonDetailsCalls, 0)
    }

    func testStartsLoadingOnAppear() {
        let service = PokemonDetailsServiceSpy()
        let viewModel = PokemonDetailsViewModel(service: service, scheduler: .immediate)
        let sut = PokemonDetailsViewController(viewModel: viewModel)
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = sut
        window.makeKeyAndVisible()

        sut.simulateAppearance()

        XCTAssertEqual(service.getPokemonDetailsCalls, 1)
        XCTAssertEqual(sut.title, "")
        XCTAssertEqual(sut.view.backgroundColor, .systemBackground)
        XCTAssertEqual(sut.headerBackgroundView.backgroundColor, .systemBackground)
        XCTAssertTrue(sut.scrollView.isHidden)
        XCTAssertFalse(sut.loadingView.isHidden)
        XCTAssertFalse(sut.isShowingErrorAlert)
    }

}

extension PokemonDetailsViewController {
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
        presentedViewController is UIAlertController
    }
}

final class PokemonDetailsServiceSpy: PokemonDetailsService {
    private(set) var getPokemonDetailsCalls = 0

    var expectedResult = Result<PokemonDetails, Error>.failure(ErrorDummy())

    func getPokemonDetails() -> AnyPublisher<PokemonDetails, Error> {
        getPokemonDetailsCalls += 1
        return expectedResult
            .publisher
            .eraseToAnyPublisher()
    }
}
