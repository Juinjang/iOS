//
//  ShareGuideBannerCell.swift
//  juinjang
//
//  Created by 강동영 on 3/13/25.
//

import UIKit
final class ShareGuideBannerCell: UICollectionViewCell {
    private let bannerImageView: UIImageView = {
        let bannerView: UIImageView = .init(image: .DivideImjangNote.guideBanner)
        bannerView.contentMode = .scaleAspectFit
        return bannerView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        contentView.addSubview(bannerImageView)
        bannerImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
