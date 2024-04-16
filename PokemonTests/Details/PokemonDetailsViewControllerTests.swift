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
        let (_, service, _) = makeSUT()

        XCTAssertEqual(service.getPokemonDetailsCalls, 0)
    }

    func testStartsLoadingOnAppear() {
        let (sut, service, _) = makeSUT()

        sut.simulateAppearance()

        XCTAssertEqual(service.getPokemonDetailsCalls, 1)
        XCTAssertEqual(sut.title, "")
        XCTAssertEqual(sut.pokemonColor, .systemBackground)
        XCTAssertTrue(sut.scrollView.isHidden)
        XCTAssertFalse(sut.loadingView.isHidden)
        XCTAssertFalse(sut.isShowingErrorAlert)
    }

    func testPresentErrorAlertOnFailure() {
        let (sut, service, _) = makeSUT()

        sut.simulateAppearance()
        service.complete(with: .failure(ErrorDummy()))

        XCTAssertEqual(service.getPokemonDetailsCalls, 1)
        XCTAssertTrue(sut.isShowingErrorAlert)
    }
    
    func testPresentPokemonDetailsOnSuccess() {
        let (sut, service, imageFetcher) = makeSUT()
        let pokemon = PokemonDetails.fixture(
            secondaryAttribute: .anyValue,
            backgroundColor: UIColor.orange
        )
        let expectedImage = UIImage(resource: .pikachu)
        imageFetcher.expectedImages[pokemon.imageUrl] = expectedImage

        sut.simulateAppearance()
        service.complete(with: .success(pokemon))

        XCTAssertEqual(service.getPokemonDetailsCalls, 1)
        XCTAssertEqual(imageFetcher.fetchCalls, 5)
        XCTAssertEqual(sut.title, pokemon.name)
        XCTAssertEqual(sut.pokemonColor, pokemon.backgroundColor)
        XCTAssertEqual(sut.specie, "\(pokemon.specie) Pokémon")
        XCTAssertEqual(sut.primaryAttributeLabel.text, pokemon.primaryAttribute)
        XCTAssertEqual(sut.secondaryAttributeLabel.text, pokemon.secondaryAttribute)
        XCTAssertEqual(sut.imageView.image, expectedImage)
        XCTAssertFalse(sut.scrollView.isHidden)
        XCTAssertTrue(sut.loadingView.isHidden)
        XCTAssertFalse(sut.isShowingErrorAlert)

        XCTAssertEqual(sut.numberOfSegments, 3)
        XCTAssertEqual(sut.titleForSegment(at: 0), "About")
        XCTAssertEqual(sut.titleForSegment(at: 1), "Evolution")
        XCTAssertEqual(sut.titleForSegment(at: 2), "Stats")
    }

    func testHideSecondaryAttributeIfAbsent() {
        let (sut, service, _) = makeSUT()

        sut.simulateAppearance()
        service.complete(with: .success(.fixture(
            secondaryAttribute: nil
        )))

        XCTAssertTrue(sut.secondaryAttributeView.isHidden)
    }

    func testPresentAboutSectionOnSuccess() {
        let (sut, service, _) = makeSUT()

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
        let (sut, service, _) = makeSUT()

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
        let (sut, service, _) = makeSUT()
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
        let (sut, service, _) = makeSUT()
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

    func testPresentEvolutionSectionProperly() {
        let (sut, service, imageFetcher) = makeSUT()
        let pokemon = PokemonDetails.fixture()
        let expectedImage1 = UIImage(resource: .pikachu)
        let expectedImage2 = UIImage(resource: .bulbasaur)
        let expectedImage3 = UIImage(systemName: "info")!
        let expectedImage4 = UIImage(systemName: "info.circle")!

        imageFetcher.expectedImages[pokemon.firstEvolutionChain.from.imageUrl] = expectedImage1
        imageFetcher.expectedImages[pokemon.firstEvolutionChain.to.imageUrl] = expectedImage2
        imageFetcher.expectedImages[pokemon.secondEvolutionChain.from.imageUrl] = expectedImage3
        imageFetcher.expectedImages[pokemon.secondEvolutionChain.to.imageUrl] = expectedImage4

        sut.simulateAppearance()
        service.complete(with: .success(pokemon))

        XCTAssertEqual(sut.evolutionView.firstEvolutionChainView.evolvesFromLabel.text, pokemon.firstEvolutionChain.from.name)
        XCTAssertEqual(sut.evolutionView.firstEvolutionChainView.evolvesToLabel.text, pokemon.firstEvolutionChain.to.name)
        XCTAssertEqual(sut.evolutionView.firstEvolutionChainView.evolvesFromImageView.image, expectedImage1)
        XCTAssertEqual(sut.evolutionView.firstEvolutionChainView.evolvesToImageView.image, expectedImage2)

        XCTAssertEqual(sut.evolutionView.secondEvolutionChainView.evolvesFromLabel.text, pokemon.secondEvolutionChain.from.name)
        XCTAssertEqual(sut.evolutionView.secondEvolutionChainView.evolvesToLabel.text, pokemon.secondEvolutionChain.to.name)
        XCTAssertEqual(sut.evolutionView.secondEvolutionChainView.evolvesFromImageView.image, expectedImage3)
        XCTAssertEqual(sut.evolutionView.secondEvolutionChainView.evolvesToImageView.image, expectedImage4)
    }

    private func makeSUT(
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (
        TestablePokemonDetailsViewController,
        PokemonDetailsServiceSpy,
        ImageFetcherSpy
    ) {
        let service = PokemonDetailsServiceSpy()
        let viewModel = PokemonDetailsViewModel(service: service, scheduler: .immediate)
        let imageFecher = ImageFetcherSpy()
        let sut = TestablePokemonDetailsViewController(viewModel: viewModel, imageFetcher: imageFecher)

        trackForMemoryLeaks(sut, viewModel, service, imageFecher, file: file, line: line)

        return (sut, service, imageFecher)
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
