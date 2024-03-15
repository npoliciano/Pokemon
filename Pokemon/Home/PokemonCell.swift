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

    private let primaryAttributeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10, weight: .medium)
        label.textColor = .white
        return label
    }()

    private let secondaryAttributeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10, weight: .medium)
        label.textColor = .white
        return label
    }()

    private let imageView = UIImageView()

    private let secondaryAttributeContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white.withAlphaComponent(0.2)
        return view
    }()

    private let primaryAttibuteContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white.withAlphaComponent(0.2)
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        let attributesStack = UIStackView(arrangedSubviews: [
            primaryAttibuteContainerView,
            secondaryAttributeContainerView
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
        primaryAttibuteContainerView.addSubview(primaryAttributeLabel)
        secondaryAttributeContainerView.addSubview(secondaryAttributeLabel)

        primaryAttributeLabel.translatesAutoresizingMaskIntoConstraints = false
        secondaryAttributeLabel.translatesAutoresizingMaskIntoConstraints = false
        stack.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            primaryAttributeLabel.topAnchor.constraint(equalTo: primaryAttibuteContainerView.topAnchor, constant: 4),
            primaryAttributeLabel.leadingAnchor.constraint(equalTo: primaryAttibuteContainerView.leadingAnchor, constant: 8),
            primaryAttributeLabel.trailingAnchor.constraint(equalTo: primaryAttibuteContainerView.trailingAnchor, constant: -8),
            primaryAttributeLabel.bottomAnchor.constraint(equalTo: primaryAttibuteContainerView.bottomAnchor, constant: -4),
            primaryAttibuteContainerView.heightAnchor.constraint(equalToConstant: 18),

            secondaryAttributeLabel.topAnchor.constraint(equalTo: secondaryAttributeContainerView.topAnchor, constant: 4),
            secondaryAttributeLabel.trailingAnchor.constraint(equalTo: secondaryAttributeContainerView.trailingAnchor, constant: -8),
            secondaryAttributeLabel.leadingAnchor.constraint(equalTo: secondaryAttributeContainerView.leadingAnchor, constant: 8),
            secondaryAttributeLabel.bottomAnchor.constraint(equalTo: secondaryAttributeContainerView.bottomAnchor, constant: -4),
            secondaryAttributeContainerView.heightAnchor.constraint(equalToConstant: 18),

            stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),

            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            imageView.widthAnchor.constraint(equalToConstant: 90),
            imageView.heightAnchor.constraint(equalToConstant: 90)
        ])

        primaryAttibuteContainerView.layer.cornerRadius = 9
        primaryAttibuteContainerView.layer.masksToBounds = true

        secondaryAttributeContainerView.layer.cornerRadius = 9
        secondaryAttributeContainerView.layer.masksToBounds = true

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
        primaryAttributeLabel.text = pokemon.primaryAttribute
        secondaryAttributeLabel.text = pokemon.secondaryAttribute

        if let secondaryAttribute = pokemon.secondaryAttribute {
            secondaryAttributeLabel.text = secondaryAttribute
            secondaryAttributeContainerView.isHidden = false
        } else {
            secondaryAttributeContainerView.isHidden = true
        }
    }
}
