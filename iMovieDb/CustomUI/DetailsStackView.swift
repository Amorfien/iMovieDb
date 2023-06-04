//
//  DetailsStackView.swift
//  iMovieDb
//
//  Created by Pavel Grigorev on 03.06.2023.
//

import UIKit

enum DetailType: String, CaseIterable {
    case year
    case released
    case writer
    case actors
    case awards
    case metascore
    case imdbRating
    case imdbVotes
    case type
    case boxOffice
    case totalSeasons
    case title
    case country
    case plot
    case runtime
    case genre
    case director
    case rated
}
final class DetailsStackView: UIStackView {

    private let leftLabel = UILabel(numberOfLines: 1, textAlignment: .left, fontSize: 14, fontWeight: .light)

    private let rightLabel = UILabel(numberOfLines: 0, textAlignment: .right, fontSize: 14, fontWeight: .regular)

    init(type: DetailType, fontSize: CGFloat, fontWeight: UIFont.Weight) {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.rightLabel.font = .systemFont(ofSize: fontSize, weight: fontWeight)
        self.leftLabel.text = type.rawValue.capitalized + ":"

        setup()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        leftLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        rightLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        self.addArrangedSubview(leftLabel)
        self.addArrangedSubview(rightLabel)
    }

    func fillText(_ text: String) {
        rightLabel.text = text
    }
}
