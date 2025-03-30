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
        bindCellEvent()
        reactor?.action.onNext(.viewDidLoad)
    }
    
    func bindCellEvent() {
        mainView.deleteKeywordTappedRelay
            .bind(with: self) { owner, _ in
                print("asdf")
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
                        relay: self.mainView.deleteKeywordTappedRelay
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
