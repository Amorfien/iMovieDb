//
//  Movie.swift
//  iMovieDb
//
//  Created by Pavel Grigorev on 30.05.2023.
//

import Foundation

// MARK: - Movie
struct Movie: Codable {

    let title, year, rated, released: String
    let genre, director, writer: String
    var runtime: String
    let actors, plot, country: String
    let awards: String
    let poster: String
    var posterData: Data?
    let metascore, imdbRating, imdbVotes, imdbID: String
    let type: String
    let boxOffice: String?
    let totalSeasons: String?

    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case rated = "Rated"
        case released = "Released"
        case runtime = "Runtime"
        case genre = "Genre"
        case director = "Director"
        case writer = "Writer"
        case actors = "Actors"
        case plot = "Plot"
        case country = "Country"
        case awards = "Awards"
        case poster = "Poster"
        case posterData = "posterData"
        case metascore = "Metascore"
        case imdbRating, imdbVotes, imdbID
        case type = "Type"
        case boxOffice = "BoxOffice"
        case totalSeasons
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decode(String.self, forKey: .title)
        self.year = try container.decode(String.self, forKey: .year)
        self.rated = try container.decode(String.self, forKey: .rated)
        self.released = try container.decode(String.self, forKey: .released)
        self.runtime = try container.decode(String.self, forKey: .runtime)
        self.genre = try container.decode(String.self, forKey: .genre)
        self.director = try container.decode(String.self, forKey: .director)
        self.writer = try container.decode(String.self, forKey: .writer)
        self.actors = try container.decode(String.self, forKey: .actors)
        self.plot = try container.decode(String.self, forKey: .plot)
        self.country = try container.decode(String.self, forKey: .country)
        self.awards = try container.decode(String.self, forKey: .awards)
        self.poster = try container.decode(String.self, forKey: .poster)
        self.posterData = try container.decodeIfPresent(Data.self, forKey: .posterData)
        self.metascore = try container.decode(String.self, forKey: .metascore)
        self.imdbRating = try container.decode(String.self, forKey: .imdbRating)
        self.imdbVotes = try container.decode(String.self, forKey: .imdbVotes)
        self.imdbID = try container.decode(String.self, forKey: .imdbID)
        self.type = try container.decode(String.self, forKey: .type)
        self.boxOffice = try container.decodeIfPresent(String.self, forKey: .boxOffice)
        self.totalSeasons = try container.decodeIfPresent(String.self, forKey: .totalSeasons)

        self.runtime = timeFormatter(runtime: runtime)
    }

    // перевод минут в часы+минуты
    private func timeFormatter(runtime: String) -> String {

        guard let minutesStr = runtime.components(separatedBy: " min").first else { return "" }

        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .abbreviated

        let minutes = Int(minutesStr)
        return formatter.string(from: .init(minute: minutes)) ?? ""

    }

    // сабскрипт для автоматического заполнения информации в DetailViewController с помощью цикла
    subscript(_ property: DetailType) -> String {
        switch property {
        case .title:
            return self.title
        case .year:
            return self.year
        case .rated:
            return self.rated
        case .released:
            return self.released
        case .runtime:
            return self.runtime
        case .genre:
            return self.genre
        case .director:
            return self.director
        case .writer:
            return self.writer
        case .actors:
            return self.actors
        case .plot:
            return self.plot
        case .country:
            return self.country
        case .awards:
            return self.awards
        case .metascore:
            return self.metascore
        case .rating:
            return self.imdbRating
        case .votes:
            return self.imdbVotes
        case .type:
            return self.type
        case .boxOffice:
            return self.boxOffice ?? "--"
        case .seasons:
            return self.totalSeasons ?? "--"
        }
    }

}

extension Movie: Comparable {
    static func < (lhs: Movie, rhs: Movie) -> Bool {
        lhs.title < rhs.title
    }
    static func == (lhs: Movie, rhs: Movie) -> Bool {
        lhs.imdbID == rhs.imdbID
    }
}
