//
//  HomeView.swift
//  Pokemon
//
//  Created by Nicolle on 13/03/24.
//

import UIKit

final class HomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSizeMake(1, 1)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()

    private let itemsPerRow: CGFloat = 2
    private let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)

    var items: [PokemonCell.Pokemon] = [
        .init(
            id: 0,
            name: "Pikachu",
            imageUrl: URL(string: "https://firebasestorage.googleapis.com/v0/b/pokedex-bb36f.appspot.com/o/pokemon_images%2F62CDB87E-9A76-4184-B82A-4FB38CDA2BD0?alt=media&token=82726149-f9a6-4299-8837-6bae1ecb1081")!,
            primaryAttribute: "Grass",
            secondaryAttribute: "Poison",
            backgroundColor: .pikachu
        ),
        .init(
            id: 1,
            name: "Pikachu",
            imageUrl: URL(string: "https://firebasestorage.googleapis.com/v0/b/pokedex-bb36f.appspot.com/o/pokemon_images%2FAE45F260-9012-45F5-BE75-5C8972014EAA?alt=media&token=55b2ea2f-d525-47c0-95ae-7ddf01e879d3")!,
            primaryAttribute: "Electric",
            secondaryAttribute: nil,
            backgroundColor: .pikachu
        )
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupColletionViewConstraints()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(PokemonCell.self, forCellWithReuseIdentifier: PokemonCell.identifier)
        collectionView.reloadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.setTitleColor(.label)
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
        cell.setContent(with: pokemon)
        return cell
    }

    // MARK: - UICollectionViewDelegate protocol

    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        let item = items[indexPath.item]

        let viewModel = PokemonDetailsViewModel(selectedPokemonId: item.id)
        let viewController = PokemonDetailsViewController(viewModel: viewModel)

        navigationController?.pushViewController(viewController, animated: true)
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
