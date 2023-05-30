//
//  ListViewController.swift
//  iMovieDb
//
//  Created by Pavel Grigorev on 30.05.2023.
//

import UIKit

final class ListViewController: UIViewController {

    private let loginTitle: String

    private lazy var movieTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.cellIdentifier)

        tableView.delegate = self
        tableView.dataSource = self
//        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    init(loginTitle: String) {
        self.loginTitle = loginTitle
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupView()
    }

    private func setupNavigation() {
        self.title = loginTitle
        let logoutButton = UIBarButtonItem(image: UIImage(systemName: "door.right.hand.open"), style: .done, target: self, action: #selector(logout))
        navigationItem.rightBarButtonItem = logoutButton
    }
    private func setupView() {
        self.view = movieTableView
    }

    @objc private func logout() {
        let loginViewController = LoginViewController()
        navigationController?.setViewControllers([loginViewController], animated: true)
    }

}

extension ListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }


}
