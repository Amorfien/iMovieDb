//
//  UserSettings.swift
//  iMovieDb
//
//  Created by Pavel Grigorev on 31.05.2023.
//

import Foundation

/// обёртка над UserDefaults
final class UserSettings {

    enum SettingsKeys: String {//}, CaseIterable {
        case isLogin
        case lastUser
        case movieListCache
    }

    static var isLogin: Bool {
        get {
            UserDefaults.standard.bool(forKey: SettingsKeys.isLogin.rawValue)
        } set {
            UserDefaults.standard.set(newValue, forKey: SettingsKeys.isLogin.rawValue)
        }
    }

    static var lastUser: User? {
        get {
            if let data = UserDefaults.standard.object(forKey: SettingsKeys.lastUser.rawValue) as? Data,
               let user = try? JSONDecoder().decode(User.self, from: data) {
                return user
            }
            return nil
        } set {
            UserDefaults.standard.set(try? JSONEncoder().encode(newValue), forKey: SettingsKeys.lastUser.rawValue)
        }
    }

    static var cacheMovieList: [Movie]? {
        get {
            if let data = UserDefaults.standard.object(forKey: SettingsKeys.movieListCache.rawValue) as? Data,
               let movies = try? JSONDecoder().decode([Movie].self, from: data) {
                return movies
            }
            return nil
        } set {
            var cacheList: [Movie] = []
            newValue?.forEach({ movie in
                var cache = movie
                cache.posterData = nil
                cacheList.append(cache)
            })
            UserDefaults.standard.set(try? JSONEncoder().encode(cacheList), forKey: SettingsKeys.movieListCache.rawValue)
        }
    }

}
