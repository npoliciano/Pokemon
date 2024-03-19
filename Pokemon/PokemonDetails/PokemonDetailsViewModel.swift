import UIKit

struct EvolutionChain {
    struct Pokemon {
        let name: String
        let image: UIImage
    }

    let from: Pokemon
    let to: Pokemon
}

struct Pokemon {
    let name: String
    let primaryAttribute: String
    let secondaryAttribute: String?
    let specie: String
    let image: UIImage
    let predominantColor: UIColor
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
    let selectedPokemonId: Int
    private let api = PokemonsAPI()

    @Published var state: ViewState<Pokemon> = .loading

    init(selectedPokemonId: Int) {
        self.selectedPokemonId = selectedPokemonId
    }

    func onAppear() {
        api.getPokemonDetails(id: selectedPokemonId) { [weak self] pokemon in
            guard let pokemon else {
                self?.state = .error
                return
            }

            self?.state = .content(pokemon)
        }
    }
}

