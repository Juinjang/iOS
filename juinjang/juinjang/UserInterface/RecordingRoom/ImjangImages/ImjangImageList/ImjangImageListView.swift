//
//  ImjangImageListView.swift
//  juinjang
//
//  Created by 조유진 on 12/26/24.
//

import UIKit

final class ImjangImageListView: BaseView {
    // 네비게이션바
    let backButtonItem = UIButton(frame: CGRect(x: 0, y: 0, width: 24, height: 24)).then { button in
        button.setImage(ImageStyle.arrowLeft, for: .normal)
    }
    
    let deleteImageButtonItem = UIButton(frame: CGRect(x: 0, y: 0, width: 24, height: 24)).then { button in
        button.setImage(ImageStyle.trash, for: .normal)
        button.tintColor = .gray450
    }
    
    let addImageButtonItem = UIButton(frame: CGRect(x: 0, y: 0, width: 24, height: 24)).then { button in
        button.setImage(ImageStyle.add, for: .normal)
        button.tintColor = .gray450
    }
    
    // 이미지 없을 때 표시할 컴포넌트들
    private let noImageBackgroundView = UIView()
    private let noImageStackView = UIStackView()
    private let galleryImageView = UIImageView()
    private let noImageMessageLabel = UILabel()
    
    lazy var imageCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    private lazy var deleteBackgroundView = UIView()
    lazy var deleteImageButton = UIButton()
    
    override func configureHierarchy() {
        addSubview(noImageBackgroundView)
        addSubview(imageCollectionView)
        noImageBackgroundView.addSubview(noImageStackView)
        [galleryImageView, noImageMessageLabel].forEach {
            noImageStackView.addArrangedSubview($0)
        }
    }
    
    override func configureLayout() {
        imageCollectionView.snp.makeConstraints {
            $0.verticalEdges.equalTo(safeAreaLayoutGuide).inset(16)
            $0.horizontalEdges.equalToSuperview().inset(24)
        }
        noImageBackgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        noImageStackView.snp.makeConstraints {
            $0.center.equalTo(noImageBackgroundView)
            $0.width.equalTo(200)
        }
        
        galleryImageView.snp.makeConstraints {
            $0.size.equalTo(117)
        }
        
        noImageMessageLabel.snp.makeConstraints {
            $0.height.equalTo(52)
        }
    }
    
    override func configureView() {
        super.configureView()
        
        noImageStackView.design(axis: .vertical, spacing: 16)
        galleryImageView.design(image: ImageStyle.gallery, contentMode: .scaleAspectFit)
        noImageMessageLabel.design(text: "아직 등록된 사진이 없어요\n사진을 추가해 볼까요?",
                                   textColor: .gray400,
                                   font: .pretendard(size: 16, weight: .medium),
                                   numberOfLines: 2)
        noImageMessageLabel.setLineSpacing(spacing: 4)
        noImageMessageLabel.textAlignment = .center
        
        imageCollectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.identifier)
        imageCollectionView.allowsMultipleSelection = true
    }
}

extension ImjangImageListView {
    func setEmptyLayout(_ isEmpty: Bool) {
        imageCollectionView.isHidden = isEmpty ? true : false
        noImageBackgroundView.isHidden = isEmpty ? false : true
        deleteImageButtonItem.tintColor = isEmpty ? .null : .gray450
        deleteImageButtonItem.isEnabled = !isEmpty
    }
    
    func setNavigationBarButtonHidden(_ isHidden: Bool) {
        deleteImageButtonItem.isHidden = isHidden
        addImageButtonItem.isHidden = isHidden
    }
    
    func updateDeleteUI(_ isRemoveMode: Bool) {
        if isRemoveMode {
            
            addSubview(deleteBackgroundView)
            deleteBackgroundView.addSubview(deleteImageButton)
            
            deleteImageButton.design(
                title: "삭제하기",
                font: .pretendard(size: 16, weight: .semiBold),
                tintColor: .mainWhite,
                backgroundColor: .null,
                cornerRadius: 10
            )
            deleteImageButton.isEnabled = false
            
            deleteBackgroundView.snp.makeConstraints { make in
                make.horizontalEdges.equalToSuperview()
                make.bottom.equalToSuperview()
            }
            
            deleteImageButton.snp.makeConstraints { make in
                make.horizontalEdges.equalToSuperview().inset(24)
                make.bottom.equalTo(safeAreaLayoutGuide)
                make.top.equalToSuperview().inset(12)
                make.height.equalTo(52)
            }
            
            imageCollectionView.snp.remakeConstraints { make in
                make.top.equalTo(safeAreaLayoutGuide).inset(16)
                make.horizontalEdges.equalToSuperview().inset(24)
                make.bottom.equalTo(deleteBackgroundView.snp.top)
            }
        } else {
            self.subviews.forEach { subView in
                if subView == deleteBackgroundView || subView == deleteImageButton {
                    subView.removeFromSuperview()
                }
            }
            
            imageCollectionView.snp.remakeConstraints { make in
                make.verticalEdges.equalTo(safeAreaLayoutGuide).inset(16)
                make.horizontalEdges.equalToSuperview().inset(24)
            }
            
            setNavigationBarButtonHidden(false)
        }
    }
    
    func setIsSelectedIndexsEmptyUI(isEmpty: Bool) {
        deleteImageButton.isEnabled = !isEmpty
        deleteImageButton.backgroundColor = isEmpty ? .null : .gray500
    }
}
