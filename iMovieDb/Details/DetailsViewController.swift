//
//  DetailsViewController.swift
//  iMovieDb
//
//  Created by Pavel Grigorev on 30.05.2023.
//

import UIKit

final class DetailsViewController: UIViewController {

    private var movie: Movie

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    //  часть элементов создаются в глобальной области класса, остальные создаются в цикле при настройке UI
    private let posterImageView = UIImageView()
    private let verticalStack = UIStackView()
    private let countryStack = DetailsStackView(type: .country, fontSize: 14, fontWeight: .regular)
    private let timeStack = DetailsStackView(type: .runtime, fontSize: 14, fontWeight: .regular)
    private let genreStack = DetailsStackView(type: .genre, fontSize: 14, fontWeight: .regular)
    private let ratedStack = DetailsStackView(type: .rated, fontSize: 18, fontWeight: .bold)
    private let directorStack = DetailsStackView(type: .director, fontSize: 14, fontWeight: .regular)

    private let plotLabel = UILabel(numberOfLines: 0, fontSize: 18, fontWeight: .medium)

    init(movie: Movie) {
        self.movie = movie
        super.init(nibName: nil, bundle: nil)
    }
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.systemRed]
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.blue]
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        fillData()

    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        navigationController?.navigationBar.prefersLargeTitles = false
    }

    private func setupView() {
        self.title = movie.title
        view.backgroundColor = #colorLiteral(red: 0.7613402009, green: 0.9620329738, blue: 0.7515649199, alpha: 0.6984168046)//.systemGray4
        view.addSubview(scrollView)
        scrollView.backgroundColor = #colorLiteral(red: 0.7613402009, green: 0.9620329738, blue: 0.7515649199, alpha: 0.6984168046)

        let views: [UIView] = [posterImageView, verticalStack, plotLabel]
        views.forEach { view in
            scrollView.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }

        posterImageView.contentMode = .scaleAspectFit
        verticalStack.axis = .vertical
        verticalStack.distribution = .equalSpacing
//        verticalStack.spacing = 8
        verticalStack.translatesAutoresizingMaskIntoConstraints = false
        verticalStack.addArrangedSubview(countryStack)
        verticalStack.addArrangedSubview(timeStack)
        verticalStack.addArrangedSubview(genreStack)
        verticalStack.addArrangedSubview(directorStack)
        verticalStack.addArrangedSubview(ratedStack)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),

            posterImageView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: Resources.padding),
            posterImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Resources.padding),
            posterImageView.trailingAnchor.constraint(equalTo: view.centerXAnchor),
            posterImageView.heightAnchor.constraint(equalTo: posterImageView.widthAnchor, multiplier: 1.48),

            verticalStack.topAnchor.constraint(equalTo: posterImageView.topAnchor, constant: 8),
            verticalStack.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: Resources.padding),
            verticalStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Resources.padding),
            verticalStack.bottomAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: -8),

            plotLabel.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: Resources.padding),
            plotLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Resources.padding),
            plotLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Resources.padding),
        ])


        for (ind, line) in DetailType.allCases.enumerated() {
            switch line {
            case .plot, .title, .country, .runtime, .genre, .director, .rated:
                break
            default:
                let stack = DetailsStackView(type: line, fontSize: 14, fontWeight: line == .boxOffice ? .bold : .regular)
                stack.fillText(movie[line])
                scrollView.addSubview(stack)
                stack.leadingAnchor.constraint(equalTo: posterImageView.leadingAnchor, constant: 2 * Resources.padding).isActive = true
                stack.trailingAnchor.constraint(equalTo: verticalStack.trailingAnchor, constant: -2 * Resources.padding).isActive = true
                stack.topAnchor.constraint(equalTo: plotLabel.bottomAnchor, constant: Resources.padding + CGFloat(ind) * 44).isActive = true
                if ind == DetailType.allCases.count - 1 - 7 {
                    stack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -Resources.padding).isActive = true
                }
            }
        }

    }

    private func fillData() {

        if  let data = movie.posterData {
            self.posterImageView.image = UIImage(data: data)
        } else {
            self.posterImageView.image = UIImage(named: "defaultPoster")
        }
        plotLabel.text = movie.plot
        plotLabel.textAlignment = .justified
        countryStack.fillText(movie.country)
        timeStack.fillText(movie.runtime)
        genreStack.fillText(movie.genre)
        directorStack.fillText(movie.director)
        ratedStack.fillText(movie.rated)
    }
    

}

