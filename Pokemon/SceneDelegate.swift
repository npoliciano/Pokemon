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

        let reference = Database.database().reference()
        
        let dataSource = FirebaseDataSource<[PokemonJSON]>(
            path: "pokemons",
            databaseReference: reference
        )
        let api = HomeAPI(dataSource: dataSource)
        let navigationController = UINavigationController()
        let imageFetcher = KingfisherImageFetcher()

        let viewModel = HomeViewModel(
            service: api,
            scheduler: .main,
            onSelectPokemon: { pokemonId in
                let dataSource = FirebaseDataSource<PokemonJSON>(
                    path: "pokemons/\(pokemonId)",
                    databaseReference: reference
                )
                let api = PokemonDetailsAPI(dataSource: dataSource)
                let viewModel = PokemonDetailsViewModel(service: api, scheduler: .main)
                let viewController = PokemonDetailsViewController(
                    viewModel: viewModel,
                    imageFetcher: imageFetcher
                )
                
                navigationController.pushViewController(viewController, animated: true)
            }
        )

        let homeViewController = HomeViewController(viewModel: viewModel, imageFetcher: imageFetcher)

        homeViewController.title = "Pokémons"
        navigationController.viewControllers = [homeViewController]
        navigationController.navigationBar.prefersLargeTitles = true

        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}

