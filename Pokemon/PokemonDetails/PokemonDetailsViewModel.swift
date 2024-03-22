import Combine
import UIKit

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

final class PokemonDetailsViewModel: ObservableObject {
    private let api: PokemonDetailsAPI

    @Published var state: ViewState<PokemonDetails> = .loading

    private var subscription: AnyCancellable?

    init(api: PokemonDetailsAPI) {
        self.api = api
    }

    func onAppear() {
        subscription = api.getPokemonDetails()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure = completion {
                    self?.state = .error
                }
            } receiveValue: { [weak self] pokemon in
                self?.state = .content(pokemon)
            }
    }
}

