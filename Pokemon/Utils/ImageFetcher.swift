//
//  ImageFetcher.swift
//  Pokemon
//
//  Created by Nicolle on 06/04/24.
//

import UIKit
import Kingfisher

final class KingfisherImageFetcher {
    private let kingfisherManager: KingfisherManager

    init(kingfisherManager: KingfisherManager = .shared) {
        self.kingfisherManager = kingfisherManager
    }
}

extension KingfisherImageFetcher: ImageFetcher {
    func fetch(from url: URL, completion: @escaping (UIImage?) -> Void) {
        kingfisherManager.retrieveImage(with: url) { result in
            let retrieveImageResult = try? result.get()
            completion(retrieveImageResult?.image)
        }
    }
}
