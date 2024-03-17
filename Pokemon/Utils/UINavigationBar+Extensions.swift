//
//  UINavigationController.swift
//  Pokemon
//
//  Created by Nicolle on 17/03/24.
//

import UIKit

extension UINavigationBar {
    func setTitleColor(_ color: UIColor) {
        titleTextAttributes = [
            .foregroundColor: color
        ]
        largeTitleTextAttributes = [
            .foregroundColor: color
        ]
    }
}
