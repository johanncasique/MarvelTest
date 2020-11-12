//
//  AppCoordinator.swift
//  MarvelTest
//
//  Created by johann casique on 25/10/20.
//

import UIKit

class MainCoordinator: Coordinator {
    
    var children = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let coordinator = CharactersCoordinator(navigationController: navigationController)
        coordinator.start()
        navigationController = coordinator.navigationController
    }
}
