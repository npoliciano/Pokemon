//
//  HomeViewModel.swift
//  Pokemon
//
//  Created by Nicolle on 19/03/24.
//

import Combine
import Foundation

final class HomeViewModel {
    @Published var state = ViewState<[Pokemon]>.loading

    private let api: HomeAPI

    private var subscription: AnyCancellable?

    init(api: HomeAPI) {
        self.api = api
    }

    func onAppear() {
        subscription = api.getPokemons()
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
