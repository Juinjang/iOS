//
//  ImageButton.swift
//  juinjang
//
//  Created by KimDongWoo on 3/4/25.
//

import UIKit
import SnapKit
import Kingfisher

final class ImageButton: UIButton {
    override var contentMode: UIView.ContentMode {
        didSet {
            self.customImageView.contentMode = contentMode
        }
    }
    
    private var customImageView = UIImageView()
    
    var selectedImage: UIImage? {
        didSet {
            self.commonInit()
        }
    }
    
    var image: UIImage? {
        didSet {
            self.commonInit()
        }
    }
    
    override var isSelected: Bool {
        didSet {
            self.updateImage()
        }
    }
    
    init(normalImage: UIImage? = nil,
         selectedImage: UIImage? = nil,
         isAlwaysTemplate: Bool = true) {
        self.image = normalImage
        self.selectedImage = selectedImage
        super.init(frame: .zero)
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        self.customImageView.image = self.image?.withRenderingMode(.alwaysTemplate)
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
            self.customImageView.image = self.image?.withRenderingMode(.alwaysTemplate)
        }
    }
}

extension ImageButton {
    func setImage(urlString: String?,
                  placeholder: UIImage? = nil) {
        guard let urlString = urlString,
              let url = URL(string: urlString) else {
            self.customImageView.image = placeholder
            return
        }

        self.customImageView.kf.setImage(
            with: url,
            placeholder: placeholder
        )
    }
}
