//
//  PokemonDetailsViewController.swift
//  Pokemon
//
//  Created by Nicolle on 05/03/24.
//

import Combine
import UIKit

final class PokemonDetailsViewController: UIViewController {
    let viewModel = PokemonDetailsViewModel()

    @IBOutlet weak var specieLabel: UILabel!
    @IBOutlet weak var primaryAttributeLabel: UILabel!
    @IBOutlet weak var secondaryAttributeView: UIView!
    @IBOutlet weak var secondaryAttributeLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!

    private var subscription: AnyCancellable?

    override func viewDidLoad() {
        viewModel.onAppear()

        subscription = viewModel.$pokemon.sink { [weak self] pokemon in
            guard let pokemon else { return }

            self?.update(with: pokemon)
        }
    }

    private func update(with pokemon: Pokemon) {
        title = pokemon.name
        view.backgroundColor = pokemon.predominantColor

        primaryAttributeLabel.text = pokemon.primaryAttribute
        specieLabel.text = "\(pokemon.specie) Pokemon"
        imageView.image = pokemon.image

        if let secondaryAttribute = pokemon.secondaryAttribute {
            secondaryAttributeLabel.text = secondaryAttribute
            secondaryAttributeView.isHidden = false
        } else {
            secondaryAttributeView.isHidden = true
        }
    }
}
