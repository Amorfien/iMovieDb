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

final class LoginViewModel: LoginViewModelProtocol {
    enum State {
        case initial
        case login
        case error(Error)
    }

    enum ViewInput {
        case loginButtonDidTap(user: User)
//        case movieDidSelect(Movie)
    }

//    weak var coordinator: BooksListCoordinator?
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
                UserSettings.lastUser = user.login
            } else {
                print("Wrong Password 🛑")
            }
        }
    }
}
