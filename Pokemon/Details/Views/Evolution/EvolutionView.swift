//
//  EvolutionView.swift
//  Pokemon
//
//  Created by Nicolle on 12/03/24.
//

import UIKit

final class EvolutionView: UIView {
    @IBOutlet weak var firstEvolutionChainContainerView: UIView!
    @IBOutlet weak var secondEvolutionChainContainerView: UIView!

    let firstEvolutionChainView = EvolutionChainView.loadFromNib()
    let secondEvolutionChainView = EvolutionChainView.loadFromNib()

    override func awakeFromNib() {
        super.awakeFromNib()
        setupFirstChainView()
        setupSecondChainView()
    }

    func setContent(with pokemon: PokemonDetails, imageFetcher: ImageFetcher) {
        firstEvolutionChainView.setContent(
            with: pokemon.firstEvolutionChain,
            imageFetcher: imageFetcher
        )
        secondEvolutionChainView.setContent(
            with: pokemon.secondEvolutionChain,
            imageFetcher: imageFetcher
        )
    }

    private func setupFirstChainView() {
        firstEvolutionChainContainerView.addSubview(firstEvolutionChainView)
        firstEvolutionChainView.constrainToEdges(superview: firstEvolutionChainContainerView)
    }

    private func setupSecondChainView() {
        secondEvolutionChainContainerView.addSubview(secondEvolutionChainView)
        secondEvolutionChainView.constrainToEdges(superview: secondEvolutionChainContainerView)
    }
}
