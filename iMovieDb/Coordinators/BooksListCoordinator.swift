//
//  BooksListCoordinator.swift
//  MVVM Netologia
//
//  Created by Maksim Zhelezniakov on 30.09.2022.
//

import UIKit

final class BooksListCoordinator: ModuleCoordinatable {
    let moduleType: Module.ModuleType

    private let factory: AppFactory

    private(set) var childCoordinators: [Coordinatable] = []
    private(set) var module: Module?

    init(moduleType: Module.ModuleType, factory: AppFactory) {
        self.moduleType = moduleType
        self.factory = factory
    }

    func start() -> UIViewController {
        let module = factory.makeModule(ofType: moduleType)
        let viewController = module.view
        viewController.tabBarItem = moduleType.tabBarItem
        (module.viewModel as? ListViewModel)?.coordinator = self
        self.module = module
        return viewController
    }

    func pushBookViewController(forBook book: Book) {
        print("TESTESTEST")
        let viewControllerToPush = BookViewController(book: book)
        (module?.view as? UINavigationController)?.pushViewController(viewControllerToPush, animated: true)
    }
}
