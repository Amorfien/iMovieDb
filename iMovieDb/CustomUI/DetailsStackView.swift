//
//  DetailsStackView.swift
//  iMovieDb
//
//  Created by Pavel Grigorev on 03.06.2023.
//

import UIKit

enum DetailType: String, CaseIterable {
//    case .plot, .title, .country, .runtime, .genre, .director, .rated:
    case year
    case released
    case writer
    case actors
    case awards
    case metascore
    case imdbRating, imdbVotes
    case type
    case boxOffice
    case title
    case country
    case plot
    case runtime
    case genre
    case director
    case rated
}
final class DetailsStackView: UIStackView {


    private let leftLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
//        label.adjustsFontSizeToFitWidth = true
//        label.minimumScaleFactor = 0.7
        label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)

//        label.textColor = .red
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let rightLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .right
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
//        label.textColor = .systemGray
//        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
//        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    init(type: DetailType, fontSize: CGFloat, fontWeight: UIFont.Weight) {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.rightLabel.font = .systemFont(ofSize: fontSize, weight: fontWeight)
        self.leftLabel.text = type.rawValue.capitalized + ":"

//        distribution = .fillEqually
//        distribution = .fillProportionally

        
//        spacing = 8
        setup()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        self.addArrangedSubview(leftLabel)
        self.addArrangedSubview(rightLabel)

        NSLayoutConstraint.activate([
//            leftLabel.widthAnchor.constraint(equalToConstant: 64)
        ])
    }

    func fillText(_ text: String) {
        rightLabel.text = text
    }
}
