//
//  Extensions.swift
//  NasaApp
//
//  Created by Ertürk Alan on 8.02.2023.
//

import UIKit
import Kingfisher

extension UIImageView {
    func fetchImage(from urlString: String) {
        if let url = URL(string: urlString) {
            self.kf.setImage(with: url)
        }
    }
}
