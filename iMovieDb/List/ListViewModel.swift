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
            networkService.loadMovies { [weak self] result in
                switch result {
                case .success(let movies):
                    self?.state = .loaded(movies: movies)
//                    print("1")
                case .failure(let error):
                    self?.state = .error(error)
//                    print("2")
                }
            }
//            networkService.loadMovies { [weak self] movie in
//
//            }
        case let .movieDidSelect(movie):
            print("test \(movie.title)")
//            coordinator?.pushBookViewController(forBook: book)
//            print(coordinator)
        }
    }
}
