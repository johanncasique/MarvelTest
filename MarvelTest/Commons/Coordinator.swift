//
//  Coordinator.swift
//  MarvelTest
//
//  Created by johann casique on 25/10/20.
//

import UIKit

class Coordinator {
    public var didFinish: ((Coordinator) -> Void)?
    public var childCoordinators: [Coordinator] = []
    public var navigationController: UINavigationController?
    
    init() {}
    
    func start() { }
    
    func push(_ coordinator: Coordinator) {
        coordinator.didFinish = { [weak self] coordinator in
            self?.pop(coordinator)
        }
        coordinator.start()
        childCoordinators.append(coordinator)
    }
    
    func pop(_ coordinator: Coordinator) {
        if let index = childCoordinators.firstIndex(where: {$0 === coordinator}) {
            childCoordinators.remove(at: index)
        }
    }
}
