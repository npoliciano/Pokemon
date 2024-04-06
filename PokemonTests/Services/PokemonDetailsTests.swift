//
//  PokemonDetailsTests.swift
//  PokemonTests
//
//  Created by Nicolle on 05/04/24.
//

import Foundation

import XCTest

@testable import Pokemon

final class PokemonDetailsTests: XCTestCase {
    func testInitsWithJSONAndParseColor() {
        let json = PokemonJSON.fixture(
            secondaryAttribute: "some value",
            backgroundColor: .whiteHexColor
        )

        let sut = PokemonDetails(json: json)

        XCTAssertEqual(sut.name, json.name)
        XCTAssertEqual(sut.imageUrl, json.imageUrl)
        XCTAssertEqual(sut.primaryAttribute, json.primaryAttribute)
        XCTAssertEqual(sut.secondaryAttribute, json.secondaryAttribute)
        XCTAssertEqual(sut.backgroundColor, UIColor.whiteColor)
        XCTAssertEqual(sut.specie, json.specie)
        XCTAssertEqual(sut.description, json.description)
        XCTAssertEqual(sut.eggCycle, json.eggCycle)
        XCTAssertEqual(sut.eggGroups, json.eggGroups)
        XCTAssertEqual(sut.female, json.female)
        XCTAssertEqual(sut.male, json.male)
        XCTAssertEqual(sut.height, json.height)
        XCTAssertEqual(sut.weight, json.weight)
        XCTAssertEqual(sut.hp, json.hp)
        XCTAssertEqual(sut.attack, json.attack)
        XCTAssertEqual(sut.defense, json.defense)
        XCTAssertEqual(sut.speed, json.speed)
        XCTAssertEqual(sut.statsTotal, json.statsTotal)
        XCTAssertEqual(sut.firstEvolutionChain.from.name, json.firstEvolutionChain.from.name)
        XCTAssertEqual(sut.firstEvolutionChain.from.imageUrl, json.firstEvolutionChain.from.imageUrl)
        XCTAssertEqual(sut.firstEvolutionChain.to.name, json.firstEvolutionChain.to.name)
        XCTAssertEqual(sut.firstEvolutionChain.to.imageUrl, json.firstEvolutionChain.to.imageUrl)
        XCTAssertEqual(sut.secondEvolutionChain.from.name, json.secondEvolutionChain.from.name)
        XCTAssertEqual(sut.secondEvolutionChain.from.imageUrl, json.secondEvolutionChain.from.imageUrl)
        XCTAssertEqual(sut.secondEvolutionChain.to.name, json.secondEvolutionChain.to.name)
        XCTAssertEqual(sut.secondEvolutionChain.to.imageUrl, json.secondEvolutionChain.to.imageUrl)
    }

    func testInitsWithJSONAndSetClearColorWhenInvalid() {
        let json = PokemonJSON.fixture(
            secondaryAttribute: "some value",
            backgroundColor: "invalid color"
        )

        let sut = PokemonDetails(json: json)

        XCTAssertEqual(sut.name, json.name)
        XCTAssertEqual(sut.imageUrl, json.imageUrl)
        XCTAssertEqual(sut.primaryAttribute, json.primaryAttribute)
        XCTAssertEqual(sut.secondaryAttribute, json.secondaryAttribute)
        XCTAssertEqual(sut.backgroundColor, .clear)
        XCTAssertEqual(sut.specie, json.specie)
        XCTAssertEqual(sut.description, json.description)
        XCTAssertEqual(sut.eggCycle, json.eggCycle)
        XCTAssertEqual(sut.eggGroups, json.eggGroups)
        XCTAssertEqual(sut.female, json.female)
        XCTAssertEqual(sut.male, json.male)
        XCTAssertEqual(sut.height, json.height)
        XCTAssertEqual(sut.weight, json.weight)
        XCTAssertEqual(sut.hp, json.hp)
        XCTAssertEqual(sut.attack, json.attack)
        XCTAssertEqual(sut.defense, json.defense)
        XCTAssertEqual(sut.speed, json.speed)
        XCTAssertEqual(sut.statsTotal, json.statsTotal)
        XCTAssertEqual(sut.firstEvolutionChain.from.name, json.firstEvolutionChain.from.name)
        XCTAssertEqual(sut.firstEvolutionChain.from.imageUrl, json.firstEvolutionChain.from.imageUrl)
        XCTAssertEqual(sut.firstEvolutionChain.to.name, json.firstEvolutionChain.to.name)
        XCTAssertEqual(sut.firstEvolutionChain.to.imageUrl, json.firstEvolutionChain.to.imageUrl)
        XCTAssertEqual(sut.secondEvolutionChain.from.name, json.secondEvolutionChain.from.name)
        XCTAssertEqual(sut.secondEvolutionChain.from.imageUrl, json.secondEvolutionChain.from.imageUrl)
        XCTAssertEqual(sut.secondEvolutionChain.to.name, json.secondEvolutionChain.to.name)
        XCTAssertEqual(sut.secondEvolutionChain.to.imageUrl, json.secondEvolutionChain.to.imageUrl)
    }

    func testInitsWithJSONAndSetNilSecondaryAttribute() {
        let json = PokemonJSON.fixture(
            secondaryAttribute: nil
        )

        let sut = PokemonDetails(json: json)

        XCTAssertEqual(sut.name, json.name)
        XCTAssertEqual(sut.imageUrl, json.imageUrl)
        XCTAssertEqual(sut.primaryAttribute, json.primaryAttribute)
        XCTAssertEqual(sut.backgroundColor, .clear)
        XCTAssertEqual(sut.specie, json.specie)
        XCTAssertEqual(sut.description, json.description)
        XCTAssertEqual(sut.eggCycle, json.eggCycle)
        XCTAssertEqual(sut.eggGroups, json.eggGroups)
        XCTAssertEqual(sut.female, json.female)
        XCTAssertEqual(sut.male, json.male)
        XCTAssertEqual(sut.height, json.height)
        XCTAssertEqual(sut.weight, json.weight)
        XCTAssertEqual(sut.hp, json.hp)
        XCTAssertEqual(sut.attack, json.attack)
        XCTAssertEqual(sut.defense, json.defense)
        XCTAssertEqual(sut.speed, json.speed)
        XCTAssertEqual(sut.statsTotal, json.statsTotal)
        XCTAssertEqual(sut.firstEvolutionChain.from.name, json.firstEvolutionChain.from.name)
        XCTAssertEqual(sut.firstEvolutionChain.from.imageUrl, json.firstEvolutionChain.from.imageUrl)
        XCTAssertEqual(sut.firstEvolutionChain.to.name, json.firstEvolutionChain.to.name)
        XCTAssertEqual(sut.firstEvolutionChain.to.imageUrl, json.firstEvolutionChain.to.imageUrl)
        XCTAssertEqual(sut.secondEvolutionChain.from.name, json.secondEvolutionChain.from.name)
        XCTAssertEqual(sut.secondEvolutionChain.from.imageUrl, json.secondEvolutionChain.from.imageUrl)
        XCTAssertEqual(sut.secondEvolutionChain.to.name, json.secondEvolutionChain.to.name)
        XCTAssertEqual(sut.secondEvolutionChain.to.imageUrl, json.secondEvolutionChain.to.imageUrl)
        XCTAssertNil(sut.secondaryAttribute)
    }
}
