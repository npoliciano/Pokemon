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

final class PokemonDetailsViewModel {
    @Published var state: ViewState<Pokemon> = .loading

    let selectedPokemonId: Int

    init(selectedPokemonId: Int) {
        self.selectedPokemonId = selectedPokemonId
    }

    func onAppear() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.state = .content(
                Pokemon(
                    name: "Pikachu",
                    primaryAttribute: "Electric",
                    secondaryAttribute: nil,
                    specie: "Mouse",
                    image: .pikachu,
                    predominantColor: UIColor(named: "Pikachu")!,
                    description: """
                Pikachu is an Electric type Pokémon introduced in Generation 1.
                
                Pikachu has a Gigantamax form available in Pokémon Sword/Shield, with an exclusive G-Max move, G-Max Volt Crash.
                """,
                    eggCycle: "10 (2,314–2,570 steps)",
                    eggGroups: "Fairy, Field",
                    female: "50%",
                    male: "50%",
                    height: "0.4 m (1′04″)",
                    weight: "6.0 kg (13.2 lbs)",
                    hp: 35,
                    attack: 55,
                    defense: 40,
                    speed: 90,
                    statsTotal: 220,
                    firstEvolutionChain: EvolutionChain(
                        from: EvolutionChain.Pokemon(
                            name: "Pichu",
                            image: .pikachu
                        ),
                        to: EvolutionChain.Pokemon(
                            name: "Pikachu",
                            image: .pikachu
                        )
                    ),
                    secondEvolutionChain: EvolutionChain(
                        from: EvolutionChain.Pokemon(
                            name: "Pikachu",
                            image: .pikachu
                        ),
                        to: EvolutionChain.Pokemon(
                            name: "Raichu",
                            image: .pikachu
                        )
                    )
                )
            )
        }
    }
}
