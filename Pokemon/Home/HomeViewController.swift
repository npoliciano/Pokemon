//
//  HomeView.swift
//  Pokemon
//
//  Created by Nicolle on 13/03/24.
//

import Combine
import FirebaseDatabase
import UIKit

final class HomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    // Subviews

    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSizeMake(1, 1)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()

    let loadingView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.startAnimating()
        return view
    }()

    // Collection View Configuration

    private let itemsPerRow: CGFloat = 2
    private let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)

    private var subscription: AnyCancellable?
    private let viewModel: HomeViewModel
    private let imageFetcher: ImageFetcher
    let refreshControl: UIRefreshControl

    init(
        viewModel: HomeViewModel,
        imageFetcher: ImageFetcher,
        refreshControl: UIRefreshControl = UIRefreshControl()
    ) {
        self.viewModel = viewModel
        self.imageFetcher = imageFetcher
        self.refreshControl = refreshControl
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var items: [Pokemon] = [] {
        didSet {
            collectionView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupColletionViewConstraints()
        setupLoadingViewConstraints()
        setupRefreshControl()

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(PokemonCell.self, forCellWithReuseIdentifier: PokemonCell.identifier)
        collectionView.reloadData()

        collectionView.isHidden = true
        loadingView.isHidden = false

        subscription = viewModel
            .$state
            .dropFirst()
            .sink { [weak self] state in
                self?.refreshControl.endRefreshing()
                switch state {
                case .error:
                    self?.showErrorAlert()
                case .content(let pokemons):
                    self?.items = pokemons
                    self?.collectionView.isHidden = false
                    self?.loadingView.isHidden = true
                }
            }
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.setTitleColor(.label)
        viewModel.onAppear()
    }

    private func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        collectionView.refreshControl = refreshControl
    }

    @objc private func refreshData() {
        refreshControl.beginRefreshing()
        viewModel.onRefresh()
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

    private func setupLoadingViewConstraints() {
        view.addSubview(loadingView)
        loadingView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func setupColletionViewConstraints() {
        view.addSubview(collectionView)
        collectionView.constrainToEdges(superview: view)
    }

    // MARK: - UICollectionViewDataSource protocol

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PokemonCell.identifier, for: indexPath) as! PokemonCell

        let pokemon = items[indexPath.row]
        cell.setContent(with: pokemon, imageFetcher: imageFetcher)
        return cell
    }

    // MARK: - UICollectionViewDelegate protocol

    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        let pokemon = items[indexPath.item]

        viewModel.onSelectPokemon(pokemon)
    }

    // MARK: - UICollectionViewDelegateFlowLayout

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow

        return CGSize(width: widthPerItem, height: widthPerItem * 0.8)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}
