//
//  NetworkService.swift
//  iMovieDb
//
//  Created by Pavel Grigorev on 30.05.2023.
//

import Foundation

protocol NetworkServiceProtocol: AnyObject {
    func loadMovies(movieList: [String], completion: @escaping (Result<[Movie], ListError>) -> Void)
}

final class NetworkService: NetworkServiceProtocol {

    // MARK: - URL session
    private func movieSession(movieId: String, completion: @escaping (Result<Data, ListError>) -> Void) {

        let urlComponents: URLComponents = {
            let codedApiKey: [UInt8] = [0x35, 0x65, 0x38, 0x62, 0x36, 0x62, 0x66, 0x63]
            var url = URLComponents()
            url.scheme = "http"
            url.host = "www.omdbapi.com"
            url.path = "/"
            url.queryItems = [
                URLQueryItem(name: "i", value: movieId),
                URLQueryItem(name: "apikey", value: String(data: Data(codedApiKey), encoding: .utf8))
            ]
            return url
        }()

        guard let apiURL = urlComponents.url else {
            completion(.failure(.badURL))
            return
        }
        URLSession.shared.dataTask(with: apiURL) { data, response, error in
            guard let data else {
                if error != nil {
                    completion(.failure(.noData))
                }
                return
            }
            completion(.success(data))
        }.resume()
    }

    private func imageSession(urlString: String, completion: @escaping (Data?) -> Void) {
        guard let url = URL(string: urlString) else {
            print("⚔️ No URL")
            return
        }
        let session = URLSession.shared
        let task = session.dataTask(with: url) { data, response, error in
            guard let data else {
                completion(nil)
                return
            }
            completion(data)
        }
        task.resume()
    }

    // MARK: - Public method
    func loadMovies(movieList: [String], completion: @escaping (Result<[Movie], ListError>) -> Void) {

        let group = DispatchGroup()
        var dataList: [Movie] = []

        for movie in movieList {
            group.enter()

            movieSession(movieId: movie) { result in
                switch result {
                case .success(let data):
                    do {
                        var movie = try JSONDecoder().decode(Movie.self, from: data)
                        self.imageSession(urlString: movie.poster) { data in
                            movie.posterData = data
                            dataList.append(movie)
                            group.leave()
                        }
                    } catch {
                        print("❗️ Decode Error")
                        completion(.failure(.decodeError))
                    }
                case .failure(let error): print("‼️ Request Error ", error)
                    completion(.failure(error))
                }
            }

        }

        group.notify(queue: .global(), work: DispatchWorkItem(block: {
            sleep(1) // для наглядности
            completion(.success(dataList))
        }))

    }

}
