//
//  ListViewController.swift
//  iMovieDb
//
//  Created by Pavel Grigorev on 30.05.2023.
//

import UIKit

final class ListViewController: UIViewController {

    private let viewModel: ListViewModelProtocol

    private var movies: [Movie] = [] {
        didSet {
            reload()
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
        return tableView
    }()

    private lazy var sortSegment: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["🔤", "📅", "⭐️"])
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.selectedSegmentTintColor = .systemYellow
        segmentedControl.widthAnchor.constraint(equalToConstant: 200).isActive = true
        segmentedControl.addTarget(self, action: #selector(sortButtonDidTap), for: .valueChanged)
        segmentedControl.isEnabled = false
        return segmentedControl
    }()

    init(viewModel: ListViewModelProtocol) {
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
        navigationController?.navigationBar.prefersLargeTitles = true
        self.title = "Hello, \(viewModel.user?.login ?? "NoName")!"
        let logoutButton = UIBarButtonItem(image: UIImage(systemName: "door.right.hand.open"), style: .done, target: self, action: #selector(logout))
        navigationItem.rightBarButtonItem = logoutButton

        navigationItem.titleView = sortSegment
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
                updateLoadingAnimation(isLoading: false)
            case .loading:
                updateTableViewVisibility(isHidden: true)
                updateLoadingAnimation(isLoading: true)
            case .loaded(let movies):
                DispatchQueue.main.async {
                    self.movies = movies
                    self.updateLoadingAnimation(isLoading: false)
                    self.updateTableViewVisibility(isHidden: false)
//                    self.reload()
                }
            case .error(let error):
                DispatchQueue.main.async {
                    self.alerting(title: "Error", message: error.rawValue, vc: self) { [weak self] _ in
                        self?.viewModel.updateState(viewInput: .alertClose)
                    }
                }
            }
        }
    }

    private func reload() {
        movieTableView.reloadData()
    }

    private func updateTableViewVisibility(isHidden: Bool) {
//        movieTableView.isHidden = isHidden
        sortSegment.isEnabled = !isHidden
        activityIndicator.isHidden = !isHidden
        downloadButton.isHidden = !isHidden
        navigationController?.navigationBar.prefersLargeTitles = isHidden
    }

    private func updateLoadingAnimation(isLoading: Bool) {
        isLoading ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
    }

    @objc private func downloadDidTap() {
        viewModel.updateState(viewInput: .loadButtonDidTap)
    }

    @objc private func logout() {
        viewModel.updateState(viewInput: .logOut)
        let loginViewController = LoginViewController(viewModel: LoginViewModel(userChecker: UserChecker()))
        navigationController?.setViewControllers([loginViewController], animated: true)
    }

    @objc private func sortButtonDidTap() {
        switch sortSegment.selectedSegmentIndex {
        case 0:
            self.movies.sort()
        case 1:
            self.movies.sort { $0.year > $1.year }
        default:
            self.movies.sort { $0.imdbRating > $1.imdbRating }
        }
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
        // обращение к вьюмодели
//        viewModel.updateState(viewInput: .movieDidSelect(movies[indexPath.row]))
        
        tableView.deselectRow(at: indexPath, animated: true)
        let detailsViewController = DetailsViewController(movie: movies[indexPath.row])
        navigationController?.pushViewController(detailsViewController, animated: true)
    }

}
