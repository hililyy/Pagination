//
//  Extension.swift
//  Pagination
//
//  Created by 강조은 on 2023/10/23.
//

import UIKit
import Kingfisher

extension UIView {
    func addSubviews(_ views: [UIView]) {
        views.forEach { self.addSubview($0) }
    }
}

extension UIImageView {
    func setImage(urlString: String) {
        ImageCache.default.retrieveImage(forKey: urlString) { result in
            switch result {
            case .success(let value):
                // 캐시 존재
                if let image = value.image {
                    self.image = image
                } else {
                    //캐시 미 존재
                    guard let url = URL(string: urlString) else { return }
                    self.kf.setImage(with: url)
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
}
