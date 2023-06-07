//
//  MovieTableViewCell.swift
//  iMovieDb
//
//  Created by Pavel Grigorev on 30.05.2023.
//

import UIKit

final class MovieTableViewCell: UITableViewCell {

    static let cellIdentifier = "MovieTableViewCell"

    private let titleLabel = UILabel(numberOfLines: 2, textAlignment: .left, fontSize: 16, fontWeight: .semibold)

    private let movieImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let genreLabel = UILabel(numberOfLines: 1, textAlignment: .left, fontSize: 10, fontWeight: .light)

    private let descriptionLabel = UILabel(numberOfLines: 2, textAlignment: .left, fontSize: 12, fontWeight: .light)

    private let countryLabel = UILabel(numberOfLines: 1, textAlignment: .left, fontSize: 12, fontWeight: .regular)

    private let timeLabel = UILabel(numberOfLines: 1, textAlignment: .right, fontSize: 12, fontWeight: .medium)

    private let ratingLabel = UILabel(numberOfLines: 1, textAlignment: .right, fontSize: 16, fontWeight: .semibold)


    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()

    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {

        genreLabel.textColor = .secondaryLabel

        let views: [UIView] = [titleLabel, movieImageView, genreLabel, descriptionLabel, countryLabel, timeLabel, ratingLabel]
        views.forEach { contentView.addSubview($0) }

        NSLayoutConstraint.activate([
            movieImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Resources.Sizes.inset),
            movieImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Resources.Sizes.inset),
            movieImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Resources.Sizes.inset),
            movieImageView.widthAnchor.constraint(equalToConstant: 72),

            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: movieImageView.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),

            genreLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            genreLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
            genreLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),

            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: genreLabel.bottomAnchor, constant: Resources.Sizes.mini),

            countryLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            countryLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            countryLabel.trailingAnchor.constraint(equalTo: timeLabel.leadingAnchor, constant: -Resources.Sizes.inset),

            timeLabel.trailingAnchor.constraint(equalTo: ratingLabel.leadingAnchor, constant: -12),
            timeLabel.bottomAnchor.constraint(equalTo: countryLabel.bottomAnchor),
            timeLabel.widthAnchor.constraint(equalToConstant: Resources.Sizes.smallItem),

            ratingLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: -Resources.Sizes.inset),
            ratingLabel.bottomAnchor.constraint(equalTo: countryLabel.bottomAnchor),
            ratingLabel.widthAnchor.constraint(equalToConstant: Resources.Sizes.smallItem)
            
        ])

    }

    func fillData(with movie: Movie) {
        titleLabel.text = movie.title
        genreLabel.text = "\(movie.genre). \(movie.year) year"
        descriptionLabel.text = movie.plot
        if let data = movie.posterData {
            movieImageView.image = UIImage(data: data)
        } else {
            movieImageView.image = UIImage(named: "defaultPoster")
        }
        countryLabel.text = movie.country
        timeLabel.text = movie.runtime
        ratingLabel.text = "⭐️ " + movie.imdbRating
    }

}
