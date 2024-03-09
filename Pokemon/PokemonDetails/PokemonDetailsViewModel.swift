import UIKit

struct Pokemon {
    let name: String
    let primaryAttribute: String
    let secondaryAttribute: String?
    let specie: String
    let image: UIImage
    let predominantColor: UIColor
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
                predominantColor: UIColor(named: "Pikachu")!
            ))
        }
    }

}
