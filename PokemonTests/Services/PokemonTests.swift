//
//  PokemonTests.swift
//  PokemonTests
//
//  Created by Nicolle on 05/04/24.
//

import XCTest

@testable import Pokemon

final class PokemonTests: XCTestCase {
    func testInitsWithJSONAndParseColor() {
        let json = PokemonJSON.fixture(
            secondaryAttribute: "some value",
            backgroundColor: .whiteHexColor
        )

        let sut = Pokemon(json: json)

        XCTAssertEqual(sut.id, json.id)
        XCTAssertEqual(sut.name, json.name)
        XCTAssertEqual(sut.imageUrl, json.imageUrl)
        XCTAssertEqual(sut.primaryAttribute, json.primaryAttribute)
        XCTAssertEqual(sut.secondaryAttribute, json.secondaryAttribute)
        XCTAssertEqual(sut.backgroundColor, UIColor.whiteColor)
    }

    func testInitsWithJSONAndSetClearColorWhenInvalid() {
        let json = PokemonJSON.fixture(
            secondaryAttribute: "some value",
            backgroundColor: "invalid color"
        )

        let sut = Pokemon(json: json)

        XCTAssertEqual(sut.id, json.id)
        XCTAssertEqual(sut.name, json.name)
        XCTAssertEqual(sut.imageUrl, json.imageUrl)
        XCTAssertEqual(sut.primaryAttribute, json.primaryAttribute)
        XCTAssertEqual(sut.secondaryAttribute, json.secondaryAttribute)
        XCTAssertEqual(sut.backgroundColor, .clear)
    }

    func testInitsWithJSONAndSetNilSecondaryAttribute() {
        let json = PokemonJSON.fixture(
            secondaryAttribute: nil
        )

        let sut = Pokemon(json: json)

        XCTAssertEqual(sut.id, json.id)
        XCTAssertEqual(sut.name, json.name)
        XCTAssertEqual(sut.imageUrl, json.imageUrl)
        XCTAssertEqual(sut.primaryAttribute, json.primaryAttribute)
        XCTAssertEqual(sut.backgroundColor, .clear)
        XCTAssertNil(sut.secondaryAttribute)
    }
}
