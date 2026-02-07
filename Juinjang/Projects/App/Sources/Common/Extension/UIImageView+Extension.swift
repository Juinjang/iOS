//
//  UIImageView+Extension.swift
//  juinjang
//
//  Created by 조유진 on 1/23/24.
//

import UIKit
import Kingfisher

extension UIImageView {
    func design(image: UIImage?=nil,
                contentMode: UIView.ContentMode = .scaleAspectFill,
                cornerRadius: CGFloat?=nil) {
        self.image = image
        self.contentMode = contentMode
        if let cornerRadius {
            self.layer.cornerRadius = cornerRadius
            self.clipsToBounds = true
        }
    }
}

extension UIImageView {
    /// URL에서 이미지를 가져오면서 지정한 크기로 리사이징하여 보여줍니다.
    ///   - targetSize: 최종 리사이징 크기 (pt 단위)
    ///   - contentMode: 비율 유지 방식 (`.aspectFill` 또는 `.aspectFit`), 기본은 `.aspectFill`
    func setImage(
        with urlString: String?,
        placeholder: UIImage? = nil,
        resizedTo targetSize: CGSize
    ) {
        guard let urlString = urlString,
              let url = URL(string: urlString) else {
            self.image = placeholder
            return
        }
        
        // Kingfisher 프로세서 설정
        let processor = ResizingImageProcessor(
            referenceSize: targetSize,
            mode: self.contentMode == .scaleAspectFill ? .aspectFill : .aspectFit
        )
        
        self.kf.setImage(
            with: url,
            placeholder: placeholder,
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .cacheOriginalImage
            ]
        )
    }
}
