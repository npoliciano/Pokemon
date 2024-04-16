//
//  UIAlertController+Extensions.swift
//  Pokemon
//
//  Created by Nicolle on 15/04/24.
//

import UIKit

extension UIAlertController {
    static func errorAlert(onTryAgain: @escaping () -> Void) -> UIAlertController {
        let alert = UIAlertController(
            title: "Error",
            message: "Something went wrong. Please try again.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        alert.addAction(UIAlertAction(title: "Try again", style: .default, handler: { _ in
            onTryAgain()
        }))

        return alert
    }
}
