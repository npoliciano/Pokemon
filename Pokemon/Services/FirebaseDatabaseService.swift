//
//  FirebaseDatabaseAPI.swift
//  Pokemon
//
//  Created by Nicolle on 20/03/24.
//

import Combine
import FirebaseDatabase

final class FirebaseDatabaseService<T: Decodable> {
    typealias JSON = [String: Any]

    let path: String
    let databaseReference: DatabaseReference

    init(path: String, databaseReference: DatabaseReference) {
        self.path = path
        self.databaseReference = databaseReference
    }

    func getData() -> AnyPublisher<T, Error> {
        Future {
            try await self.databaseReference.child(self.path).getData().data(as: T.self)
        }
        .eraseToAnyPublisher()
    }
}
