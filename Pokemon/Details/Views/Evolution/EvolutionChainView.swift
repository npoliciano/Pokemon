//
//  EvolutionChainView.swift
//  Pokemon
//
//  Created by Nicolle on 12/03/24.
//

import UIKit
import Kingfisher

final class EvolutionChainView: UIView {
    @IBOutlet weak var evolvesFromImageView: UIImageView!
    @IBOutlet weak var evolvesToImageView: UIImageView!
    @IBOutlet weak var evolvesFromLabel: UILabel!
    @IBOutlet weak var evolvesToLabel: UILabel!

    func setContent(with chain: EvolutionChain, imageFetcher: ImageFetcher) {
        imageFetcher.fetch(from: chain.from.imageUrl) { [weak self] image in
            self?.evolvesFromImageView.image = image
        }

        imageFetcher.fetch(from: chain.to.imageUrl) { [weak self] image in
            self?.evolvesToImageView.image = image
        }

        evolvesFromLabel.text = chain.from.name
        evolvesToLabel.text = chain.to.name
    }
}
