//
//  LookAroundSearchView.swift
//  juinjang
//
//  Created by 조유진 on 3/21/25.
//

import UIKit
import RxRelay
import RxSwift

final class LookAroundSearchView: BaseView {
    private let navigationView = SearchNavigationView().then {
        $0.searchPlaceHolder = "임장노트 지역이나 제목을 입력해보세요."
        $0.leftItem = [.pop]
    }
    
    lazy var searchKeywordCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createCompositionalLayout()).then {
        $0.backgroundColor = .mainWhite
        $0.register(SearchKeywordHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader)
        $0.register(RecentSearchKeywordCell.self)
        $0.contentInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        $0.showsVerticalScrollIndicator = false
        $0.isScrollEnabled = false
    }
    
    private let disposeBag = DisposeBag()
    let navigationEventRelay = PublishRelay<NavigationAction>()
    let deleteKeywordTappedRelay = PublishRelay<SearchKeywordCellEventType>()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        bind()
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        navigationView
               .itemActionRelay
               .bind(to: navigationEventRelay)
               .disposed(by: disposeBag)
    }
    
    override func configureHierarchy() {
        add(navigationView, searchKeywordCollectionView)
    }
    
    override func configureLayout() {
        navigationView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(44)
        }
        
        searchKeywordCollectionView.snp.makeConstraints { make in
            make.top.equalTo(navigationView.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    override func configureView() {
        super.configureView()
    }
    
    func setSearchTextFiledBecomeResponder() {
        navigationView.setSearchTextFiledBecomeResponder()
    }
}

extension LookAroundSearchView {
    private func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(50)
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
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(54)
                ),
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )

            section.boundarySupplementaryItems = [sectionHeader]
            
            return section
        }
        return layout
    }
}
