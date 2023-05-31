//
//  UserChecker.swift
//  iMovieDb
//
//  Created by Pavel Grigorev on 30.05.2023.
//

import Foundation

protocol AuthenticationProtocol {
    func check(password: String) -> Bool
}

final class UserChecker: AuthenticationProtocol {

    private let correctPassword = "1234"

    func check(password: String) -> Bool {
        password == correctPassword
    }

}
