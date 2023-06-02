//
//  UserSettings.swift
//  iMovieDb
//
//  Created by Pavel Grigorev on 31.05.2023.
//

import Foundation

final class UserSettings {

    enum SettingsKeys: String {//}, CaseIterable {
        case isLogin
        case lastUser
    }

    static var isLogin: Bool {
        get {
            UserDefaults.standard.bool(forKey: SettingsKeys.isLogin.rawValue)
        } set {
            UserDefaults.standard.set(newValue, forKey: SettingsKeys.isLogin.rawValue)
        }
    }

    static var lastUser: String {
        get {
            UserDefaults.standard.string(forKey: SettingsKeys.lastUser.rawValue) ?? ""
        } set {
            UserDefaults.standard.set(newValue, forKey: SettingsKeys.lastUser.rawValue)
        }
    }


}
