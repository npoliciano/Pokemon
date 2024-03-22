//
//  PokemonDetailsViewController.swift
//  Pokemon
//
//  Created by Nicolle on 05/03/24.
//

import Combine
import Kingfisher
import UIKit

enum SegmentSection: Int {
    case about
    case evolution
    case stats
}

final class PokemonDetailsViewController: UIViewController {
    private let viewModel: PokemonDetailsViewModel

    init(viewModel: PokemonDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "PokemonDetailsViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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

    private let aboutView = AboutView.loadFromNib()
    private let evolutionView = EvolutionView.loadFromNib()
    private let statsView = StatsView.loadFromNib()

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

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.setTitleColor(.white)
    }

    private func setupSegments() {
        aboutContainerView.isHidden = false
        evolutionContainerView.isHidden = true
        statsContainerView.isHidden = true
    }

    private func setupAboutView() {
        aboutContainerView.addSubview(aboutView)
        aboutView.constrainToEdges(superview: aboutContainerView)
    }

    private func setupEvolutionView() {
        evolutionContainerView.addSubview(evolutionView)
        evolutionView.constrainToEdges(superview: evolutionContainerView)
    }

    private func setupStatsView() {
        statsContainerView.addSubview(statsView)
        statsView.constrainToEdges(superview: statsContainerView)
    }

    private func update(with state: ViewState<PokemonDetails>) {
        switch state {
        case .loading:
            setLoading()

        case .content(let pokemon):
            setContent(pokemon: pokemon)
        case .error:
            break
        }
    }

    private func setLoading() {
        title = ""
        view.backgroundColor = .systemBackground
        headerBackgroundView.backgroundColor = .systemBackground
        scrollView.isHidden = true
        loadingView.isHidden = false
    }

    private func setContent(pokemon: PokemonDetails) {
        scrollView.isHidden = false
        loadingView.isHidden = true

        primaryAttributeLabel.alpha = 0
        specieLabel.alpha = 0
        imageView.alpha = 0
        secondaryAttributeView.alpha = 0

        primaryAttributeLabel.text = pokemon.primaryAttribute
        specieLabel.text = "\(pokemon.specie) Pokémon"
        imageView.kf.setImage(with: pokemon.imageUrl)

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
            self.view.backgroundColor = pokemon.backgroundColor
            self.headerBackgroundView.backgroundColor = pokemon.backgroundColor
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
