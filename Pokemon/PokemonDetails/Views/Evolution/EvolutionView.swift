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

    private let firstEvolutionChainView = EvolutionChainView.loadFromNib()
    private let secondEvolutionChainView = EvolutionChainView.loadFromNib()

    override func awakeFromNib() {
        super.awakeFromNib()
        setupFirstChainView()
        setupSecondChainView()
    }

    func setContent(with pokemon: Pokemon) {
        firstEvolutionChainView.setContent(with: pokemon.firstEvolutionChain)
        secondEvolutionChainView.setContent(with: pokemon.secondEvolutionChain)
    }

    private func setupFirstChainView() {
        firstEvolutionChainContainerView.addSubview(firstEvolutionChainView)
        firstEvolutionChainView.translatesAutoresizingMaskIntoConstraints = false

        firstEvolutionChainView.topAnchor.constraint(equalTo: firstEvolutionChainContainerView.topAnchor).isActive = true
        firstEvolutionChainView.bottomAnchor.constraint(equalTo: firstEvolutionChainContainerView.bottomAnchor).isActive = true
        firstEvolutionChainView.leadingAnchor.constraint(equalTo: firstEvolutionChainContainerView.leadingAnchor).isActive = true
        firstEvolutionChainView.trailingAnchor.constraint(equalTo: firstEvolutionChainContainerView.trailingAnchor).isActive = true
    }

    private func setupSecondChainView() {
        secondEvolutionChainContainerView.addSubview(secondEvolutionChainView)
        secondEvolutionChainView.translatesAutoresizingMaskIntoConstraints = false

        secondEvolutionChainView.topAnchor.constraint(equalTo: secondEvolutionChainContainerView.topAnchor).isActive = true
        secondEvolutionChainView.bottomAnchor.constraint(equalTo: secondEvolutionChainContainerView.bottomAnchor).isActive = true
        secondEvolutionChainView.leadingAnchor.constraint(equalTo: secondEvolutionChainContainerView.leadingAnchor).isActive = true
        secondEvolutionChainView.trailingAnchor.constraint(equalTo: secondEvolutionChainContainerView.trailingAnchor).isActive = true
    }
}
