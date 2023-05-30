//
//  NetworkService.swift
//  iMovieDb
//
//  Created by Pavel Grigorev on 30.05.2023.
//

import Foundation

protocol NetworkServiceProtocol: AnyObject {
    func loadMovies(completion: @escaping ((Result<[Movie], Error>) -> Void))
}

final class NetworkService: NetworkServiceProtocol {

    private let tunnel = "http://"
    private let server = "www.omdbapi.com/?i="
    private let movieId = "tt3896198"
    private let apiKey = "&apikey=5e8b6bfc"

//http://www.omdbapi.com/?i=tt3896198&apikey=5e8b6bfc

    private let localMovies: [Movie] = [localMovie, localMovie, localMovie, localMovie]

    func loadMovies(completion: @escaping ((Result<[Movie], Error>) -> Void)) {
//        DispatchQueue.global().async {
//            sleep(3)
//            completion(.success(self.localMovies))
//            print("success")
//        }

        let movieList = [
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
        session(movieId: movieList[Int.random(in: 0..<movieList.count)]) { result in
            switch result {
            case .success(let data):
                do {
                    let movie = try JSONDecoder().decode(Movie.self, from: data)
                    completion(.success([movie]))
                } catch {}
            case .failure(let error): print(error)
            }
        }


    }


    // MARK: - URL session
    private func session(movieId: String, completion: @escaping (Result<Data, Error>) -> ()) {

        let urlStr = tunnel + server + movieId + apiKey
        // поддержка кириллицы в URL
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

    
}
