//
//  PokemonCell.swift
//  Pokemon
//
//  Created by Nicolle on 13/03/24.
//

import UIKit

final class PokemonCell: UICollectionViewCell {
    static let identifier = "PokemonCell"
    
    let nameLabel = UILabel()
    let imageView = UIImageView()

    struct Pokemon {
        var name: String
        var imageUrl: String
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        let stack = UIStackView(arrangedSubviews: [nameLabel, imageView])
        self.contentView.addSubview(stack)

        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: contentView.topAnchor),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 90),
            imageView.heightAnchor.constraint(equalToConstant: 90)
        ])

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
