//
//  DetailsStackView.swift
//  iMovieDb
//
//  Created by Pavel Grigorev on 03.06.2023.
//

import UIKit

final class DetailsStackView: UIStackView {

    enum DetailType: String {
        case country
        case description
        case year
        case time
        case director
        case actor
        case genre
        case rated
    }

    private let leftLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
//        label.textColor = .red
//        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
//        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let rightLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .right
//        label.textColor = .systemGray
//        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
//        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    init(type: DetailType, fontSize: CGFloat) {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.leftLabel.font = .systemFont(ofSize: 14, weight: .light)
        self.rightLabel.font = .systemFont(ofSize: fontSize, weight: .regular)
        self.leftLabel.text = type.rawValue.capitalized + ":"

//        distribution = .fillEqually

        
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
            leftLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.33)
        ])
    }

    func fillText(_ text: String) {
        rightLabel.text = text
    }
}
