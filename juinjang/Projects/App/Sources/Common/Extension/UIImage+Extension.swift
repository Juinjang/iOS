//
//  UIImage+Extension.swift
//  juinjang
//
//  Created by KimDongWoo on 3/22/25.
//

import UIKit

extension UIImage {
    static var randomCardPlaceholderImage: UIImage {
        return [
            UIImage.cardPlaceholderVilla,
            UIImage.cardPlaceholderHouse,
            UIImage.cardPlaceholderApartment,
            UIImage.cardPlaceholderOfficetel
        ].randomElement()!
    }
}
