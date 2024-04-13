import Combine
import UIKit
import CombineSchedulers

struct EvolutionChain {
    struct Pokemon {
        let name: String
        let imageUrl: URL
    }

    let from: Pokemon
    let to: Pokemon
}

struct PokemonDetails {
    let name: String
    let primaryAttribute: String
    let secondaryAttribute: String?
    let specie: String
    let imageUrl: URL
    let backgroundColor: UIColor
    let description: String
    let eggCycle: String
    let eggGroups: String
    let female: String
    let male: String
    let height: String
    let weight: String
    let hp: Int
    let attack: Int
    let defense: Int
    let speed: Int
    let statsTotal: Int
    let firstEvolutionChain: EvolutionChain
    let secondEvolutionChain: EvolutionChain
}

protocol PokemonDetailsService {
    func getPokemonDetails() -> AnyPublisher<PokemonDetails, Error>
}

final class PokemonDetailsViewModel {
    private let service: PokemonDetailsService
    private let scheduler: AnySchedulerOf<DispatchQueue>

    @Published 
    private(set) var state: ViewState<PokemonDetails> = .loading

    private var subscription: AnyCancellable?

    init(service: PokemonDetailsService, scheduler: AnySchedulerOf<DispatchQueue>) {
        self.service = service
        self.scheduler = scheduler
    }

    private func getPokemonDetails() {
        subscription = service.getPokemonDetails()
            .receive(on: scheduler)
            .sink { [weak self] completion in
                if case .failure = completion {
                    self?.state = .error
                }
            } receiveValue: { [weak self] pokemon in
                self?.state = .content(pokemon)
            }
    }

    func onAppear() {
        getPokemonDetails()
    }

    func tryAgain() {
        getPokemonDetails()
    }
}

