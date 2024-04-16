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

class PokemonDetailsViewController: UIViewController {
    @IBOutlet weak var specieLabel: UILabel!
    @IBOutlet weak var primaryAttributeLabel: UILabel!
    @IBOutlet weak var secondaryAttributeView: UIView!
    @IBOutlet weak var secondaryAttributeLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    @IBOutlet weak var headerBackgroundView: UIView!

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var aboutContainerView: UIView!
    @IBOutlet weak var evolutionContainerView: UIView!
    @IBOutlet weak var statsContainerView: UIView!

    @IBOutlet weak var scrollView: UIScrollView!

    let aboutView = AboutView.loadFromNib()
    let evolutionView = EvolutionView.loadFromNib()
    let statsView = StatsView.loadFromNib()

    private var subscription: AnyCancellable?

    private let viewModel: PokemonDetailsViewModel
    private let imageFetcher: ImageFetcher

    init(viewModel: PokemonDetailsViewModel, imageFetcher: ImageFetcher) {
        self.viewModel = viewModel
        self.imageFetcher = imageFetcher
        super.init(nibName: "PokemonDetailsViewController", bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        setupAboutView()
        setupEvolutionView()
        setupStatsView()
        setupSegments()

        subscription = viewModel.$state
            .sink { [weak self] state in
                self?.update(with: state)
            }
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.setTitleColor(.white)
        navigationController?.navigationBar.tintColor = .white
        viewModel.onAppear()
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
            showErrorAlert()
        }
    }

    private func showErrorAlert() {
        let alert = UIAlertController(
            title: "Error",
            message: "Something went wrong. Please try again.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        alert.addAction(UIAlertAction(title: "Try again", style: .default, handler: { [weak self] _ in
            self?.viewModel.tryAgain()
        }))
        present(alert, animated: true, completion: nil)
    }


    private func setLoading() {
        title = ""
        view.backgroundColor = .systemBackground
        headerBackgroundView.backgroundColor = .systemBackground
        scrollView.isHidden = true
        loadingView.isHidden = false
    }

    private func setContent(pokemon: PokemonDetails) {
        title = pokemon.name
        view.backgroundColor = pokemon.backgroundColor

        scrollView.isHidden = false
        loadingView.isHidden = true

        primaryAttributeLabel.text = pokemon.primaryAttribute
        specieLabel.text = "\(pokemon.specie) Pokémon"
        headerBackgroundView.backgroundColor = pokemon.backgroundColor
        aboutView.setContent(with: pokemon)
        statsView.setContent(with: pokemon)
        evolutionView.setContent(with: pokemon, imageFetcher: imageFetcher)

        imageFetcher.fetch(from: pokemon.imageUrl) { [weak self] image in
            self?.imageView.image = image
        }

        if let secondaryAttribute = pokemon.secondaryAttribute {
            secondaryAttributeLabel.text = secondaryAttribute
            secondaryAttributeView.isHidden = false
        } else {
            secondaryAttributeView.isHidden = true
        }
    }

    @IBAction
    private func didSelectSegment(_ sender: UISegmentedControl) {
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
