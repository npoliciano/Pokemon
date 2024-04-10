//
//  FakeUIRefreshControl.swift
//  PokemonTests
//
//  Created by Nicolle on 09/04/24.
//

import UIKit

// Using a fake RefreshControl due to an iOS 17 issue
// Solution inspired by: 
// - https://github.com/essentialdevelopercom/essential-feed-case-study

final class FakeUIRefreshControl: UIRefreshControl {
    private var _isRefreshing = false

    override var isRefreshing: Bool {
        _isRefreshing
    }

    override func beginRefreshing() {
        _isRefreshing = true
    }

    override func endRefreshing() {
        _isRefreshing = false
    }
}
