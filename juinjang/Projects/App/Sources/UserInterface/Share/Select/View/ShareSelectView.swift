//
//  ShareSelectView.swift
//  juinjang
//
//  Created by KimDongWoo on 4/26/25.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa

final class ShareSelectView: BaseView {
    let navigationView = DefaultNavigationView().then {
        $0.leftItem = [.pop]
    }
    
    fileprivate var isLastPage: Bool = false
    
    lazy var shareCollectionView: UICollectionView = {
        return UICollectionView(
            frame: .zero,
            collectionViewLayout: createLayout()
        ).then {
            $0.register(
                ShareSelectGuideCell.self,
                ShareSelectNoticeCell.self,
                ShareSelectCell.self
            )
            $0.register(
                ShareMoreView.self,
                forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter
            )
            $0.bounces = false
        }
    }()
    
    fileprivate let emptyView = ShareSelectEmptyView().then {
        $0.isHidden = true
    }
    let nextButton = FilledButton(title: "다음으로")
    
    override func configureHierarchy() {
        super.configureHierarchy()
        add(navigationView, shareCollectionView, emptyView)
    }
    
    override func configureLayout() {
        super.configureLayout()
        
        navigationView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
        }
        
        shareCollectionView.snp.makeConstraints {
            $0.top.equalTo(navigationView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        emptyView.snp.makeConstraints {
            $0.centerY.equalToSuperview().offset(47)
            $0.centerX.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(284)
        }
    }
}

extension ShareSelectView {
    private func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, _ in
            guard let section = ShareSelectSection(rawValue: sectionIndex) else { return nil }
            
            switch section {
            case .guide:
                return self.singleItemSection(height: 116)
            case .notice:
                return self.singleItemSection(height: 149)
            case .select:
                return self.selectSection(cellHeight: 148)
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
    
    private func selectSection(cellHeight: CGFloat) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(cellHeight)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(cellHeight)
        )
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        if !isLastPage {
            let footer = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .absolute(94)),
                elementKind: UICollectionView.elementKindSectionFooter,
                alignment: .bottom
            )
            
            section.boundarySupplementaryItems = [footer]
        }
        
        return section
    }
}

extension Reactive where Base: ShareSelectView {
    var navigationTitle: Binder<String> {
        return Binder(base) { view, nickname in
            view.navigationView.title = "\(nickname)님의 임장노트 나누기"
        }
    }
    
    var isActivatedNextButton: Binder<Bool> {
        return Binder(base) { view, isActivated in
            view.nextButton.isActivated = isActivated
        }
    }
    
    var isShowEmptyView: Binder<Bool> {
        return Binder(base) { view, isEmpty in
            view.emptyView.isHidden = !isEmpty
            
            if !isEmpty {
                view.add(view.nextButton)
                view.nextButton.snp.makeConstraints {
                    $0.height.equalTo(52)
                    $0.horizontalEdges.equalToSuperview().inset(24)
                    $0.bottom.equalTo(view.safeAreaLayoutGuide)
                }
                
                view.shareCollectionView.snp.remakeConstraints {
                    $0.top.equalTo(view.navigationView.snp.bottom)
                    $0.horizontalEdges.equalToSuperview()
                    $0.bottom.equalTo(view.nextButton.snp.top).offset(-16)
                }
            }
        }
    }
    
    var isLastPage: Binder<Bool> {
        return Binder(base) { view, isLastPage in
            view.isLastPage = isLastPage
            if isLastPage {
                view.shareCollectionView.reloadData()
            }
        }
    }
}
