//
//  EvolutionChainView.swift
//  Pokemon
//
//  Created by Nicolle on 12/03/24.
//

import UIKit
import Kingfisher

final class EvolutionChainView: UIView {
    @IBOutlet weak var firstEvolutionImageView: UIImageView!
    @IBOutlet weak var secondEvolutionImageView: UIImageView!
    @IBOutlet weak var evolvesFromLabel: UILabel!
    @IBOutlet weak var evolvesToLabel: UILabel!

    func setContent(with chain: EvolutionChain, imageFetcher: ImageFetcher) {
        imageFetcher.fetch(from: chain.from.imageUrl) { image in
            self.firstEvolutionImageView.image = image
        }

        imageFetcher.fetch(from: chain.to.imageUrl) { image in
            self.secondEvolutionImageView.image = image
        }

        evolvesFromLabel.text = chain.from.name
        evolvesToLabel.text = chain.to.name
    }
}
