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
        case error(Error)
    }

    enum ViewInput {
        case loadButtonDidTap
        case movieDidSelect(Movie)
    }

//    weak var coordinator: BooksListCoordinator?
    var onStateDidChange: ((State) -> Void)?

    private(set) var state: State = .initial {
        didSet {
            onStateDidChange?(state)
        }
    }

    private let networkService: NetworkServiceProtocol

    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }

    func updateState(viewInput: ViewInput) {
        switch viewInput {
        case .loadButtonDidTap:
            state = .loading
            // убираем повторяющиеся элементы из списка
            let movieList = Array(Set(networkService.movieList))
            networkService.loadMovies(movieList: movieList) { moviesData in
                self.state = .loaded(movies: moviesData.sorted())
                print("🌞 ", moviesData.count)
            }
        case let .movieDidSelect(movie):
            print("test \(movie.title)")
//            coordinator?.pushBookViewController(forBook: book)
//            print(coordinator)
        }
    }
}
