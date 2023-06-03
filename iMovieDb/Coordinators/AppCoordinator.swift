//
//  AppCoordinator.swift
//  MVVM Netologia
//
//  Created by Maksim Zhelezniakov on 30.09.2022.
//

import UIKit

final class AppCoordinator: Coordinatable {
    private(set) var childCoordinators: [Coordinatable] = []

    private let factory: AppFactory

    init(factory: AppFactory) {
        self.factory = factory
    }

    func start() -> UIViewController {
        let booksListCoordinator = BooksListCoordinator(moduleType: .booksList, factory: factory)
        let aboutCoordinator = AboutCoordinator(moduleType: .about, factory: factory)

        let appTabBarController = AppTabBarController(viewControllers: [
            booksListCoordinator.start(),
            aboutCoordinator.start()
        ])

        addChildCoordinator(booksListCoordinator)
        addChildCoordinator(aboutCoordinator)

        return appTabBarController
    }

    func addChildCoordinator(_ coordinator: Coordinatable) {
        guard !childCoordinators.contains(where: { $0 === coordinator }) else {
            return
        }
        childCoordinators.append(coordinator)
    }

    func removeChildCoordinator(_ coordinator: Coordinatable) {
        childCoordinators = childCoordinators.filter { $0 === coordinator }
    }
}
