//
//  UILabel + Extensions.swift
//  iMovieDb
//
//  Created by Pavel Grigorev on 04.06.2023.
//

import UIKit

extension UILabel {

    convenience init(numberOfLines: Int, fontSize: CGFloat, fontWeight: UIFont.Weight) {
        self.init()
        self.numberOfLines = numberOfLines
        self.font = .systemFont(ofSize: fontSize, weight: fontWeight)
        self.translatesAutoresizingMaskIntoConstraints = false
    }



}
