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
                ShareWritePeriodCell.self,
                ShareWriteReviewCell.self
            )
        }
    }()
    
    fileprivate var sectionIdentifiers: [ShareWriteSection] = []
    
    private let uploadNoticeLabel = DSLabel(.body2).then {
        $0.fontSize = 13
        $0.fontColor = .gray400
        $0.fontAlignment = .center
        $0.text = "공유 후에는 체크리스트 수정이 제한돼요"
    }
    
    fileprivate let uploadButton = FilledButton(title: "업로드하기")
    
    override func configureView() {
        super.configureView()
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        
        add(navigationView,
            writeCollectionView,
            uploadNoticeLabel,
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
            $0.bottom.equalTo(uploadNoticeLabel.snp.top).offset(-22)
        }
        
        uploadNoticeLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(uploadButton.snp.top).offset(-13)
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
    fileprivate func configureLayout(with sections: [ShareWriteSection]) {
        guard sections != sectionIdentifiers else { return }
        self.sectionIdentifiers = sections
        writeCollectionView.setCollectionViewLayout(createLayout(), animated: false)
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, _ in
            guard let section = self.sectionIdentifiers[safe: sectionIndex] else { return nil }
            
            switch section {
            case .notice:
                return self.singleItemSection(height: 80)
            case .share:
                return self.singleItemSection(height: 196)
            case .building:
                return self.singleItemSection(height: 98)
            case .photo:
                return self.singleItemSection(height: 111)
            case .period:
                return self.singleItemSection(height: 128)
            case .review:
                return self.singleItemSection(height: 483)
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
    
    var configureVisibleSections: Binder<[ShareWriteSection: [ShareWriteBaseCellItem]]> {
        return Binder(base) { view, sectionItems in
            view.configureLayout(
                with: [
                    .notice,
                    .share,
                    .building,
                    .photo,
                    .period,
                    .review
                ].filter { sectionItems[$0] != nil }
            )
        }
    }
}
