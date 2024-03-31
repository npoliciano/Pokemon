//
//  SceneDelegate.swift
//  Pokemon
//
//  Created by Nicolle on 05/03/24.
//

import UIKit
import FirebaseDatabase

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene

        let database = FirebaseDatabaseService<[PokemonJSON]>(
            path: "pokemons",
            databaseReference: Database.database().reference()
        )
        let api = HomeAPI(database: database)
        let viewModel = HomeViewModel(service: api, scheduler: .main)
        let homeViewController = HomeViewController(viewModel: viewModel)

        homeViewController.title = "Pokémons"
        let navigationController = UINavigationController(rootViewController: homeViewController)
        navigationController.navigationBar.prefersLargeTitles = true

        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}

