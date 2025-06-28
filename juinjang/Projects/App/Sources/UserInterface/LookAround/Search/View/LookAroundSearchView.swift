//
//  LookAroundSearchView.swift
//  juinjang
//
//  Created by 조유진 on 3/21/25.
//

import UIKit
import SnapKit
import RxRelay
import RxSwift

final class LookAroundSearchView: BaseView {
    private let navigationView = SearchNavigationView().then {
        $0.searchPlaceHolder = "임장노트 지역이나 제목을 입력해보세요."
        $0.leftItem = [.pop]
    }
    
    lazy var searchKeywordCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createKeywordCompositionalLayout()).then {
        $0.register(
            SearchKeywordHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader
        )
        $0.register(RecentSearchKeywordCell.self)
        $0.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        $0.showsVerticalScrollIndicator = false
        $0.isScrollEnabled = false
    }
        
    lazy var searchResultCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createImjangCompositionalLayout()).then {
        $0.register(LookAroundImjangCountCell.self)
        $0.register(LookAroundCell.self)
        $0.register(
            LookAroundFilterHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader
        )
        $0.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        $0.showsVerticalScrollIndicator = false
    }
    
    private let disposeBag = DisposeBag()
    let navigationEventRelay = PublishRelay<NavigationAction>()
    let cellEventTapRelay = PublishRelay<SearchKeywordCellEventType>()
    
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
        add(navigationView, searchKeywordCollectionView, searchResultCollectionView)
    }
    
    override func configureLayout() {
        navigationView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
        }
        
        searchKeywordCollectionView.snp.makeConstraints { make in
            make.top.equalTo(navigationView.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        searchResultCollectionView.snp.makeConstraints { make in
            make.top.equalTo(navigationView.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    override func configureView() {
        super.configureView()
    }
    
    func setSearchTextFieldBecomeResponder() {
        navigationView.setSearchTextFieldBecomeResponder()
    }
    
    func setSearchTextFieldText(_ text: String) {
        navigationView.setSearchTextFieldText(text)
    }
    
    func setCollectionViewSearchActive(_ isActive: Bool, isEmpty: Bool) {
        if isActive == false {
            showSearchResultCollectionView(!isActive)
        }
        if isEmpty {
            setCollectionViewSearchKeywordEmpty(isEmpty)
            return
        }
    }
    
    func setCollectionViewSearchKeywordEmpty(_ isEmpty: Bool) {
        searchKeywordCollectionView.isHidden = isEmpty
    }
    
    func showSearchKeywordCollectionView(_ isShow: Bool) {
        searchKeywordCollectionView.isHidden = !isShow
        searchResultCollectionView.isHidden = isShow
    }
    
    func showSearchResultCollectionView(_ isEmpty: Bool) {
        searchKeywordCollectionView.isHidden = !isEmpty
        searchResultCollectionView.isHidden = isEmpty
    }
}

enum LookAroundSearchResultSection: Int {
    case imjangCount
    case imjangList
}

extension LookAroundSearchView {
    
    private func createKeywordCompositionalLayout() -> UICollectionViewLayout {
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
    
    private func createImjangCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, environment -> NSCollectionLayoutSection? in
                   guard let self else { return nil }
           if let searchResultSection = LookAroundSearchResultSection(rawValue: sectionIndex) {
               let section: NSCollectionLayoutSection

               switch searchResultSection {
               case .imjangCount:
                   section = createImjangCountSection()
               case .imjangList:
                   section = createImjangListSection()
               }

               return section
           } else {
               return nil
           }
       }
       return layout
    }
    
    private func createImjangCountSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .absolute(40))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = itemSize
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 0, bottom: 0, trailing: 0)
        return section
    }

    private func createImjangListSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .absolute(136))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = itemSize
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
        section.boundarySupplementaryItems = [sectionHeader]
        return section
    }
}
