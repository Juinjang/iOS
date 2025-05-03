//
//  ObtainedPencilView.swift
//  juinjang
//
//  Created by 조유진 on 4/16/25.
//

import UIKit
import Then
import SnapKit

final class ObtainedPencilView: BaseView {
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: configureCollectionViewLayout())
    private let emptyObtainedView = EmptyObtainedView().then {
        $0.isHidden = true
    }
    
    private let pencilUsageGuideView = PencilUsageGuideView()
    
    override func configureHierarchy() {
        add(collectionView, emptyObtainedView, pencilUsageGuideView)
    }
    
    override func configureLayout() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        emptyObtainedView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(107)
            make.centerX.equalToSuperview()
        }
        
        pencilUsageGuideView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    override func configureView() {
        collectionView.register(ObtainedPencilCell.self)
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
        emptyObtainedView.isHidden = !empty
    }
}

extension ObtainedPencilView {
    private func configureCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, environment -> NSCollectionLayoutSection? in
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .absolute(60))
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

            let section = NSCollectionLayoutSection(group: group)
            return section
        }
        return layout
    }
}
