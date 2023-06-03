//
//  DetailsViewController.swift
//  iMovieDb
//
//  Created by Pavel Grigorev on 30.05.2023.
//

import UIKit

final class DetailsViewController: UIViewController {

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private let posterImageView = UIImageView()
    private let verticalStack = UIStackView()
    private let countryStack = DetailsStackView(type: .country, fontSize: 14)
    private let timeStack = DetailsStackView(type: .time, fontSize: 14)
    private let genreStack = DetailsStackView(type: .genre, fontSize: 14)
    private let ratedStack = DetailsStackView(type: .rated, fontSize: 18)
    private let directorStack = DetailsStackView(type: .director, fontSize: 14)

    private let descriptionStack = DetailsStackView(type: .plot, fontSize: 18)

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        navigationController?.navigationBar.prefersLargeTitles = true
//        self.title = "Guardians of the Galaxy Vol. 2"
//        navigationItem.title = "Guardians of the Galaxy Vol. 2"
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.orange]
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.orange]
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()

    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        navigationController?.navigationBar.prefersLargeTitles = false
    }

    private func setupView() {
        view.backgroundColor = .systemFill
        view.addSubview(scrollView)
        scrollView.backgroundColor = .lightGray

        let views: [UIView] = [posterImageView, verticalStack, descriptionStack]
        views.forEach { view in
            scrollView.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }

        posterImageView.contentMode = .scaleAspectFit
        verticalStack.axis = .vertical
        verticalStack.distribution = .equalSpacing
        verticalStack.spacing = 8
        verticalStack.translatesAutoresizingMaskIntoConstraints = false
        verticalStack.addArrangedSubview(countryStack)
        verticalStack.addArrangedSubview(timeStack)
        verticalStack.addArrangedSubview(genreStack)
        verticalStack.addArrangedSubview(directorStack)
        verticalStack.addArrangedSubview(ratedStack)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            posterImageView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: Resources.padding),
            posterImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Resources.padding),
            posterImageView.trailingAnchor.constraint(equalTo: view.centerXAnchor),
            posterImageView.heightAnchor.constraint(equalTo: posterImageView.widthAnchor, multiplier: 1.48),

            verticalStack.topAnchor.constraint(equalTo: posterImageView.topAnchor),
            verticalStack.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: Resources.padding),
            verticalStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Resources.padding),
            verticalStack.bottomAnchor.constraint(equalTo: posterImageView.bottomAnchor),

            descriptionStack.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 20),
            descriptionStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Resources.padding),
            descriptionStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Resources.padding),
            descriptionStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -Resources.padding)

//            descriptionLabel.topAnchor.constraint(equalTo: scrollView.topAnchor),
//            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            descriptionLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
    }

    func fillData(with movie: Movie) {
        self.title = movie.title
        if  let data = movie.posterData {
            self.posterImageView.image = UIImage(data: data)
        } else {
            self.posterImageView.image = UIImage(named: "defaultPoster")
        }
        descriptionStack.fillText(movie.plot)
        countryStack.fillText(movie.country)
        timeStack.fillText(movie.runtime)
        genreStack.fillText(movie.genre)
        directorStack.fillText(movie.director)
        ratedStack.fillText(movie.rated)
    }
    

}
///        self.title = title
//        self.year = year
///        self.rated = rated
//        self.released = released
//        self.runtime = runtime
//        self.genre = genre
//        self.director = director
//        self.writer = writer
//        self.actors = actors
//        self.plot = plot
//        self.country = country
//        self.awards = awards
//        self.poster = poster
//        self.posterData = posterData
//        self.ratings = ratings
//        self.metascore = metascore
//        self.imdbRating = imdbRating
//        self.imdbVotes = imdbVotes
//        self.imdbID = imdbID
//        self.type = type
//        self.boxOffice = boxOffice
