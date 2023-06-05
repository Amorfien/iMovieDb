//
//  SceneDelegate.swift
//  iMovieDb
//
//  Created by Pavel Grigorev on 29.05.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }

        self.window = UIWindow(windowScene: windowScene)
        self.window?.overrideUserInterfaceStyle = .light //отключение возможности тёмной темы

        if UserSettings.isLogin {
            let listViewModel = ListViewModel(networkService: NetworkService(), user: UserSettings.lastUser!)
            let listViewController = ListViewController(viewModel: listViewModel)
            self.window?.rootViewController = UINavigationController(rootViewController: listViewController)
        } else {
            let loginViewModel = LoginViewModel(userChecker: UserChecker())
            let loginViewController = LoginViewController(viewModel: loginViewModel)
            self.window?.rootViewController = UINavigationController(rootViewController: loginViewController)
        }

        self.window?.makeKeyAndVisible()

    }

}

