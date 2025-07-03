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
    
    private let cellEventRelay = PublishRelay<LookAroundEventType>()
    private let moreButtonTapRelay = PublishRelay<Void>()
    
    init(reactor: LookAroundSearchReactor) {
        super.init()
        self.reactor = reactor
        bindEvent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reactor?.action.onNext(.viewDidLoad)
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
                    reactor.action.onNext(.searchActive(isActive))
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
            .map({ [weak self] sections in
                if let notes = sections.last?.items as? [ExploreNoteModel] {
                    self?.mainView.setListEmpty(empty: notes.isEmpty)
                }
                return sections
            })
            .bind(to: mainView.searchResultCollectionView.rx.items(dataSource: searchResultDataSource))
            .disposed(by: disposeBag)
        
        reactor.state
            .map(\.isLastPage)
            .distinctUntilChanged()
            .compactMap { $0 }
            .bind(to: mainView.rx.isLastPage)
            .disposed(by: disposeBag)
    }
    
    func bindEvent() {
        guard let reactor = self.reactor else { return }
        
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
        
        cellEventRelay
            .compactMap { $0.tappedFilterItem }
            .bind(with: self) { owner, tappedFilters in
                owner.reactor?.action.onNext(
                    .filterTapped(
                        tappedFilters.sort,
                        tappedFilters.transactionType,
                        tappedFilters.saleType
                    )
                )
            }
            .disposed(by: disposeBag)
        
        moreButtonTapRelay
            .map { Reactor.Action.moreButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        cellEventRelay
            .compactMap { $0.tappedNote }
            .bind(with: self) { owner, noteInfo in
                let (sharedNoteId, buildingName) = noteInfo
                owner.showLookAroundDetailVC(sharedNoteId: sharedNoteId, buildingName: buildingName)
            }
            .disposed(by: disposeBag)
    }
    
    private func showLookAroundDetailVC(sharedNoteId: Int, buildingName: String) {
        let lookAroundDetailVC = ImjangDetailViewController(
            reactor: ImjangDetailViewReactor(
                dependency: .init(
                    id: sharedNoteId,
                    title: buildingName,
                    repository: SharedNoteRepository()
                )
            )
        )
        navigationController?.pushViewController(lookAroundDetailVC, animated: true)
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
        return RxCollectionViewSectionedReloadDataSource<LookAroundSearchResultSectionModel>(configureCell: { [weak self] dataSource, collectionView, indexPath, lookAroundImjangData in
            guard let self = self else { return UICollectionViewCell() }
            switch dataSource[indexPath] {
            case .imjangCountSection(let imjangCount):
                let cell = collectionView.dequeueReusableCell(LookAroundImjangCountCell.self, for: indexPath)
                cell.configureCell(imjangCount: imjangCount)
                return cell

            case .exploreNoteSection(let exploreNote):
                let cell = collectionView.dequeueReusableCell(LookAroundImjangCell.self, for: indexPath)
                cell.configureCell(exploreNote, relay: cellEventRelay)
                return cell
            }
        } , configureSupplementaryView: { [weak self] dataSource, collectionView, kind, indexPath in
            guard let self = self else { return UICollectionReusableView() }
            let section = dataSource.sectionModels[indexPath.section]
            switch section {
            case .exploreNoteSection(_, _):
                if kind == UICollectionView.elementKindSectionHeader {
                    guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: LookAroundFilterHeader.identifier, for: indexPath) as? LookAroundFilterHeader else {
                        return UICollectionReusableView()
                    }
                    
                    headerView.bind(relay: cellEventRelay)
                    
                    return headerView
                } else if kind == UICollectionView.elementKindSectionFooter {
                    guard let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: LookAroundMoreView.identifier, for: indexPath) as? LookAroundMoreView else {
                        return UICollectionReusableView()
                    }
                    
                    footerView.bind(
                        relay: self.moreButtonTapRelay
                    )
                    
                    return footerView
                }
                return UICollectionReusableView()
            default: return UICollectionReusableView()
            }
        })
    }
}
