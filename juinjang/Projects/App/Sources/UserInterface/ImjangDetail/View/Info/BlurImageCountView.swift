//
//  BlurImageCountView.swift
//  juinjang
//
//  Created by KimDongWoo on 4/13/25.
//

import UIKit
import Then
import SnapKit
import Kingfisher

final class BlurImageCountView: BaseView {
    private let blurImageView = BlurImageView()
    
    private let galleryBaseView = UIView()
    
    private let galleryIconView = UIImageView().then {
        $0.image = .Main.gallery
    }
    
    private let contentLabel = DSLabel(.body2).then {
        $0.fontColor = .mainWhite
    }
    
    func configure(for model: ImjangDetailInfoModel) {
        contentLabel.text = "사진 +\(model.imageCount)"
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        add(
            blurImageView,
            galleryBaseView.with(
                galleryIconView,
                contentLabel
            )
        )
    }
    
    override func configureLayout() {
        super.configureLayout()
        
        blurImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        galleryBaseView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        galleryIconView.snp.makeConstraints {
            $0.size.equalTo(24)
            $0.centerX.top.equalToSuperview()
        }
        
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(galleryIconView.snp.bottom)
            $0.height.equalTo(20)
            $0.centerX.bottom.equalToSuperview()
        }
    }
}

extension BlurImageCountView {
    func setImage(urlString: String?,
                          placeholder: UIImage? = nil) {
        guard let urlString = urlString,
              let url = URL(string: urlString) else {
            self.blurImageView.image = placeholder
            return
        }
        
        self.blurImageView.kf.setImage(
            with: url,
            placeholder: placeholder
        )
    }
}
