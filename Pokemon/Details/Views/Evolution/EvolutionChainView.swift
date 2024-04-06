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
    @IBOutlet weak var firstEvolutionLabel: UILabel!
    @IBOutlet weak var secondEvolutionLabel: UILabel!

    func setContent(with chain: EvolutionChain) {
        firstEvolutionImageView.kf.setImage(with: chain.from.imageUrl)
        secondEvolutionImageView.kf.setImage(with: chain.to.imageUrl)
        firstEvolutionLabel.text = chain.from.name
        secondEvolutionLabel.text = chain.to.name
    }
}
