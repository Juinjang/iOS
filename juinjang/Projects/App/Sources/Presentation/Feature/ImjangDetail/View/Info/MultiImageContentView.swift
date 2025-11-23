//
//  MultiImageContentView.swift
//  juinjang
//
//  Created by KimDongWoo on 4/12/25.
//

import UIKit
import Then
import SnapKit
import Kingfisher
import RxSwift
import RxRelay

final class MultiImageContentView: BaseView {
    private let mainImageButton = ExpandableImageButton().then {
        $0.roundCorners(cornerRadius: 5, corner: .all)
        $0.backgroundColor = .gray2
        $0.isHiddenExpandButton = true
    }
    
    private let secondImageButton = ExpandableImageButton().then {
        $0.roundCorners(cornerRadius: 5, corner: .all)
        $0.backgroundColor = .gray2
        $0.isHiddenExpandButton = true
    }
    
    private let thirdImageButton = ExpandableImageButton().then {
        $0.roundCorners(cornerRadius: 5, corner: .all)
        $0.backgroundColor = .gray2
        $0.isHiddenExpandButton = true
    }
    
    private let imageCountView = BlurImageCountView().then {
        $0.roundCorners(cornerRadius: 5, corner: .all)
    }
    
    private let checkCountView = GradientCheckCountView().then {
        $0.roundCorners(cornerRadius: 5, corner: .all)
    }
    
    private var disposeBag = DisposeBag()
    
    func configure(for model: ImjangDetailInfoModel,
                   relay: PublishRelay<ImjangDetailInfoCellEvent>) {
        model.isBuyer
        ? applyImageLayoutForBuyer(for: model)
        : applyImageLayout(for: model)
        
        model.isBuyer
        ? configureImageSectionForBuyer(for: model)
        : configureImageSection(for: model)
        
        imageCountView.configure(for: model)
        checkCountView.configure(for: model)
        
        [mainImageButton,
         secondImageButton,
         thirdImageButton].enumerated().forEach { index, button in
            button.rx.throttleTap
                .subscribe(with: self) { (self, _) in
                    relay.accept(.expandImageButtonTap(index: index))
                }
                .disposed(by: disposeBag)
        }
    }
    
    func prepareForReuse() {
        disposeBag = DisposeBag()
        
        [mainImageButton,
         secondImageButton,
         thirdImageButton].forEach {
            $0.snp.removeConstraints()
            $0.isHiddenExpandButton = true
        }
        [imageCountView,
         checkCountView].forEach {
            $0.snp.removeConstraints()
        }
    }
    
    override func configureView() {
        super.configureView()
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        add(
            mainImageButton,
            secondImageButton,
            thirdImageButton,
            imageCountView,
            checkCountView
        )
    }
    
    override func configureLayout() {
        super.configureLayout()
    }
}

// MARK: - Setup Layout for Default
extension MultiImageContentView {
    private func configureImageSection(for model: ImjangDetailInfoModel) {
        switch model.images.count {
        case 0, 1:
            if let firstImageUrlString = model.images.first {
                mainImageButton.setImage(
                    urlString: firstImageUrlString,
                    placeholder: PropertyType(rawValue: model.propertyType)?.detailImage
                )
            } else {
                mainImageButton.setImage(
                    urlString: nil,
                    placeholder: PropertyType(rawValue: model.propertyType)?.detailImage
                )
            }
        default:
            mainImageButton.setImage(
                urlString: model.images[0],
                placeholder: PropertyType(rawValue: model.propertyType)?.detailImage
            )
            
            imageCountView.setImage(
                urlString: model.images[1],
                placeholder: PropertyType(rawValue: model.propertyType)?.detailImage
            )
        }
    }
    
    private func applyImageLayout(for model: ImjangDetailInfoModel) {
        switch model.images.count {
        case 0, 1:
            setupLayoutForSingleImage()
        default:
            setupLayoutForMultipleImages()
        }
    }
    
    private func setupLayoutForSingleImage() {
        mainImageButton.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.left.equalToSuperview().offset(24)
            $0.width.equalTo(scaledMainWidth())
        }
        
