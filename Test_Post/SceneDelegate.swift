//
//  SceneDelegate.swift
//  Test_Post
//
//  Created by Elver Mayta Hernández on 16/06/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var appCoordinator: AppCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.

        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        let diContainer = DIContainer()
        let coordinator = AppCoordinator(
            window: window,
            diContainer: diContainer
        )
        self.appCoordinator = coordinator
        coordinator.start()
    }
}

