//
//  User.swift
//  iMovieDb
//
//  Created by Pavel Grigorev on 31.05.2023.
//

import Foundation

struct User: Codable {

    let login: String
    let password: String

    var movieList = [
        "tt0120737",
        "tt0265086",
        "tt0093058",
        "tt0111161",
        "tt0068646",
        "tt0108052",
        "tt0120737", // (повтор + длинное название)
        "tt0109830",
        "tt1375666",
        "tt0133093",
        "tt0120815",
        "tt0110357",
        "tt0096697",
        "tt0245429" // сериал, количество сезонов
    ]
}
