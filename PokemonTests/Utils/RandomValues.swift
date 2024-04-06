//
//  RandomValues.swift
//  PokemonTests
//
//  Created by Nicolle on 05/04/24.
//

import Foundation

extension String {
    static var anyValue: String {
        UUID().uuidString
    }
}

extension URL {
    static var anyValue: URL {
        URL(filePath: .anyValue)
    }
}

extension Int {
    static var anyValue: Int {
        Int.random(in: -1000...1000)
    }
}
