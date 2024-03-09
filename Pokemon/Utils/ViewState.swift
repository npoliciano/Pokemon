//
//  ViewState.swift
//  Pokemon
//
//  Created by Nicolle on 08/03/24.
//

import Foundation

enum ViewState<Content> {
    case loading
    case content(Content)
}
