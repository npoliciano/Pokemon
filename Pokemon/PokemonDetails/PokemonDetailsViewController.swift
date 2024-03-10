//
//  PokemonDetailsViewController.swift
//  Pokemon
//
//  Created by Nicolle on 05/03/24.
//

import Combine
import UIKit

enum SegmentSection: Int {
    case about
    case evolution
    case stats
}

final class PokemonDetailsViewController: UIViewController {
    let viewModel = PokemonDetailsViewModel()

    @IBOutlet weak var specieLabel: UILabel!
    @IBOutlet weak var primaryAttributeLabel: UILabel!
    @IBOutlet weak var secondaryAttributeView: UIView!
    @IBOutlet weak var secondaryAttributeLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    @IBOutlet weak var headerBackgroundView: UIView!

    @IBOutlet weak var aboutContainerView: UIView!
    @IBOutlet weak var evolutionContainerView: UIView!
    @IBOutlet weak var statsContainerView: UIView!

    @IBOutlet weak var scrollView: UIScrollView!

    private var subscription: AnyCancellable?

    override func viewDidLoad() {
        setupSegments()
        viewModel.onAppear()

        subscription = viewModel.$state
            .sink { [weak self] state in
                self?.update(with: state)
            }
    }

    private func setupSegments() {
        aboutContainerView.isHidden = false
        evolutionContainerView.isHidden = true
        statsContainerView.isHidden = true
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
        headerBackgroundView.backgroundColor = .systemBackground
        scrollView.isHidden = true
        loadingView.isHidden = false
    }

    private func setContent(pokemon: Pokemon) {
        scrollView.isHidden = false
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
            self.headerBackgroundView.backgroundColor = pokemon.predominantColor
        }
    }

    @IBAction func didSelectSegment(_ sender: UISegmentedControl) {
        guard let segment = SegmentSection(rawValue: sender.selectedSegmentIndex) else {
            return
        }

        switch segment {
        case .about:
            aboutContainerView.isHidden = false
            evolutionContainerView.isHidden = true
            statsContainerView.isHidden = true
        case .evolution:
            aboutContainerView.isHidden = true
            evolutionContainerView.isHidden = false
            statsContainerView.isHidden = true
        case .stats:
            aboutContainerView.isHidden = true
            evolutionContainerView.isHidden = true
            statsContainerView.isHidden = false
        }
    }
}
