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
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    @IBOutlet weak var contentView: UIView!
    
    private var subscription: AnyCancellable?

    override func viewDidLoad() {
        viewModel.onAppear()

        subscription = viewModel.$state
            .sink { [weak self] state in
                self?.update(with: state)
            }
    }

    private func update(with state: ViewState<Pokemon>) {
        switch state {
        case .loading:
            setLoading()

        case .content(let pokemon):
            setContent(pokemon: pokemon)
        }
    }

    private func setLoading() {
        title = ""
        view.backgroundColor = .systemBackground
        contentView.isHidden = true
        loadingView.isHidden = false
    }

    private func setContent(pokemon: Pokemon) {
        contentView.isHidden = false
        loadingView.isHidden = true

        primaryAttributeLabel.alpha = 0
        specieLabel.alpha = 0
        imageView.alpha = 0
        secondaryAttributeView.alpha = 0

        primaryAttributeLabel.text = pokemon.primaryAttribute
        specieLabel.text = "\(pokemon.specie) Pokemon"
        imageView.image = pokemon.image

        if let secondaryAttribute = pokemon.secondaryAttribute {
            secondaryAttributeLabel.text = secondaryAttribute
            secondaryAttributeView.isHidden = false
        } else {
            secondaryAttributeView.isHidden = true
        }

        UIView.animate(withDuration: 0.5) {
            self.primaryAttributeLabel.alpha = 1
            self.specieLabel.alpha = 1
            self.imageView.alpha = 1
            self.secondaryAttributeView.alpha = 1
            self.title = pokemon.name
            self.view.backgroundColor = pokemon.predominantColor
        }
    }
}
