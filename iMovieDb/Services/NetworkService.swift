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

    private let tunnel = "http://"
    private let server = "www.omdbapi.com/?i="

    // obfuscation API-key
    private let coded: [UInt8] = [0x26, 0x61, 0x70, 0x69, 0x6b, 0x65, 0x79, 0x3d, 0x35, 0x65, 0x38, 0x62, 0x36, 0x62, 0x66, 0x63]

    // MARK: - URL session
    private func movieSession(movieId: String, completion: @escaping (Result<Data, ListError>) -> Void) {
        let data = Data(coded)
        let apiKey = String(data: data, encoding: .utf8) ?? ""
        let urlStr = tunnel + server + movieId + apiKey
        guard let apiURL = URL(string: urlStr) else {
            completion(.failure(.badURL))
            return
        }
        let request = URLRequest(url: apiURL,cachePolicy: .reloadIgnoringCacheData)
        URLSession.shared.dataTask(with: request) { data, response, error in
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
