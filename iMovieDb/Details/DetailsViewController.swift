//
//  DetailsViewController.swift
//  iMovieDb
//
//  Created by Pavel Grigorev on 30.05.2023.
//

import UIKit

final class DetailsViewController: UIViewController {

    // MARK: - Properties

    private var movie: Movie

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowOffset = .zero
        imageView.layer.shadowOpacity = 0.7
        imageView.layer.shadowRadius = 12
        return imageView
    }()

    private let verticalStack = UIStackView()
    private let plotLabel = UILabel(numberOfLines: 0, textAlignment: .justified, fontSize: 18, fontWeight: .medium)

    // MARK: - INIT
    
    init(movie: Movie) {
        self.movie = movie
        super.init(nibName: nil, bundle: nil)
    }
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        fillData()
    }

    // MARK: - Private methods

    private func setupView() {
        self.title = movie.title
        view.backgroundColor = Resources.Colors.detailsBackground
        view.addSubview(scrollView)
        scrollView.backgroundColor = Resources.Colors.detailsBackground

        let views: [UIView] = [posterImageView, verticalStack, plotLabel]
        views.forEach { view in
            scrollView.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }

        verticalStack.axis = .vertical
        verticalStack.distribution = .equalSpacing

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),

            posterImageView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: Resources.Sizes.padding),
            posterImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Resources.Sizes.padding),
            posterImageView.trailingAnchor.constraint(equalTo: view.centerXAnchor),
            posterImageView.heightAnchor.constraint(equalTo: posterImageView.widthAnchor, multiplier: 1.48),

            verticalStack.topAnchor.constraint(equalTo: posterImageView.topAnchor, constant: Resources.Sizes.inset),
            verticalStack.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: Resources.Sizes.padding),
            verticalStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Resources.Sizes.padding),
            verticalStack.bottomAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: -Resources.Sizes.inset),

            plotLabel.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: Resources.Sizes.padding),
            plotLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Resources.Sizes.padding),
            plotLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Resources.Sizes.padding),
        ])

        // автоматизированное создание однотипных элементов. Процесс разделён на две части:
        // - часть элементов в вертикальном стэке, равному по высоте размеру постера
        // - оставшиеся элементы помещённые на скролл-вью с равным отступом (не идеальный вариант с точки зрения дизайна. Просто автоматизация)
        for (ind, line) in DetailType.allCases.enumerated() {
            switch line {
            case .title, .plot:
                break
            case .country, .runtime, .genre, .director, .rated, .seasons:
                if movie[line] != "--" {
                    let stack = DetailsStackView(type: line, fontSize: line == .rated ? 18 : 14, fontWeight: line == .rated ? .bold : .regular)
                    stack.fillText(movie[line])
                    verticalStack.addArrangedSubview(stack)
                }
            default:
                let stack = DetailsStackView(type: line, fontSize: 14, fontWeight: line == .boxOffice ? .bold : .regular)
                stack.fillText(movie[line])
                scrollView.addSubview(stack)
                stack.leadingAnchor.constraint(equalTo: posterImageView.leadingAnchor, constant: 2 * Resources.Sizes.padding).isActive = true
                stack.trailingAnchor.constraint(equalTo: verticalStack.trailingAnchor, constant: -2 * Resources.Sizes.padding).isActive = true
                stack.topAnchor.constraint(equalTo: plotLabel.bottomAnchor, constant: Resources.Sizes.padding + CGFloat(ind) * 44).isActive = true
                if ind == DetailType.allCases.count - 1 - 8 { // 8 - количество минус исключения
                    stack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -Resources.Sizes.padding).isActive = true
                }
            }
        }

    }

    // Заполнение оставшихся неавтоматизированных элементов
    private func fillData() {

        if  let data = movie.posterData {
            self.posterImageView.image = UIImage(data: data)
        } else {
            self.posterImageView.image = UIImage(named: "defaultPoster")
        }
        plotLabel.text = movie.plot
    }
    

}

