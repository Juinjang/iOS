//
//  ShareWriteView.swift
//  juinjang
//
//  Created by KimDongWoo on 5/1/25.
//

import UIKit
import SnapKit
import Then
import RxSwift

final class ShareWriteView: BaseView {
    let navigationView = DefaultNavigationView().then {
        $0.leftItem = [.pop]
    }
    
    lazy var writeCollectionView: UICollectionView = {
        return UICollectionView(
            frame: .zero,
            collectionViewLayout: createLayout()
        ).then {
            $0.register(
                ShareWriteNoticeCell.self,
                ShareWriteShareCell.self,
                ShareWriteBuildingCell.self,
                ShareWritePhotoCell.self,
                ShareWriteTimeCell.self,
                ShareWriteReviewCell.self
            )
        }
    }()
    
    fileprivate let uploadButton = FilledButton(title: "업로드하기")

    override func configureView() {
        super.configureView()
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        
        add(navigationView,
            writeCollectionView,
            uploadButton)
    }
    
    override func configureLayout() {
        super.configureLayout()
        
        navigationView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
        }
        
        writeCollectionView.snp.makeConstraints {
            $0.top.equalTo(navigationView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(uploadButton.snp.top).offset(-16)
        }
        
        uploadButton.snp.makeConstraints {
            $0.height.equalTo(52)
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
}

// MARK: - Create Layout
extension ShareWriteView {
    private func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, _ in
            guard let section = ShareWriteSection(rawValue: sectionIndex) else { return nil }
            
            switch section {
            case .notice:
                return self.singleItemSection(height: 80)
            case .share:
                return self.singleItemSection(height: 196)
            case .building:
                return self.singleItemSection(height: 98)
            case .photo:
                return self.singleItemSection(height: 111)
            case .time:
                return self.singleItemSection(height: 128)
            case .review:
                return self.singleItemSection(height: 360)
            }
        }
    }
    
    private func singleItemSection(height: CGFloat) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(height)
        )
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
}

// MARK: - Binders
extension Reactive where Base: ShareWriteView {
    var navigationTitle: Binder<String> {
        return Binder(base) { view, nickname in
            view.navigationView.title = "\(nickname)님의 임장노트 나누기"
        }
    }
    
    var isActivatedUploadButton: Binder<Bool> {
        return Binder(base) { view, bool in
            view.uploadButton.isActivated = bool
        }
    }
}
