//
//  ImageFetcherSpy.swift
//  PokemonTests
//
//  Created by Nicolle on 15/04/24.
//

import UIKit
@testable import Pokemon

final class ImageFetcherSpy: ImageFetcher {
    private(set) var fetchCalls = 0
    var expectedImages: [URL: UIImage?] = [:]

    func fetch(from url: URL, completion: @escaping (UIImage?) -> Void) {
        fetchCalls += 1
        if let image = expectedImages[url] {
            completion(image)
        }
    }
}
