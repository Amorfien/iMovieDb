//
//  MovieTableViewCell.swift
//  iMovieDb
//
//  Created by Pavel Grigorev on 30.05.2023.
//

import UIKit

final class MovieTableViewCell: UITableViewCell {

    static let cellIdentifier = "MovieTableViewCell"

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
//        label.textColor = .systemGray
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return label
    }()

    private let movieImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .systemFill
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        return imageView
    }()

    private let genreLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.font = UIFont.systemFont(ofSize: 10, weight: .light)
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textColor = .darkText
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        return label
    }()

    private let countryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        return label
    }()

    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        return label
    }()

    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)

        return label
    }()


    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {

        self.backgroundColor = .systemBackground

        let views: [UIView] = [titleLabel, movieImageView, genreLabel, descriptionLabel, countryLabel, timeLabel, ratingLabel]
        views.forEach { view in
            contentView.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            movieImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            movieImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            movieImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            movieImageView.widthAnchor.constraint(equalToConstant: 72),

            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: movieImageView.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),

            genreLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            genreLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
            genreLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),

            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: genreLabel.bottomAnchor, constant: 4),
//            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)

            countryLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            countryLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            countryLabel.widthAnchor.constraint(equalToConstant: 120),

            timeLabel.leadingAnchor.constraint(equalTo: countryLabel.trailingAnchor, constant: 40),
            timeLabel.bottomAnchor.constraint(equalTo: countryLabel.bottomAnchor),

            ratingLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: -8),
            ratingLabel.bottomAnchor.constraint(equalTo: countryLabel.bottomAnchor),
            
        ])

    }

    func fillData(with movie: Movie) {
        titleLabel.text = movie.title// + " lorum ipsum mlm sldk ml mdlkfm ;dm ;dlfm ;dflm dfm "
        genreLabel.text = movie.genre
        descriptionLabel.text = movie.plot
        movieImageView.image = UIImage(named: "poster")
        countryLabel.text = movie.country
        timeLabel.text = "2 h 10 m"
        ratingLabel.text = "⭐️ " + movie.imdbRating
    }

}
