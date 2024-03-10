import UIKit

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
}

final class PokemonDetailsViewModel {
    @Published var state: ViewState<Pokemon> = .loading

    func onAppear() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.state = .content(Pokemon(
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
                weight: "6.0 kg (13.2 lbs)"
            ))
        }
    }

}
