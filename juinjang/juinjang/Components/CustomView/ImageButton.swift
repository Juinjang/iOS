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
    
    var image: UIImage? {
        didSet {
            self.customImageView.image = image?.withRenderingMode(.alwaysTemplate)
        }
    }
    
    var selectedImage: UIImage?
    
    override var isSelected: Bool {
        didSet {
            if self.isSelected {
                self.customImageView.image = self.selectedImage
            } else {
                self.customImageView.image = self.image
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        self.clipsToBounds = true
        self.backgroundColor = .clear
        self.addSubview(customImageView)
        self.customImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
