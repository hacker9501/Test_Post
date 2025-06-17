//
//  AppCoordinator.swift
//  Test_Post
//
//  Created by Elver Mayta Hernández on 17/06/25.
//

import UIKit

protocol Coordinator {
    func start()
}

final class AppCoordinator: Coordinator {
    private let window: UIWindow
    private let diContainer: DIContainer

    init(window: UIWindow, diContainer: DIContainer) {
        self.window = window
        self.diContainer = diContainer
    }

    func start() {
        let postListVC = diContainer.makePostListViewController()
        let navigationController = UINavigationController(rootViewController: postListVC)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}
