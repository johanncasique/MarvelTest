//
//  CharactersCoordinator.swift
//  MarvelTest
//
//  Created by johann casique on 27/10/20.
//

import UIKit

protocol CharactersCoordinatorDelegate: AnyObject {
    func openDetail(for character: Character)
}

class CharactersCoordinator: Coordinator {
    
    var rootViewController: UINavigationController {
        return navigationController ?? UINavigationController()
    }
    
    override func start() {
        super.start()
        loadMainView()
    }
    
    private func loadMainView() {
        let viewModel = CharactersViewModel()
        let view = CharactersViewController()
        viewModel.delegate = view
        viewModel.coordinatorDelagate = self
        Dependencies.Container.main.register(viewModel)
        navigationController = UINavigationController(rootViewController: view)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}

extension CharactersCoordinator: CharactersCoordinatorDelegate {
    func openDetail(for character: Character) {
        print(character)
        let viewModel = CharacterDetailViewModel(character)
        let view = DetailViewController()
        Dependencies.Container.main.register(viewModel,
                                             for: DependenciesName.detail.name)
        
        navigationController?.present(view, animated: true)
        
    }
}


