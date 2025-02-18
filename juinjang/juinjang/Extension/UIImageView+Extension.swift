//
//  UIImageView+Extension.swift
//  juinjang
//
//  Created by 조유진 on 1/23/24.
//

import UIKit

extension UIImageView {
    func design(image: UIImage?=nil, contentMode: UIView.ContentMode = .scaleAspectFill, cornerRadius: CGFloat?=nil) {
        self.image = image
        self.contentMode = contentMode
        if let cornerRadius {
            self.layer.cornerRadius = cornerRadius
            self.clipsToBounds = true
        }
    }
}
