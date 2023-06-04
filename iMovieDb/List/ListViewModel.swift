//
//  ListViewModel.swift
//  iMovieDb
//
//  Created by Pavel Grigorev on 30.05.2023.
//

import Foundation

protocol ListViewModelProtocol: AnyObject {
    var onStateDidChange: ((ListViewModel.State) -> Void)? { get set }
    func updateState(viewInput: ListViewModel.ViewInput)
}

final class ListViewModel: ListViewModelProtocol {
    enum State {
        case initial
        case loading
        case loaded(movies: [Movie])
        case error(ListError)
    }

    enum ViewInput {
        case loadButtonDidTap
        case movieDidSelect(Movie)
        case logOut
    }

    enum ListError: String, Error {
        case decodeError
    }

    var onStateDidChange: ((State) -> Void)?

    private(set) var state: State = .initial {
        didSet {
            onStateDidChange?(state)
        }
    }

    private let networkService: NetworkServiceProtocol
    private let user: User?

    init(networkService: NetworkServiceProtocol, user: User?) {
        self.networkService = networkService
        self.user = user
    }

    func updateState(viewInput: ViewInput) {
        switch viewInput {
        case .loadButtonDidTap:
            state = .loading
            // убираем повторяющиеся элементы из списка
            let movieList = Array(Set(user!.movieList))
            networkService.loadMovies(movieList: movieList) { moviesData in
                self.state = .loaded(movies: moviesData.sorted())
//                print("🌞 ", moviesData.count)
            }
        case let .movieDidSelect(movie):
            print("test \(movie.title)")

        case .logOut:
            print("logoutout")
            UserSettings.isLogin = false
        }
    }
}
