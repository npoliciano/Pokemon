//
//  PokemonCell.swift
//  Pokemon
//
//  Created by Nicolle on 13/03/24.
//

import UIKit
import Kingfisher

final class PokemonCell: UICollectionViewCell {
    static let identifier = "PokemonCell"

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .heavy)
        label.textColor = .white
        return label
    }()

    private let primaryAttributeView = AttributeView()
    private let secondaryAttributeView = AttributeView()

    private let imageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        let attributesStack = UIStackView(arrangedSubviews: [
            primaryAttributeView,
            secondaryAttributeView
        ])
        attributesStack.axis = .vertical
        attributesStack.spacing = 4
        attributesStack.alignment = .leading

        let stack = UIStackView(arrangedSubviews: [
            nameLabel,
            attributesStack
        ])
        stack.axis = .vertical
        stack.spacing = 8

        contentView.addSubview(stack)
        contentView.addSubview(imageView)

        stack.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            primaryAttributeView.heightAnchor.constraint(equalToConstant: 18),
            secondaryAttributeView.heightAnchor.constraint(equalToConstant: 18),

            stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),

            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            imageView.widthAnchor.constraint(equalToConstant: 90),
            imageView.heightAnchor.constraint(equalToConstant: 90)
        ])

        contentView.layer.cornerRadius = 15
        contentView.layer.masksToBounds = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension PokemonCell {
    struct Pokemon {
        let name: String
        let imageUrl: URL
        let primaryAttribute: String
        let secondaryAttribute: String?
        let backgroundColor: UIColor
    }

    func setContent(with pokemon: Pokemon) {
        nameLabel.text = pokemon.name
        imageView.kf.setImage(with: pokemon.imageUrl)
        contentView.backgroundColor = pokemon.backgroundColor
        primaryAttributeView.setContent(value: pokemon.primaryAttribute)
        secondaryAttributeView.setContent(value: pokemon.secondaryAttribute)
    }
}
