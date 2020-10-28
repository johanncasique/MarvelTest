//
//  AppCoordinator.swift
//  MarvelTest
//
//  Created by johann casique on 25/10/20.
//

import UIKit

class AppCoordinator: Coordinator {
    var rootViewController: UIViewController {
        return navigationController ?? UINavigationController()
    }
    
    override func start() {
        super.start()
        showMain()
    }
    
    private func showMain() {
        let coordinator = CharactersCoordinator()
        coordinator.start()
        navigationController = coordinator.rootViewController
    }
    
}
