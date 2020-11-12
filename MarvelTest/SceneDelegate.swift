//
//  SceneDelegate.swift
//  MarvelTest
//
//  Created by johann casique on 25/10/20.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var appCoordinator: MainCoordinator!


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        self.window = UIWindow(windowScene: windowScene)
        appCoordinator = MainCoordinator(navigationController: UINavigationController())
        appCoordinator.start()
        window?.rootViewController = appCoordinator.navigationController
        window?.makeKeyAndVisible()
    }
}

