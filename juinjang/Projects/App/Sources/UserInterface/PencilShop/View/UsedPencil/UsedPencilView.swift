//
//  UsedPencilView.swift
//  juinjang
//
//  Created by 조유진 on 4/16/25.
//

import UIKit

final class UsedPencilView: BaseView {
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: configureCollectionViewLayout())
    private let emptyPencilView = EmptyPencilView(description: "아직 사용한 연필이 없어요").then {
        $0.isHidden = true
    }
    private let pencilUsageGuideView = PencilUsageGuideView()
    
    override func configureHierarchy() {
        add(collectionView, emptyPencilView, pencilUsageGuideView)
    }
    
    override func configureLayout() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        emptyPencilView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(209)
            make.centerX.equalToSuperview()
        }
        
        pencilUsageGuideView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    override func configureView() {
        collectionView.register(UsedPencilCell.self)
        collectionView.register(
            PencilGuideHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader
        )
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .mainWhite
        collectionView.isHidden = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: pencilUsageGuideView.frame.size.height, right: 0)
    }
    
    func setListEmpty(empty: Bool) {
        collectionView.isHidden = empty
        emptyPencilView.isHidden = !empty
    }
}

extension UsedPencilView {
    private func configureCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, environment -> NSCollectionLayoutSection? in
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .absolute(88))
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

            let section = NSCollectionLayoutSection(group: group)

            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
              layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                 heightDimension: .absolute(44)),
              elementKind: UICollectionView.elementKindSectionHeader,
              alignment: .top
            )
            section.boundarySupplementaryItems = [sectionHeader]
            return section
        }
        return layout
    }
}
