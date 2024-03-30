//
//  HomeViewModel.swift
//  Pokemon
//
//  Created by Nicolle on 19/03/24.
//

import Combine
import Foundation

enum HomeViewState {
    case content([Pokemon])
    case error
}

protocol HomeService {
    func getPokemons() -> AnyPublisher<[Pokemon], Error>
}

final class HomeViewModel {
    @Published
    private(set) var state = HomeViewState.content([])

    private let service: HomeService

    private var subscription: AnyCancellable?

    init(service: HomeService) {
        self.service = service
    }

    func onAppear() {
        subscription = service.getPokemons()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure = completion {
                    self?.state = .error
                }
            } receiveValue: { [weak self] pokemons in
                self?.state = .content(pokemons)
            }
    }

    func onRefresh() {
        onAppear()
    }
}
