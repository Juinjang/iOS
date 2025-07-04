//
//  MyNoteSearchViewController.swift
//  juinjang
//
//  Created by KimDongWoo on 3/29/25.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxRelay
import RxCocoa
import RxDataSources
import ReactorKit

final class MyNoteSearchViewController: BaseViewController, View {
    var disposeBag = DisposeBag()
    
    private let mainView = MyNoteSearchView()
    
    init(reactor: MyNoteSearchViewReactor) {
        super.init()
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        view = mainView
    }
    
    func bind(reactor: MyNoteSearchViewReactor) {
        reactor.state
            .map { [MyNoteSearchSectionModel(items: $0.list)] }
            .bind(to: mainView.searchCollectionView.rx.items(dataSource: createDataSource()))
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.isEmpty }
            .bind(to: mainView.searchCollectionView.rx.isHidden)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { !$0.isEmpty }
            .bind(to: mainView.emptyView.rx.isHidden )
            .disposed(by: disposeBag)
        
        mainView
            .navigationEventRelay
            .subscribe(with: self) { (self, action) in
                switch action {
                case .popButtonTap:
                    self.navigationController?.popViewController(animated: true)
                case .searchSummit(let keyword):
                    reactor.action.onNext(.searchSummitButtonTapped(keyword: keyword))
                default: break
                }
            }
            .disposed(by: disposeBag)
        
        mainView
            .cellEventRelay
            .subscribe(with: self) { (self, event) in
                switch event {
                case .cellTap(id: let noteId, title: let title):
                    self.navigationController?.pushViewController(
                        ImjangDetailViewController(
                            reactor: .init(
                                dependency: .init(
                                    id: noteId,
                                    title: title,
                                    sharedNoteRepository: SharedNoteRepository(),
                                    pencilShopRepository: PencilShopRepository()
                                )
                            )
                        ),
                        animated: true
                    )
                case .likeButtonTap(id: let noteId):
                    break
                }
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - CollectionView DataSource
extension MyNoteSearchViewController {
    private func createDataSource() -> RxCollectionViewSectionedReloadDataSource<MyNoteSearchSectionModel> {
        return .init(
            configureCell: { [weak self] _, collectionView, indexPath, item in
                guard let self = self else { return UICollectionViewCell() }
                return collectionView.dequeueReusableCell(
                    MyNoteCell.self,
                    for: indexPath
                ).then {
                    $0.bind(item, relay: self.mainView.cellEventRelay)
                }
            }
        )
    }
}
