//
//  ImjangInfoDetailCell.swift
//  juinjang
//
//  Created by KimDongWoo on 4/10/25.
//

import UIKit
import Then
import SnapKit

final class ImjangDetailInfoCell: BaseCollectionViewCell {
    private let bannerView = PopularImjangNoteBannerView()
    private let imageContentView = MultiImageContentView()
    
    func bind(_ infoModel: ImjangDetailInfoModel) {
        bannerView.configure(for: infoModel.buyerCount)
        imageContentView.configure(for: infoModel)
        configureLayoutForCount(for: infoModel)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageContentView.prepareForReuse()
    }
    
    override func configureView() {
        super.configureView()
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        
        contentView.add(bannerView, imageContentView)
    }
    
    override func configureLayout() {
        super.configureLayout()
        
        bannerView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8)
            $0.height.equalTo(42)
            $0.horizontalEdges.equalToSuperview().inset(24.5)
        }
        
        imageContentView.snp.makeConstraints {
            $0.top.equalTo(bannerView.snp.bottom).offset(8)
            $0.height.equalTo(heightKeepingAspectRatio())
            $0.horizontalEdges.equalToSuperview()
        }
    }
    
    private func configureLayoutForCount(for model: ImjangDetailInfoModel) {
        if model.buyerCount < 10 {
            imageContentView.snp.remakeConstraints {
                $0.top.equalToSuperview().offset(8)
                $0.height.equalTo(heightKeepingAspectRatio())
                $0.horizontalEdges.equalToSuperview()
            }
            
            bannerView.removeFromSuperview()
        }
    }
}

extension ImjangDetailInfoCell {
    private func heightKeepingAspectRatio() -> CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        let originalWidth: CGFloat = 389
        let originalHeight: CGFloat = 171
        let aspectRatio = originalHeight / originalWidth

        return screenWidth * aspectRatio
    }
}
