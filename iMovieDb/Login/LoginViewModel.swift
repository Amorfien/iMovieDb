//
//  LoginViewModel.swift
//  iMovieDb
//
//  Created by Pavel Grigorev on 31.05.2023.
//

import Foundation

protocol LoginViewModelProtocol: AnyObject {
    var onStateDidChange: ((LoginViewModel.State) -> Void)? { get set }
    func updateState(viewInput: LoginViewModel.ViewInput)
}

enum LoginError: String, Error {
    case wrongPassword = "Wrong Password"
}

final class LoginViewModel: LoginViewModelProtocol {
    enum State {
        case initial
        case login(User)
        case error(LoginError)
    }

    enum ViewInput {
        case loginButtonDidTap(user: User)
    }

    var onStateDidChange: ((State) -> Void)?

    private(set) var state: State = .initial {
        didSet {
            onStateDidChange?(state)
        }
    }

    private let userChecker: AuthenticationProtocol

    init(userChecker: AuthenticationProtocol) {
        self.userChecker = userChecker
    }

    func updateState(viewInput: ViewInput) {
        switch viewInput {
        case .loginButtonDidTap(user: let user):
            if userChecker.check(password: user.password) {
                print("Login Success 🟢")
                UserSettings.lastUser = user
                UserSettings.isLogin = true
                self.state = .login(user)
            } else {
                print("Wrong Password 🛑")
                self.state = .error(.wrongPassword)
            }
        }
    }
}
