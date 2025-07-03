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
        $0.register(LookAroundImjangCell.self)
        $0.register(
            LookAroundFilterHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader
        )
        $0.register(
            LookAroundMoreView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter
        )
        $0.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        $0.showsVerticalScrollIndicator = false
        $0.bounces = false
        $0.keyboardDismissMode = .onDrag
    }
    
    let searchEmptyView = SearchEmptyView().then {
        $0.isHidden = true
    }
    
    private let disposeBag = DisposeBag()
    let navigationEventRelay = PublishRelay<NavigationAction>()
    let cellEventTapRelay = PublishRelay<SearchKeywordCellEventType>()
    fileprivate var isLastPage: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        bind()
        hideKeyBoardWhenTappedView()
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
    
    func hideKeyBoardWhenTappedView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapHandler))
        tapGesture.cancelsTouchesInView = false
        addGestureRecognizer(tapGesture)
    }

    @objc func tapHandler() {
        endEditing(true)
    }
    
    override func configureHierarchy() {
        add(
            navigationView,
            searchKeywordCollectionView,
            searchResultCollectionView,
            searchEmptyView
        )
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
        
        searchEmptyView.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(-10)
            make.centerX.equalToSuperview()
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
        searchEmptyView.isHidden = true
    }
    
    func showSearchKeywordCollectionView(_ isShow: Bool) {
        searchKeywordCollectionView.isHidden = !isShow
        searchResultCollectionView.isHidden = isShow
        searchEmptyView.isHidden = isShow
    }
    
    func showSearchResultCollectionView(_ isEmpty: Bool) {
        searchKeywordCollectionView.isHidden = !isEmpty
        searchResultCollectionView.isHidden = isEmpty
        searchEmptyView.isHidden = true
    }
    
    func setListEmpty(empty: Bool) {
        print(#function, empty)
        searchEmptyView.isHidden = !empty
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

extension Reactive where Base: LookAroundSearchView {
    
    var isLastPage: Binder<Bool> {
        return Binder(base) { view, isLastPage in
            view.isLastPage = isLastPage
            view.searchResultCollectionView.reloadData()
        }
    }
}
