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

    private let aboutView = UINib(nibName: "AboutView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! AboutView
    private let evolutionView = UINib(nibName: "EvolutionView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! EvolutionView
    private let statsView = UINib(nibName: "StatsView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! StatsView

    private var subscription: AnyCancellable?

    override func viewDidLoad() {
        setupAboutView()
        setupEvolutionView()
        setupStatsView()
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

    private func setupAboutView() {
        aboutContainerView.addSubview(aboutView)
        aboutView.translatesAutoresizingMaskIntoConstraints = false

        aboutView.topAnchor.constraint(equalTo: aboutContainerView.topAnchor).isActive = true
        aboutView.bottomAnchor.constraint(equalTo: aboutContainerView.bottomAnchor).isActive = true
        aboutView.leadingAnchor.constraint(equalTo: aboutContainerView.leadingAnchor).isActive = true
        aboutView.trailingAnchor.constraint(equalTo: aboutContainerView.trailingAnchor).isActive = true
    }

    private func setupEvolutionView() {
        evolutionContainerView.addSubview(evolutionView)
        evolutionView.translatesAutoresizingMaskIntoConstraints = false

        evolutionView.topAnchor.constraint(equalTo: evolutionContainerView.topAnchor).isActive = true
        evolutionView.bottomAnchor.constraint(equalTo: evolutionContainerView.bottomAnchor).isActive = true
        evolutionView.leadingAnchor.constraint(equalTo: evolutionContainerView.leadingAnchor).isActive = true
        evolutionView.trailingAnchor.constraint(equalTo: evolutionContainerView.trailingAnchor).isActive = true
    }

    private func setupStatsView() {
        statsContainerView.addSubview(statsView)
        statsView.translatesAutoresizingMaskIntoConstraints = false

        statsView.topAnchor.constraint(equalTo: statsContainerView.topAnchor).isActive = true
        statsView.bottomAnchor.constraint(equalTo: statsContainerView.bottomAnchor).isActive = true
        statsView.leadingAnchor.constraint(equalTo: statsContainerView.leadingAnchor).isActive = true
        statsView.trailingAnchor.constraint(equalTo: statsContainerView.trailingAnchor).isActive = true
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
            self.aboutView.setContent(with: pokemon)
            self.statsView.setContent(with: pokemon)
            self.evolutionView.setContent(with: pokemon)
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
