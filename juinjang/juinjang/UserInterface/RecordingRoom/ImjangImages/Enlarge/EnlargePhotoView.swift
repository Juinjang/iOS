//
//  Enlarge.swift
//  juinjang
//
//  Created by 조유진 on 12/26/24.
//

import UIKit

final class EnlargePhotoView: BaseView {
    let closeButton = UIButton()
    lazy var photoCollectionView = UICollectionView(frame: .zero, collectionViewLayout: configureCollectionViewFlowLayout())
    let photoStatusLabel = PaddingLabel()
    
    override func configureHierarchy() {
        addSubview(closeButton)
        addSubview(photoCollectionView)
        addSubview(photoStatusLabel)
    }
    
    override func configureLayout() {
        closeButton.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(4)
            $0.leading.equalToSuperview().offset(22)
            $0.size.equalTo(12)
        }
        
        photoCollectionView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalTo(closeButton.snp.bottom).offset(12)
            $0.bottom.equalTo(safeAreaLayoutGuide).offset(-12)
        }
        
        photoStatusLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(46)
            $0.height.equalTo(26)
        }
    }
    
    override func configureView() {
        super.configureView()
        
        photoCollectionView.backgroundColor = .mainWhite
        photoCollectionView.decelerationRate = .fast
        photoCollectionView.isPagingEnabled = false
        photoCollectionView.showsHorizontalScrollIndicator = false
        photoCollectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        
        closeButton.design(image: ImageStyle.x, tintColor: .black ,backgroundColor: .mainWhite)
        
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            photoStatusLabel.layer.cornerRadius = photoStatusLabel.bounds.height / 2
            photoStatusLabel.clipsToBounds = true
        }
        
        photoStatusLabel.design(text: "/", textColor: .mainWhite, font: .pretendard(size: 16, weight: .regular))
        photoStatusLabel.backgroundColor = .black.withAlphaComponent(0.4)
    }
}

extension EnlargePhotoView {
    func setCurrentIndex(index: Int, totalCount: Int) {
        photoStatusLabel.text = "\(index)/\(totalCount)"
    }
    
    private func configureCollectionViewFlowLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 64)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        return layout
    }
}
