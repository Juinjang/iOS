//
//  LookAroundView.swift
//  juinjang
//
//  Created by 조유진 on 2/27/25.
//

import UIKit
import RxSwift

final class LookAroundView: BaseView {
    let navigationView = DefaultNavigationView().then {
        $0.title = "임장노트 둘러보기"
        $0.leftItem = [.pop]
        $0.rightItem = [.search]
    }
    
    lazy var collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: createCollectionViewLayout(isListEmpty: false))
    
    fileprivate var isLastPage: Bool = false
    
    override func configureHierarchy() {
        addSubview(navigationView)
        addSubview(collectionView)
    }
    
    override func configureLayout() {
        navigationView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(44)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(navigationView.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    override func configureView() {
        super.configureView()
        collectionView.backgroundColor = .mainWhite
        collectionView.register(
            LookAroundContentCell.self,
            forCellWithReuseIdentifier: LookAroundContentCell.identifier
        )
        collectionView.register(
            SelectAreaCell.self,
            forCellWithReuseIdentifier: SelectAreaCell.identifier
        )
        collectionView.register(
            LookAroundImjangCountCell.self,
            forCellWithReuseIdentifier: LookAroundImjangCountCell.identifier
        )
        collectionView.register(
            LookAroundFilterHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: LookAroundFilterHeader.identifier
        )
        collectionView.register(
            LookAroundImjangCountCell.self,
            forCellWithReuseIdentifier: LookAroundImjangCountCell.identifier
        )
        collectionView.register(
            LookAroundImjangCell.self,
            forCellWithReuseIdentifier: LookAroundImjangCell.identifier
        )
        collectionView.register(
            LookAroundMoreView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter
        )
    }
}

enum LookAroundImjangSection: Int {
    case contents
    case selectArea
    case imjangCount
    case imjangList
}

extension LookAroundView {
    func createCollectionViewLayout(isListEmpty: Bool) -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, environment -> NSCollectionLayoutSection? in
            guard let self = self else { return nil }
            if let weatherSection = LookAroundImjangSection(rawValue: sectionIndex) {
                let section: NSCollectionLayoutSection
                
                switch weatherSection {
                case .contents:
                    section = createContentsSection()
                case .selectArea:
                    section = createSelectAreaSection()
                case .imjangCount:
                    section = createImjangCountSection()
                case .imjangList:
                    section = createImjangListSection(isListEmpty: isListEmpty)
                }
       
                return section
            } else {
                return nil
            }
        }
        layout.register(
        LookAroundEmptyBackground.self,
          forDecorationViewOfKind: "section-background-element-kind"
        )
        return layout
    }
    
    private func createContentsSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(87))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        group.interItemSpacing = .fixed(12)

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 24, bottom: 16, trailing: 24)
        return section
    }
    
    private func createSelectAreaSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(48))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 22, bottom: 8, trailing: 22)
        return section
    }
    
    private func createImjangCountSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(40))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }
    
    private func createImjangListSection(isListEmpty: Bool) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(136))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)

        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
          layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                             heightDimension: .absolute(43)),
          elementKind: UICollectionView.elementKindSectionHeader,
          alignment: .top
        )
        
        sectionHeader.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 0, bottom: 0, trailing: 0)
        sectionHeader.pinToVisibleBounds = true
        sectionHeader.zIndex = 2
        
        if isListEmpty {
            let decoration = NSCollectionLayoutDecorationItem.background(
                elementKind: "section-background-element-kind"
            )
            decoration.contentInsets = NSDirectionalEdgeInsets(top: 63, leading: 0, bottom: 0, trailing: 0)
            section.decorationItems = [decoration]
        }
        
        var footer: NSCollectionLayoutBoundarySupplementaryItem?
        
        if !isLastPage {
            footer = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .absolute(94)),
                elementKind: UICollectionView.elementKindSectionFooter,
                alignment: .bottom
            )
        }
        
        if let footer {
            section.boundarySupplementaryItems = [sectionHeader, footer]
        } else {
            section.boundarySupplementaryItems = [sectionHeader]
        }
        
        return section
    }
}

extension Reactive where Base: LookAroundView {
    
    var isLastPage: Binder<Bool> {
        return Binder(base) { view, isLastPage in
            view.isLastPage = isLastPage
            view.collectionView.reloadData()
        }
    }
}
