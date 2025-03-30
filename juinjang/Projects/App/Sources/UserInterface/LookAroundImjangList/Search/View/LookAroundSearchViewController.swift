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
                owner.showSearchResultVC(keyword)
            }
            .disposed(by: disposeBag)
    }
    
    func bind(reactor: LookAroundSearchReactor) {
        mainView.navigationEventRelay
            .bind(with: self) { (owner, navigationAction) in
                switch navigationAction {
                case .popButtonTap:
                    owner.popVC()
                case .searchSummit(let keyword):
                    owner.showSearchResultVC(keyword)
                    reactor.action.onNext(.searchSummitButtonTapped(keyword: keyword))
                default: break
                }
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map { [LookAroundSearchSectionModel(items: $0.recentSearchKeywordList)] }
            .bind(to: mainView.searchKeywordCollectionView.rx.items(
                dataSource: configureSearchKeywordDataSource())
            )
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.recentSearchKeywordList.isEmpty }
            .asDriver(onErrorDriveWith: .empty())
            .drive(with: self) { owner, isEmpty in
                owner.mainView.showSearchKeywordCollectionView(isEmpty)
            }
            .disposed(by: disposeBag)
        
      
    }
    
    private func showSearchResultVC(_ searchText: String) {
        print(#function, searchText)
    }
    
    private func popVC() {
        navigationController?.popViewController(animated: true)
    }
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mainView.setSearchTextFiledBecomeResponder()
    }
}

extension LookAroundSearchViewController {
    private func configureSearchKeywordDataSource() -> RxCollectionViewSectionedReloadDataSource<LookAroundSearchSectionModel> {
        return RxCollectionViewSectionedReloadDataSource<LookAroundSearchSectionModel>(
            configureCell: { [weak self] _, collectionView, indexPath, item in
                guard let self else { return UICollectionViewCell() }
                
                return collectionView.dequeueReusableCell(RecentSearchKeywordCell.self, for: indexPath).then {
                    $0.configureCell(
                        keyword: item,
                        relay: self.mainView.cellEventTapRelay
                    )
                }
            } , configureSupplementaryView: { pageDataSource, collectionView, _, indexPath in
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
}
