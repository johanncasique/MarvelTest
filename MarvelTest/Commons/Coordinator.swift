//
//  Coordinator.swift
//  MarvelTest
//
//  Created by johann casique on 25/10/20.
//

import UIKit

protocol Coordinator {
    var children: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    
    func start()
}
