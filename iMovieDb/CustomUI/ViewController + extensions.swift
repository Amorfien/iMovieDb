//
//  ViewController + extensions.swift
//  iMovieDb
//
//  Created by Pavel Grigorev on 04.06.2023.
//

import UIKit

extension UIViewController {

    /// Alert builder
    func alerting(title: String, message: String, vc: UIViewController, action: ((UIAlertAction) -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(.init(title: "Cancel", style: .cancel, handler: action))
        vc.present(alert, animated: true)
    }

}
