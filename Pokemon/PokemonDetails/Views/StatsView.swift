//
//  StatsView.swift
//  Pokemon
//
//  Created by Nicolle on 11/03/24.
//

import UIKit

final class StatsView: UIView {
    @IBOutlet weak var hpLabel: UILabel!
    @IBOutlet weak var attackLabel: UILabel!
    @IBOutlet weak var defenseLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var hpProgressView: UIProgressView!
    @IBOutlet weak var attackProgressView: UIProgressView!
    @IBOutlet weak var defenseProgressView: UIProgressView!
    @IBOutlet weak var speedProgressView: UIProgressView!
    @IBOutlet weak var totalProgressView: UIProgressView!

    func setContent(with pokemon: PokemonDetails) {
        hpLabel.text = String(pokemon.hp)
        attackLabel.text = String(pokemon.attack)
        defenseLabel.text = String(pokemon.defense)
        speedLabel.text = String(pokemon.speed)
        totalLabel.text = String(pokemon.statsTotal)
        hpProgressView.setProgress(Float(pokemon.hp)/100, animated: true)
        attackProgressView.setProgress(Float(pokemon.attack)/100, animated: true)
        defenseProgressView.setProgress(Float(pokemon.defense)/100, animated: true)
        speedProgressView.setProgress(Float(pokemon.speed)/100, animated: true)
        totalProgressView.setProgress(Float(pokemon.statsTotal)/400, animated: true)
        hpProgressView.progressTintColor = getProgressColor(with: pokemon.hp)
        attackProgressView.progressTintColor = getProgressColor(with: pokemon.attack)
        defenseProgressView.progressTintColor = getProgressColor(with: pokemon.defense)
        speedProgressView.progressTintColor = getProgressColor(with: pokemon.speed)
        totalProgressView.progressTintColor = getProgressColor(with: pokemon.statsTotal)
    }

    private func getProgressColor(with attribute: Int) -> UIColor {
        attribute >= 50 ? .systemGreen : .systemOrange
    }
}
