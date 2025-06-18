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
    private var navigationController: UINavigationController?

    init(window: UIWindow, diContainer: DIContainer) {
        self.window = window
        self.diContainer = diContainer
    }

    func start() {
        let actions = PostViewModelActions(
            navigationDetail: navigateToDetail
        )
        let postListVC = diContainer.makePostListViewController(
            actions: actions
        )
        let navController = UINavigationController(rootViewController: postListVC)
        self.navigationController = navController
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    func navigateToDetail(post: Post) {
        let viewController = diContainer.makePostDetailViewController(post: post)
        navigationController?.pushViewController(
            viewController,
            animated: true
        )
    }
}
