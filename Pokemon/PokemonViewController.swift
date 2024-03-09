//
//  PokemonViewController.swift
//  Pokemon
//
//  Created by Nicolle on 05/03/24.
//

import UIKit

struct Pokemon {
    let name: String
    let primaryAttribute: String
    let secondaryAttribute: String?
    let specie: String
    let image: UIImage
    let predominantColor: UIColor
}

class PokemonViewController: UIViewController {
    let pokemon = Pokemon(
        name: "Pikachu",
        primaryAttribute: "Electric",
        secondaryAttribute: nil,
        specie: "Mouse",
        image: .pikachu,
        predominantColor: UIColor(named: "Yellow")!
    )

    @IBOutlet weak var specieLabel: UILabel!
    @IBOutlet weak var primaryAttributeLabel: UILabel!
    @IBOutlet weak var secondaryAttributeView: UIView!
    @IBOutlet weak var secondaryAttributeLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!

    override func viewDidLoad() {
        title = pokemon.name
        view.backgroundColor = pokemon.predominantColor

        primaryAttributeLabel.text = pokemon.primaryAttribute
        specieLabel.text = "\(pokemon.specie) Pokemon"
        imageView.image = pokemon.image

        if let secondaryAttribute = pokemon.secondaryAttribute {
            secondaryAttributeLabel.text = secondaryAttribute
            secondaryAttributeView.isHidden = false
        } else {
            secondaryAttributeView.isHidden = true
        }
    }
}
