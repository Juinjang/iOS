//
//  MyNoteSearchView.swift
//  juinjang
//
//  Created by KimDongWoo on 3/29/25.
//

import UIKit
import SnapKit
import Then
import RxRelay
import RxSwift
import RxDataSources

final class MyNoteSearchView: BaseView {
    private let disposeBag = DisposeBag()
    private let navigationView = SearchNavigationView().then {
        $0.searchPlaceHolder = "건물명이나 주소를 검색해 보세요."
        $0.leftItem = [.pop]
    }
    
    lazy var searchCollectionView: UICollectionView = {
        return UICollectionView(frame: .zero, collectionViewLayout: createCompositionalLayout()).then {
            $0.register(MyNoteCell.self)
            $0.contentInset = .init(top: 4, left: 0, bottom: 0, right: 0)
            $0.showsVerticalScrollIndicator = false
        }
    }()
    
    let emptyView = MyNoteEmptyView().then {
        $0.configure(text: "일치하는 임장노트가 없어요")
    }
    
    let cellEventRelay = PublishRelay<MyNoteCellEventType>()
    let navigationEventRelay = PublishRelay<NavigationAction>()
    
    override func configureView() {
        super.configureView()
        
        navigationView
            .itemActionRelay
            .bind(to: navigationEventRelay)
            .disposed(by: disposeBag)
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        add(
            navigationView,
            searchCollectionView,
            emptyView
        )
    }
    
    override func configureLayout() {
        super.configureLayout()
        navigationView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.height.equalTo(44)
            $0.horizontalEdges.equalToSuperview()
        }
        
        searchCollectionView.snp.makeConstraints {
            $0.top.equalTo(navigationView.snp.bottom)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
        
        emptyView.snp.makeConstraints {
            $0.height.equalTo(269)
            $0.width.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
    }
}

// MARK: - CollectionView Layout
extension MyNoteSearchView {
    private func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(136)
            )
            
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = itemSize
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: groupSize,
                subitems: [item]
            )
            
            let section = NSCollectionLayoutSection(group: group).then {
                $0.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
                $0.interGroupSpacing = 0
            }
            
            return section
        }
        
        return layout
    }
}
