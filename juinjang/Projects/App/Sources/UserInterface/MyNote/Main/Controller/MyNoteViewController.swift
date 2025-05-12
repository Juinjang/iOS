//
//  MyNoteViewController.swift
//  juinjang
//
//  Created by KimDongWoo on 3/11/25.
//

import UIKit
import ReactorKit
import RxCocoa
import Then
import SnapKit
import RxDataSources

final class MyNoteViewController: BaseViewController, View {
    typealias MyNoteMainSection = SectionModel<Void, MyNotePageModel>
    var disposeBag = DisposeBag()
    
    private let mainView = MyNoteView()
    private let pageCellEventRelay = PublishRelay<MyNotePageEventType>()
    
    init(reactor: MyNoteViewReactor) {
        super.init()
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewEvent()
        bindPageCellEvent()
        reactor?.action.onNext(.viewDidLoad)
    }
    
    override func loadView() {
        view = mainView
    }
    
    func bind(reactor: MyNoteViewReactor) {
        reactor.state
            .map { state -> [SectionModel<Void, MyNotePageModel>] in
                return [SectionModel(model: (), items: state.pages)]
            }
            .bind(to: self.mainView.pageContainerCollectionView.rx.items(dataSource: createDataSource()))
            .disposed(by: disposeBag)
        
        reactor.state
            .compactMap(\.alreadyLikedNoteId)
            .subscribe(with: self) { (self, _) in
                let alertView = MyNoteAlertView()
                alertView.eventRelay
                    .map { MyNoteViewReactor.Action.alertEventOccurred(event: $0) }
                    .bind(to: reactor.action)
                    .disposed(by: self.disposeBag)
                self.present(alertView, animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - View Event
    func bindViewEvent() {
        mainView
            .navigationView
            .itemActionRelay
            .withUnretained(self)
            .subscribe { (self, action) in
                switch action {
                case .popButtonTap:
                    self.navigationController?.popViewController(animated: true)
                case .searchButtonTap:
                    let viewController = MyNoteSearchViewController(reactor: .init(dependency: .init(myNoteRepository: MyNoteRepository())))
                    self.navigationController?.pushViewController(viewController, animated: true)
                default: break
                }
            }
            .disposed(by: disposeBag)
        
        mainView
            .segmentedView
            .scrollSelectedRelay
            .map { Reactor.Action.categoryButtonDidTap($0) }
            .bind(to: reactor!.action)
            .disposed(by: disposeBag)
        
        mainView
            .segmentedView
            .buttonTapSelectedRelay
            .withUnretained(self)
            .subscribe { (self, index) in
                self.mainView.pageContainerCollectionView.scrollToItem(
                    at: IndexPath(item: index, section: 0),
                    at: .centeredHorizontally,
                    animated: true
                )
                self.reactor?.action.onNext(.categoryButtonDidTap(index))
            }
            .disposed(by: disposeBag)
        
        mainView
            .pageContainerCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    // MARK: - PageCellEvent
    func bindPageCellEvent() {
        pageCellEventRelay
            .filter { !$0.isCellTap }
            .filter { $0 != MyNotePageEventType.shareButtonTap }
            .map { Reactor.Action.pageCellEventOccurred(event: $0) }
            .bind(to: reactor!.action)
            .disposed(by: disposeBag)
        
        pageCellEventRelay
            .compactMap { $0.cellTapId }
            .subscribe(with: self) { (self, id) in
                print("cell Selected \(id)")
            }
            .disposed(by: disposeBag)
        
        pageCellEventRelay
            .filter { $0 == .shareButtonTap }
            .subscribe(with: self) { (self, _) in
                print("노트 공유하러 가기 클릭")
            }
            .disposed(by: disposeBag)
        
        pageCellEventRelay
            .filter { $0 == .stopShareButtonTap }
            .subscribe(with: self) { (self, _) in
                self.navigationController?.pushViewController(
                    MyNoteStopShareViewController(
                        reactor: .init(
                            dependency: .init(
                                myNoteRepository: MyNoteRepository()
                            )
                        )
                    ),
                    animated: true
                )
            }
            .disposed(by: disposeBag)
    }
}

extension MyNoteViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width,
                      height: collectionView.bounds.height)
    }
}

// MARK: - MyNote Page DataSource
extension MyNoteViewController {
    private func createDataSource() ->RxCollectionViewSectionedReloadDataSource<MyNoteMainSection> {
        return .init(configureCell: { [weak self] _, collectionView, indexPath, item in
            guard let self = self else { return UICollectionViewCell() }
            
            return collectionView.dequeueReusableCell(
                MyNotePageCell.self,
                for: indexPath
            ).then {
                $0.bind(
                    page: item,
                    relay: self.pageCellEventRelay
                )
            }
        })
    }
}
