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
    let ratings: [Rating]
    let metascore, imdbRating, imdbVotes, imdbID: String
    let type, boxOffice: String

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
        case ratings = "Ratings"
        case metascore = "Metascore"
        case imdbRating, imdbVotes, imdbID
        case type = "Type"
        case boxOffice = "BoxOffice"
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
        self.ratings = try container.decode([Rating].self, forKey: .ratings)
        self.metascore = try container.decode(String.self, forKey: .metascore)
        self.imdbRating = try container.decode(String.self, forKey: .imdbRating)
        self.imdbVotes = try container.decode(String.self, forKey: .imdbVotes)
        self.imdbID = try container.decode(String.self, forKey: .imdbID)
        self.type = try container.decode(String.self, forKey: .type)
        self.boxOffice = try container.decode(String.self, forKey: .boxOffice)

        self.runtime = timeFormatter(runtime: runtime)
//        self.timing = timeFormatter(runtime: runtime)
    }

    init(title: String, year: String, rated: String, released: String, runtime: String, genre: String, director: String, writer: String, actors: String, plot: String, country: String, awards: String, poster: String, posterData: Data? = nil, ratings: [Rating], metascore: String, imdbRating: String, imdbVotes: String, imdbID: String, type: String, boxOffice: String) {
        self.title = title
        self.year = year
        self.rated = rated
        self.released = released
        self.runtime = runtime
        self.genre = genre
        self.director = director
        self.writer = writer
        self.actors = actors
        self.plot = plot
        self.country = country
        self.awards = awards
        self.poster = poster
        self.posterData = posterData
        self.ratings = ratings
        self.metascore = metascore
        self.imdbRating = imdbRating
        self.imdbVotes = imdbVotes
        self.imdbID = imdbID
        self.type = type
        self.boxOffice = boxOffice

        self.runtime = timeFormatter(runtime: runtime)
    }

    private func timeFormatter(runtime: String) -> String {

        guard let minutesStr = runtime.components(separatedBy: " min").first else { return "" }

        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .abbreviated

        let minutes = Int(minutesStr)
        return formatter.string(from: .init(minute: minutes)) ?? ""

    }



}

// MARK: - Rating
struct Rating: Codable {
    let source, value: String

    enum CodingKeys: String, CodingKey {
        case source = "Source"
        case value = "Value"
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

//let localMovie = Movie(title: "Guardians of the Galaxy Vol. 2", year: "2017", rated: "PG-13", released: "05 May 2017", runtime: "136 min", genre: "Action, Adventure, Comedy", director: "James Gunn", writer: "James Gunn, Dan Abnett, Andy Lanning", actors: "Chris Pratt, Zoe Saldana, Dave Bautista", plot: "The Guardians struggle to keep together as a team while dealing with their personal family issues, notably Star-Lord's encounter with his father, the ambitious celestial being Ego.", country: "United States", awards: "Nominated for 1 Oscar. 15 wins & 60 nominations total", poster: "https://m.media-amazon.com/images/M/MV5BNjM0NTc0NzItM2FlYS00YzEwLWE0YmUtNTA2ZWIzODc2OTgxXkEyXkFqcGdeQXVyNTgwNzIyNzg@._V1_SX300.jpg", ratings: [Rating(source: "Internet Movie Database", value: "7.6/10"), Rating(source: "Rotten Tomatoes", value: "85%"), Rating(source: "Metacritic", value: "67/100")], metascore: "67", imdbRating: "7.6", imdbVotes: "712,189", imdbID: "tt3896198", type: "movie", boxOffice: "$389,813,101", response: "True")



//{"Title":"Guardians of the Galaxy Vol. 2","Year":"2017","Rated":"PG-13","Released":"05 May 2017","Runtime":"136 min","Genre":"Action, Adventure, Comedy","Director":"James Gunn","Writer":"James Gunn, Dan Abnett, Andy Lanning","Actors":"Chris Pratt, Zoe Saldana, Dave Bautista","Plot":"The Guardians struggle to keep together as a team while dealing with their personal family issues, notably Star-Lord's encounter with his father, the ambitious celestial being Ego.","Language":"English","Country":"United States","Awards":"Nominated for 1 Oscar. 15 wins & 60 nominations total","Poster":"https://m.media-amazon.com/images/M/MV5BNjM0NTc0NzItM2FlYS00YzEwLWE0YmUtNTA2ZWIzODc2OTgxXkEyXkFqcGdeQXVyNTgwNzIyNzg@._V1_SX300.jpg","Ratings":[{"Source":"Internet Movie Database","Value":"7.6/10"},{"Source":"Rotten Tomatoes","Value":"85%"},{"Source":"Metacritic","Value":"67/100"}],"Metascore":"67","imdbRating":"7.6","imdbVotes":"712,189","imdbID":"tt3896198","Type":"movie","DVD":"22 Aug 2017","BoxOffice":"$389,813,101","Production":"N/A","Website":"N/A","Response":"True"}
