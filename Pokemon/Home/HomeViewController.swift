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
            name: "Pikachu",
            imageUrl: String("https://firebasestorage.googleapis.com/v0/b/pokedex-bb36f.appspot.com/o/pokemon_images%2FAE45F260-9012-45F5-BE75-5C8972014EAA?alt=media&token=55b2ea2f-d525-47c0-95ae-7ddf01e879d3")
        ),
        .init(
            name: "Pikachu",
            imageUrl: String("https://firebasestorage.googleapis.com/v0/b/pokedex-bb36f.appspot.com/o/pokemon_images%2FAE45F260-9012-45F5-BE75-5C8972014EAA?alt=media&token=55b2ea2f-d525-47c0-95ae-7ddf01e879d3")
        ),
        .init(
            name: "Pikachu",
            imageUrl: String("https://firebasestorage.googleapis.com/v0/b/pokedex-bb36f.appspot.com/o/pokemon_images%2FAE45F260-9012-45F5-BE75-5C8972014EAA?alt=media&token=55b2ea2f-d525-47c0-95ae-7ddf01e879d3")
        ),
        .init(
            name: "Pikachu",
            imageUrl: String("https://firebasestorage.googleapis.com/v0/b/pokedex-bb36f.appspot.com/o/pokemon_images%2FAE45F260-9012-45F5-BE75-5C8972014EAA?alt=media&token=55b2ea2f-d525-47c0-95ae-7ddf01e879d3")
        ),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupColletionViewConstraints()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(PokemonCell.self, forCellWithReuseIdentifier: PokemonCell.identifier)
        collectionView.reloadData()
    }

    private func setupColletionViewConstraints() {
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }

    // MARK: - UICollectionViewDataSource protocol

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PokemonCell.identifier, for: indexPath) as! PokemonCell

        let pokemon = items[indexPath.row]
        cell.nameLabel.text = pokemon.name
        cell.imageView.image = UIImage(named: pokemon.imageUrl)

        cell.backgroundColor = UIColor.cyan
        return cell
    }

    // MARK: - UICollectionViewDelegate protocol

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Você selecionou o Pokémon #\(indexPath.item)!")
    }

    // MARK: - UICollectionViewDelegateFlowLayout

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow

        return CGSize(width: widthPerItem, height: widthPerItem)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}