        checkCountView.snp.makeConstraints {
            $0.left.equalTo(mainImageButton.snp.right).offset(8)
            $0.right.equalToSuperview().inset(24)
            $0.verticalEdges.equalToSuperview()
        }
    }
    
    private func setupLayoutForMultipleImages() {
        mainImageButton.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.left.equalToSuperview().offset(24)
            $0.width.equalTo(scaledMainWidth())
        }
        
        imageCountView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.height.equalTo(scaledSecondHeight())
            $0.left.equalTo(mainImageButton.snp.right).offset(8)
            $0.right.equalToSuperview().inset(24)
        }
        
        checkCountView.snp.makeConstraints {
            $0.top.equalTo(imageCountView.snp.bottom).offset(8)
            $0.left.equalTo(mainImageButton.snp.right).offset(8)
            $0.right.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview()
        }
    }
}

// MARK: - Setup Layout for Buyer
extension MultiImageContentView {
    private func configureImageSectionForBuyer(for model: ImjangDetailInfoModel) {
        switch model.images.count {
        case 0, 1:
            if let firstImageUrlString = model.images.first {
                mainImageButton.isHiddenExpandButton = false
                mainImageButton.setImage(
                    urlString: firstImageUrlString,
                    placeholder: PropertyType(rawValue: model.propertyType)?.detailImage
                )
            } else {
                mainImageButton.setImage(
                    urlString: nil,
                    placeholder: PropertyType(rawValue: model.propertyType)?.detailImage
                )
            }
        case 2:
            secondImageButton.isHiddenExpandButton = false
            zip(
                [mainImageButton,
                 secondImageButton],
                model.images.prefix(2)
            ).forEach { button, imageUrl in
                button.setImage(
                    urlString: imageUrl,
                    placeholder: PropertyType(rawValue: model.propertyType)?.detailImage
                )
            }
        default:
            thirdImageButton.isHiddenExpandButton = false
            zip(
                [mainImageButton,
                 secondImageButton,
                 thirdImageButton],
                model.images.prefix(3)
            ).forEach { button, imageUrl in
                button.setImage(
                    urlString: imageUrl,
                    placeholder: PropertyType(rawValue: model.propertyType)?.detailImage
                )
                
            }
        }
    }
    
    private func applyImageLayoutForBuyer(for model: ImjangDetailInfoModel) {
        checkCountView.isHidden = true
        imageCountView.isHidden = true
        switch model.images.count {
        case 0, 1:
            setupBuyerLayoutForSingleImage()
        case 2:
            setupBuyerLayoutForTwoImages()
        default:
            setupBuyerLayoutForMultipleImages()
        }
    }
    
    private func setupBuyerLayoutForSingleImage() {
        mainImageButton.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(24)
        }
    }
    
    private func setupBuyerLayoutForTwoImages() {
        mainImageButton.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.left.equalToSuperview().offset(24)
            $0.width.equalTo(scaledMainWidth())
        }
        
        secondImageButton.snp.makeConstraints {
            $0.left.equalTo(mainImageButton.snp.right).offset(8)
            $0.right.equalToSuperview().inset(24)
            $0.verticalEdges.equalToSuperview()
        }
    }
    
    private func setupBuyerLayoutForMultipleImages() {
        mainImageButton.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.left.equalToSuperview().offset(24)
            $0.width.equalTo(scaledMainWidth())
        }
        
        secondImageButton.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.equalTo(mainImageButton.snp.right).offset(8)
            $0.right.equalToSuperview().inset(24)
            $0.height.equalTo(scaledSecondHeight())
        }
        
        thirdImageButton.snp.makeConstraints {
            $0.top.equalTo(secondImageButton.snp.bottom).offset(8)
            $0.left.equalTo(mainImageButton.snp.right).offset(8)
            $0.right.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview()
        }
    }
}

// MARK: - Setup Scale
extension MultiImageContentView {
    private func scaledMainWidth() -> CGFloat {
        let screenWidth: CGFloat = UIScreen.main.bounds.width
        let originalWidth: CGFloat = 389
        let scaledReferenceWidth: CGFloat = 225
        let ratio = scaledReferenceWidth / originalWidth
        return screenWidth * ratio
    }
    
    private func scaledSecondHeight() -> CGFloat {
        let screenWidth: CGFloat = UIScreen.main.bounds.width
        let originalWidth: CGFloat = 389
        let originalHeight: CGFloat = 89
        let scale = screenWidth / originalWidth
        return originalHeight * scale
    }
}
