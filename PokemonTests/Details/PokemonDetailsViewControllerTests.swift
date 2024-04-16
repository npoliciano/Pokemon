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

        XCTAssertEqual(sut.numberOfSegments, 3)
        XCTAssertEqual(sut.titleForSegment(at: 0), "About")
        XCTAssertEqual(sut.titleForSegment(at: 1), "Evolution")
        XCTAssertEqual(sut.titleForSegment(at: 2), "Stats")
    }

    func testPresentAboutSectionOnSuccess() {
        let (sut, service) = makeSUT()

        sut.simulateAppearance()
        service.complete(with: .success(
            PokemonDetails.fixture()
        ))

        XCTAssertEqual(sut.selectedSegmentIndex, 0)
        XCTAssertFalse(sut.aboutContainerView.isHidden)
        XCTAssertTrue(sut.evolutionContainerView.isHidden)
        XCTAssertTrue(sut.statsContainerView.isHidden)
    }

    func testCanSelectSegment() {
        let (sut, service) = makeSUT()

        sut.simulateAppearance()
        service.complete(with: .success(
            PokemonDetails.fixture()
        ))

        XCTAssertEqual(sut.selectedSegmentIndex, 0)
        XCTAssertFalse(sut.aboutContainerView.isHidden)
        XCTAssertTrue(sut.evolutionContainerView.isHidden)
        XCTAssertTrue(sut.statsContainerView.isHidden)

        sut.simulateSelectedSegment(at: 1)

        XCTAssertTrue(sut.aboutContainerView.isHidden)
        XCTAssertFalse(sut.evolutionContainerView.isHidden)
        XCTAssertTrue(sut.statsContainerView.isHidden)

        sut.simulateSelectedSegment(at: 2)

        XCTAssertTrue(sut.aboutContainerView.isHidden)
        XCTAssertTrue(sut.evolutionContainerView.isHidden)
        XCTAssertFalse(sut.statsContainerView.isHidden)

        sut.simulateSelectedSegment(at: 0)

        XCTAssertFalse(sut.aboutContainerView.isHidden)
        XCTAssertTrue(sut.evolutionContainerView.isHidden)
        XCTAssertTrue(sut.statsContainerView.isHidden)
    }

    func testPresentAboutSectionProperly() {
        let (sut, service) = makeSUT()
        let pokemon = PokemonDetails.fixture()

        sut.simulateAppearance()
        service.complete(with: .success(pokemon))

        XCTAssertEqual(sut.pokemonDescription, pokemon.description)
        XCTAssertEqual(sut.eggCycle, pokemon.eggCycle)
        XCTAssertEqual(sut.eggGroups, pokemon.eggGroups)
        XCTAssertEqual(sut.female, pokemon.female)
        XCTAssertEqual(sut.male, pokemon.male)
        XCTAssertEqual(sut.weight, pokemon.weight)
        XCTAssertEqual(sut.height, pokemon.height)
    }

    func testPresentStatsSectionProperly() {
        let (sut, service) = makeSUT()
        let pokemon = PokemonDetails.fixture(
            hp: 90,
            attack: 85,
            defense: 70,
            speed: 68,
            statsTotal: 200
        )

        sut.simulateAppearance()
        service.complete(with: .success(pokemon))

        XCTAssertEqual(sut.hp, "90")
        XCTAssertEqual(sut.attack, "85")
        XCTAssertEqual(sut.defense, "70")
        XCTAssertEqual(sut.speed, "68")
        XCTAssertEqual(sut.total, "200")

        XCTAssertEqual(sut.hpProgress, 0.9)
        XCTAssertEqual(sut.attackProgress, 0.85)
        XCTAssertEqual(sut.defenseProgress, 0.7)
        XCTAssertEqual(sut.speedProgress, 0.68)
        XCTAssertEqual(sut.totalProgress, 0.5)
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

    var selectedSegmentIndex: Int {
        segmentedControl.selectedSegmentIndex
    }

    var numberOfSegments: Int {
        segmentedControl.numberOfSegments
    }

    func titleForSegment(at index: Int) -> String? {
        segmentedControl.titleForSegment(at: index)
    }

    func simulateSelectedSegment(at index: Int) {
        segmentedControl.selectedSegmentIndex = index
        segmentedControl.sendActions(for: .valueChanged)
    }

    var pokemonDescription: String? {
        aboutView.descriptionLabel.text
    }
    var eggCycle: String? {
        aboutView.eggCycleLabel.text
    }
    var eggGroups: String? {
        aboutView.eggGroupsLabel.text
    }
    var female: String? {
        aboutView.femaleLabel.text
    }
    var male: String? {
        aboutView.maleLabel.text
    }
    var weight: String? {
        aboutView.weightLabel.text
    }
    var height: String? {
        aboutView.heightLabel.text
    }

    var hp: String? {
        statsView.hpLabel.text
    }
    var attack: String? {
        statsView.attackLabel.text
    }
    var defense: String? {
        statsView.defenseLabel.text
    }
    var speed: String? {
        statsView.speedLabel.text
    }
    var total: String? {
        statsView.totalLabel.text
    }

    var hpProgress: Float {
        statsView.hpProgressView.progress
    }
    var attackProgress: Float {
        statsView.attackProgressView.progress
    }
    var defenseProgress: Float {
        statsView.defenseProgressView.progress
    }
    var speedProgress: Float {
        statsView.speedProgressView.progress
    }
    var totalProgress: Float {
        statsView.totalProgressView.progress
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
