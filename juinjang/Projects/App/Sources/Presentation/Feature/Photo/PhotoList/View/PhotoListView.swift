//
//  PhotoListView.swift
//  juinjang
//
//  Created by KimDongWoo on 5/24/25.
//

import UIKit
import Then
import SnapKit
import RxSwift

final class PhotoListView: BaseView {
    private let navigationView = DefaultNavigationView().then {
        $0.leftItem = [.pop]
        $0.title = "사진 목록"
    }
    
    fileprivate lazy var collectionView: UICollectionView = {
        return UICollectionView(
            frame: .zero,
            collectionViewLayout: createLayout()
        ).then {
            $0.register(
                PhotoCell.self
            )
        }
    }()
    
    var exposedCollectionView: UICollectionView {
        return collectionView
    }
    
    override func configureView() {
        super.configureView()
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        
        add(navigationView, collectionView)
    }
    
    override func configureLayout() {
        super.configureLayout()
        
        navigationView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(navigationView.snp.bottom)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
    }
}

extension PhotoListView {
    private func createLayout() -> UICollectionViewCompositionalLayout {
        let spacing: CGFloat = 8
        let horizontalInset: CGFloat = 24
        let totalSpacing = spacing * 2 + horizontalInset * 2
        let itemWidth = (UIScreen.main.bounds.width - totalSpacing) / 3

        return UICollectionViewCompositionalLayout { _, _ in
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .absolute(itemWidth),
                heightDimension: .absolute(itemWidth)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(itemWidth)
            )
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 3)
            group.interItemSpacing = .fixed(spacing)

            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: horizontalInset, bottom: 0, trailing: horizontalInset)
            section.interGroupSpacing = spacing
            return section
        }
    }
}

// MARK: - Binders
extension Reactive where Base: PhotoListView {
    func bindPhotos(
        to dataSource: UICollectionViewDiffableDataSource<PhotoSection, PhotoCellItem>
    ) -> Binder<[PhotoCellItem]> {
        return Binder(base) { view, photos in
            let sectionedData: [PhotoSection: [PhotoCellItem]] = [.main: photos]
            view.collectionView.rx
                .bindSectionItems(
                    to: dataSource,
                    orderedBy: [.main]
                )
                .onNext(sectionedData)
        }
    }
}
