//
//  LookAroundSearchViewController.swift
//  juinjang
//
//  Created by 조유진 on 3/21/25.
//

import UIKit
import ReactorKit
import RxRelay
import RxDataSources

final class LookAroundSearchViewController: BaseViewController, View {
    
    var disposeBag = DisposeBag()
    
    private let mainView = LookAroundSearchView()
    
    private lazy var searchKeywordDataSource = configureSearchKeywordDataSource()
    private lazy var searchResultDataSource = configureSearchResultDataSource()
    
    init(reactor: LookAroundSearchReactor) {
        super.init()
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reactor?.action.onNext(.viewDidLoad)
        bindCellEvent()
    }
    
    func bindCellEvent() {
        mainView.cellEventTapRelay
            .compactMap { $0.deleteTapKeyword }
            .bind(with: self) { owner, keyword in
                owner.reactor?.action.onNext(.deleteKeywordButtonTapped(keyword: keyword))
            }
            .disposed(by: disposeBag)
        
        mainView.searchKeywordCollectionView.rx.modelSelected(String.self)
            .bind(with: self) { owner, keyword  in
                owner.mainView.showSearchResultCollectionView(false)
                owner.reactor?.action.onNext(.searchKeywordTapped(keyword: keyword))
                owner.mainView.setSearchTextFieldText(keyword)
            }
            .disposed(by: disposeBag)
    }
    
    func bind(reactor: LookAroundSearchReactor) {
        mainView.navigationEventRelay
            .subscribe(with: self) { (owner, navigationAction) in
                switch navigationAction {
                case .popButtonTap:
                    owner.popVC()
                    
                case .searchSummit(let keyword):
                    owner.mainView.showSearchResultCollectionView(false)
                    reactor.action.onNext(.searchSummitButtonTapped(keyword: keyword))
                    
                case .searchActive(let isActive):
                    let isEmpty = reactor.currentState.recentSearchKeywordList.isEmpty
                    owner.mainView.setCollectionViewSearchActive(isActive, isEmpty: isEmpty)
                default: break
                }
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map { [SearchKeywordSectionModel(items: $0.recentSearchKeywordList)] }
            .bind(to: mainView.searchKeywordCollectionView.rx.items(
                dataSource: configureSearchKeywordDataSource())
            )
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.recentSearchKeywordList.isEmpty }
            .asDriver(onErrorDriveWith: .empty())
            .drive(with: self) { owner, isEmpty in
                owner.mainView.setCollectionViewSearchKeywordEmpty(isEmpty)
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.searchResultList }
            .bind(to: mainView.searchResultCollectionView.rx.items(dataSource: searchResultDataSource))
            .disposed(by: disposeBag)
    }
    
    private func popVC() {
        navigationController?.popViewController(animated: true)
    }
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mainView.setSearchTextFieldBecomeResponder()
    }
}

extension LookAroundSearchViewController {
    private func configureSearchKeywordDataSource() -> RxCollectionViewSectionedReloadDataSource<SearchKeywordSectionModel> {
        return RxCollectionViewSectionedReloadDataSource<SearchKeywordSectionModel>(
        configureCell: { [weak self] _, collectionView, indexPath, item in
            guard let self else { return UICollectionViewCell() }
            
            return collectionView.dequeueReusableCell(RecentSearchKeywordCell.self, for: indexPath).then {
                $0.configureCell(
                    keyword: item,
                    relay: self.mainView.cellEventTapRelay
                )
            }
        } , configureSupplementaryView: { [weak self] dataSource, collectionView, item, indexPath in
            return collectionView.dequeueReusableSupplementaryView(SearchKeywordHeader.self, ofKind: UICollectionView.elementKindSectionHeader, for: indexPath).then { [weak self] in
                guard let self else { return }
                $0.configure()
                $0.removeAllButtonTappedRelay
                    .bind(with: self) { owner, _ in
                        owner.reactor?.action.onNext(.removeAllKeywordTapped)
                    }
                    .disposed(by: $0.disposeBag)
            }
        })
    }
    
    private func configureSearchResultDataSource() -> RxCollectionViewSectionedReloadDataSource<LookAroundSearchResultSectionModel> {
        return RxCollectionViewSectionedReloadDataSource<LookAroundSearchResultSectionModel>(configureCell: { dataSource, collectionView, indexPath, lookAroundImjangData in
            switch dataSource[indexPath] {
            case .imjangCountSection(let imjangCount):
                let cell = collectionView.dequeueReusableCell(LookAroundImjangCountCell.self, for: indexPath)
                cell.configureCell(imjangCount: imjangCount)
                return cell

            case .imjangListSection(let lookAroundImjang):
                let cell = collectionView.dequeueReusableCell(LookAroundCell.self, for: indexPath)
                cell.configureCell(lookAroundImjang)
                return cell
            }
        } , configureSupplementaryView: { dataSource, collectionView, _, indexPath in
            return collectionView.dequeueReusableSupplementaryView(LookAroundFilterHeader.self, ofKind: UICollectionView.elementKindSectionHeader, for: indexPath)
        })
    }
}
