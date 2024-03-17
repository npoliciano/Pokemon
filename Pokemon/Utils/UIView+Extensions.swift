//
//  UIView+Extensions.swift
//  Pokemon
//
//  Created by Nicolle on 17/03/24.
//

import UIKit

extension UIView {
    static func loadFromNib() -> Self {
        UINib(nibName: String(describing: Self.self), bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! Self
    }
}

extension UIView {
    func constrainToEdges(superview: UIView) {
        translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superview.topAnchor),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor),
            leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor)
        ])
    }
}
