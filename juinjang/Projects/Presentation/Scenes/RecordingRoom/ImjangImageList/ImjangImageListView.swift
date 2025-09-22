//
//  ImjangImageListView.swift
//  juinjang
//
//  Created by 조유진 on 12/26/24.
//

import UIKit
import SnapKit
import Then

final class ImjangImageListView: BaseView {
    let navigationView = DefaultNavigationView().then {
        $0.leftItem = [.pop]
        $0.rightItem = [.trash, .add]
        $0.title = "사진 목록"
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
        addSubview(navigationView)
        addSubview(noImageBackgroundView)
        addSubview(imageCollectionView)
        noImageBackgroundView.addSubview(noImageStackView)
        [galleryImageView, noImageMessageLabel].forEach {
            noImageStackView.addArrangedSubview($0)
        }
    }
    
    override func configureLayout() {
        navigationView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
        }
        
        imageCollectionView.snp.makeConstraints {
            $0.top.equalTo(navigationView.snp.bottom).offset(16)
            $0.bottom.equalTo(safeAreaLayoutGuide).offset(-16)
            $0.horizontalEdges.equalToSuperview().inset(24)
        }
        noImageBackgroundView.snp.makeConstraints {
            $0.top.equalTo(navigationView.snp.bottom)
            $0.horizontalEdges.bottom.equalToSuperview()
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
        galleryImageView.design(image: UIImage.Main.gallery, contentMode: .scaleAspectFit)
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
        navigationView.rightItem = isEmpty ? [.add] : [.trash, .add]
    }
    
    func setNavigationBarButtonHidden(_ isHidden: Bool) {
        navigationView.rightItem = isHidden ? [] : [.trash, .add]
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
                make.top.equalTo(navigationView.snp.bottom).offset(16)
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
                make.top.equalTo(navigationView.snp.bottom).offset(16)
                make.bottom.equalTo(safeAreaLayoutGuide).inset(16)
                make.horizontalEdges.equalToSuperview().inset(24)
            }
            
            setNavigationBarButtonHidden(false)
        }
    }
    
    func setIsSelectedIndexsEmptyUI(isEmpty: Bool) {
        navigationView.rightItem = isEmpty ? [] : [.trash, .add]
    }
}
