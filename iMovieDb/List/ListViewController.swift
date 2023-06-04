//
//  ListViewController.swift
//  iMovieDb
//
//  Created by Pavel Grigorev on 30.05.2023.
//

import UIKit

final class ListViewController: UIViewController {

    private let viewModel: ListViewModelProtocol

//    private let loginTitle: String

    private var movies: [Movie] = [] {
        didSet {
            print("☘️ ", movies.count)
        }
    }

    private lazy var downloadButton: UIButton = {
        let button = UIButton()
        button.setTitle("Download Movies", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(downloadDidTap), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()

    private lazy var movieTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.cellIdentifier)
        tableView.rowHeight = 128
        tableView.backgroundColor = .systemGray4
        tableView.showsVerticalScrollIndicator = false

        tableView.delegate = self
        tableView.dataSource = self
//        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    init(viewModel: ListViewModelProtocol) {
//        self.loginTitle = loginTitle
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupView()
        bindViewModel()
    }

    private func setupNavigation() {
        self.title = UserSettings.lastUser
        let logoutButton = UIBarButtonItem(image: UIImage(systemName: "door.right.hand.open"), style: .done, target: self, action: #selector(logout))
        navigationItem.rightBarButtonItem = logoutButton
    }
    private func setupView() {
        self.view = movieTableView
        movieTableView.addSubview(activityIndicator)
        movieTableView.addSubview(downloadButton)

        NSLayoutConstraint.activate([
            downloadButton.centerXAnchor.constraint(equalTo: movieTableView.centerXAnchor),
            downloadButton.topAnchor.constraint(equalTo: movieTableView.topAnchor, constant: 20),
            downloadButton.widthAnchor.constraint(equalToConstant: 200),
            
            activityIndicator.centerXAnchor.constraint(equalTo: movieTableView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: movieTableView.topAnchor, constant: 120),
        ])
    }

    func bindViewModel() {
        viewModel.onStateDidChange = { [weak self] state in
            guard let self = self else {
                return
            }
            switch state {
            case .initial:
                updateTableViewVisibility(isHidden: true)
            case .loading:
                updateTableViewVisibility(isHidden: true)
                updateLoadingAnimation(isLoading: true)
            case let .loaded(movies):
                DispatchQueue.main.async {
                    self.movies = movies
                    self.updateLoadingAnimation(isLoading: false)
                    self.updateTableViewVisibility(isHidden: false)
                    self.reload()
                }
            case .error:
                // Here we can show alert with error text
                ()
            }
        }
    }

    private func reload() {
        movieTableView.reloadData()
    }

    private func updateTableViewVisibility(isHidden: Bool) {
//        movieTableView.isHidden = isHidden
        activityIndicator.isHidden = !isHidden
        downloadButton.isHidden = !isHidden
    }

    private func updateLoadingAnimation(isLoading: Bool) {
        isLoading ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
    }

    @objc private func downloadDidTap() {
//        activityIndicator.startAnimating()
        viewModel.updateState(viewInput: .loadButtonDidTap)
    }

    @objc private func logout() {
        viewModel.updateState(viewInput: .logOut)
        let loginViewController = LoginViewController(viewModel: LoginViewModel(userChecker: UserChecker()))
        navigationController?.setViewControllers([loginViewController], animated: true)
    }

}

extension ListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.movies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.cellIdentifier, for: indexPath) as? MovieTableViewCell
        else { return MovieTableViewCell() }

        cell.backgroundColor = UIColor(named: indexPath.row % 2 == 0 ? "listEven" : "listOdd")
        cell.fillData(with: movies[indexPath.row])

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let detailsViewController = DetailsViewController(movie: movies[indexPath.row])
        navigationController?.pushViewController(detailsViewController, animated: true)
    }

}
