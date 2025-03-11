//
//  ImageButton.swift
//  juinjang
//
//  Created by KimDongWoo on 3/4/25.
//

import UIKit
import SnapKit

final class ImageButton: UIButton {
    override var contentMode: UIView.ContentMode {
        didSet {
            self.customImageView.contentMode = contentMode
        }
    }
    
    private var customImageView = UIImageView()
    
    var selectedImage: UIImage?
    
    var image: UIImage
    
    override var isSelected: Bool {
        didSet {
            self.updateImage()
        }
    }
    
    init(normalImage: UIImage,
         selectedImage: UIImage? = nil) {
        self.image = normalImage
        self.selectedImage = selectedImage
        super.init(frame: .zero)
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        self.customImageView.image = self.image.withRenderingMode(.alwaysTemplate)
        self.clipsToBounds = true
        self.backgroundColor = .clear
        self.addSubview(customImageView)
        self.customImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func updateImage() {
        if self.isSelected {
            self.customImageView.image = self.selectedImage?.withRenderingMode(.alwaysTemplate)
        } else {
            self.customImageView.image = self.image.withRenderingMode(.alwaysTemplate)
        }
    }
}
