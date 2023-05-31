//
//  NetworkService.swift
//  iMovieDb
//
//  Created by Pavel Grigorev on 30.05.2023.
//

import Foundation

protocol NetworkServiceProtocol: AnyObject {
    var movieList: [String] { get }
    func loadMovies(movieList: [String], completion: @escaping ([Movie]) -> Void)
}

final class NetworkService: NetworkServiceProtocol {

    private let tunnel = "http://"
    private let server = "www.omdbapi.com/?i="
    private let movieId = "tt3896198"
    private let apiKey = "&apikey=5e8b6bfc"

//http://www.omdbapi.com/?i=tt3896198&apikey=5e8b6bfc

    var movieList = [
        "tt0120737",
        "tt0265086",
        "tt0093058",
        "tt0111161",
        "tt0068646",
        "tt0108052",
        "tt0120737",
        "tt0109830",
        "tt1375666",
        "tt0133093",
        "tt0120815",
        "tt0110357"
    ]


    // MARK: - URL session
    private func session(movieId: String, completion: @escaping (Result<Data, Error>) -> ()) {

        let urlStr = tunnel + server + movieId + apiKey
        guard let apiURL = URL(string: urlStr) else { return }
        URLSession.shared.dataTask(with: apiURL) { data, response, error in
            guard let data else {
                if let error {
                    completion(.failure(error))
                }
                return
            }
            completion(.success(data))
        }.resume()
    }

    let group = DispatchGroup()

    func loadMovies(movieList: [String], completion: @escaping ([Movie]) -> Void) {

        var dataList: [Movie] = []

        for movie in movieList {
            group.enter()

            session(movieId: movie) { result in
                switch result {
                case .success(let data):
                    do {
                        let movie = try JSONDecoder().decode(Movie.self, from: data)
                        dataList.append(movie)
                        print(dataList.count)

                    } catch {
                        print("❗️ Decode Error")
                    }
                case .failure(let error): print("‼️ Request Error ", error)
                }
                self.group.leave()
            }

        }

        group.notify(queue: .main, work: DispatchWorkItem(block: {
            completion(dataList)
            print("📣 Handled films ", dataList.count)
        }))

    }


    
}
