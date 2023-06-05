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
    func checkLastUser()
}

enum LoginError: String, Error {
    case wrongPassword = "Wrong Password"
}

final class LoginViewModel: LoginViewModelProtocol {

    enum State {
        case initial
        case lastUser(String)
        case login(User)
        case error(LoginError)
    }

    enum ViewInput {
        case loginButtonDidTap(user: User)
        case errorCanceling
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
        case .errorCanceling:
            self.state = .initial
        }
    }

    // сделал отдельный метод, т.к. не могу поместить проверку в init, не срабатывает didSet
    func checkLastUser() {
        if let login = UserSettings.lastUser?.login {
            self.state = .lastUser(login)
        }
    }

}
