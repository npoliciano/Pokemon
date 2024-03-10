//
//  AboutView.swift
//  Pokemon
//
//  Created by Nicolle on 09/03/24.
//

import UIKit

final class AboutView: UIView {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var eggCycleLabel: UILabel!
    @IBOutlet weak var eggGroupsLabel: UILabel!
    @IBOutlet weak var femaleLabel: UILabel!
    @IBOutlet weak var maleLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!

    func setContent(with pokemon: Pokemon) {
        descriptionLabel.text = pokemon.description
        eggCycleLabel.text = pokemon.eggCycle
        eggGroupsLabel.text = pokemon.eggGroups
        femaleLabel.text = pokemon.female
        maleLabel.text = pokemon.male
        heightLabel.text = pokemon.height
        weightLabel.text = pokemon.weight
    }
}
