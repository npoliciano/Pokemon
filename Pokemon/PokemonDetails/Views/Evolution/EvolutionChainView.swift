//
//  EvolutionChainView.swift
//  Pokemon
//
//  Created by Nicolle on 12/03/24.
//

import UIKit

final class EvolutionChainView: UIView {
    @IBOutlet weak var firstEvolutionImageView: UIImageView!
    @IBOutlet weak var secondEvolutionImageView: UIImageView!
    @IBOutlet weak var firstEvolutionLabel: UILabel!
    @IBOutlet weak var secondEvolutionLabel: UILabel!

    func setContent(with chain: EvolutionChain) {
        firstEvolutionImageView.image = chain.from.image
        secondEvolutionImageView.image = chain.to.image
        firstEvolutionLabel.text = chain.from.name
        secondEvolutionLabel.text = chain.to.name
    }
}
