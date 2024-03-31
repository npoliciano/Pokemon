//
//  PokemonDetailsViewModelTests.swift
//  PokemonTests
//
//  Created by Nicolle on 30/03/24.
//

import Combine
import XCTest
@testable import Pokemon

final class PokemonDetailsViewModelTests: XCTestCase {
    func testInitDoesNotPerformAnyRequest() {
        let service = PokemonDetailsServiceSpy()
        let sut = PokemonDetailsViewModel(service: service)

        XCTAssertEqual(service.getPokemonDetailsCalls, 0)
    }

    func testInitialStateIsLoading() {
        let service = PokemonDetailsServiceSpy()
        let sut = PokemonDetailsViewModel(service: service)

        XCTAssertEqual(sut.state, .loading)
    }

    func testGetsPokemonDetailsOnAppear() {
        let service = PokemonDetailsServiceSpy()
        let sut = PokemonDetailsViewModel(service: service)

        sut.onAppear()

        XCTAssertEqual(service.getPokemonDetailsCalls, 1)
    }

}

final class PokemonDetailsServiceSpy: PokemonDetailsService {
    private(set) var getPokemonDetailsCalls = 0

    func getPokemonDetails() -> AnyPublisher<PokemonDetails, Error> {
        getPokemonDetailsCalls += 1
        return Result.failure(ErrorDummy())
            .publisher
            .eraseToAnyPublisher()
    }

}

extension ViewState<PokemonDetails>: Equatable {
    public static func ==(lhs: ViewState<PokemonDetails>, rhs: ViewState<PokemonDetails>) -> Bool {
        switch (lhs, rhs) {
        case (.error, .error):
            return true
        case (.content(let lhsPokemon), .content(let rhsPokemon)):
            return lhsPokemon == rhsPokemon
        case (.loading, .loading):
            return true
        default:
            return false
        }
    }
}

extension PokemonDetails: Equatable {
    public static func ==(lhs: PokemonDetails, rhs: PokemonDetails) -> Bool {
        lhs.name == rhs.name &&
        lhs.primaryAttribute == rhs.primaryAttribute &&
        lhs.secondaryAttribute == rhs.secondaryAttribute &&
        lhs.specie == rhs.specie &&
        lhs.imageUrl == rhs.imageUrl &&
        lhs.backgroundColor == rhs.backgroundColor &&
        lhs.description == rhs.description &&
        lhs.eggCycle == rhs.eggCycle &&
        lhs.eggGroups == rhs.eggGroups &&
        lhs.female == rhs.female &&
        lhs.male == rhs.male &&
        lhs.height == rhs.height &&
        lhs.weight == rhs.weight &&
        lhs.hp == rhs.hp &&
        lhs.attack == rhs.attack &&
        lhs.defense == rhs.defense &&
        lhs.speed == rhs.speed &&
        lhs.statsTotal == rhs.statsTotal &&
        lhs.firstEvolutionChain == rhs.firstEvolutionChain &&
        lhs.secondEvolutionChain == rhs.secondEvolutionChain
    }
}

extension EvolutionChain: Equatable {
    public static func == (lhs: EvolutionChain, rhs: EvolutionChain) -> Bool {
        lhs.from == rhs.from &&
        lhs.to == rhs.to
    }
}

extension EvolutionChain.Pokemon: Equatable {
    public static func == (lhs: EvolutionChain.Pokemon, rhs: EvolutionChain.Pokemon) -> Bool {
        lhs.name == rhs.name &&
        lhs.imageUrl == rhs.imageUrl
    }
}
