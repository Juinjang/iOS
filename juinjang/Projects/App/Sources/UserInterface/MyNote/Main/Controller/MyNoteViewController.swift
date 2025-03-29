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
    var disposeBag = DisposeBag()
    
    private let mainView = MyNoteView()
    
    private lazy var pageDataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<Void, MyNotePageModel>>(
        configureCell: { [weak self] _, collectionView, indexPath, item in
            guard let self = self else { return UICollectionViewCell() }
            
            return collectionView.dequeueReusableCell(
                MyNotePageCell.self,
                for: indexPath
            ).then {
                $0.bind(
                    page: item,
                    relay: self.mainView.pageCellEventRelay
                )
            }
        }
    )
    
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
            .bind(to: self.mainView.pageContainerCollectionView.rx.items(dataSource: pageDataSource))
            .disposed(by: disposeBag)
        
        reactor.state
            .filter { $0.showAlreadyLikedNotice }
            .subscribe(with: self) { (self, _) in
                print("Show Alert")
                
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - View Event
    func bindViewEvent() {
        mainView
            .navigationEventRelay
            .withUnretained(self)
            .subscribe { (self, action) in
                switch action {
                case .popButtonTap:
                    self.navigationController?.popViewController(animated: true)
                case .searchButtonTap:
                    print("push MyNoteSearchViewController")
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
        mainView.pageCellEventRelay
            .filter { !$0.isCellTap }
            .filter { $0 != MyNotePageEventType.shareButtonTap }
            .map { Reactor.Action.pageCellEventOccurred(event: $0) }
            .bind(to: reactor!.action)
            .disposed(by: disposeBag)
        
        mainView.pageCellEventRelay
            .compactMap { $0.cellTapId }
            .subscribe(with: self) { (self, id) in
                print("cell Selected \(id)")
            }
            .disposed(by: disposeBag)
        
        mainView.pageCellEventRelay
            .filter { $0 == .shareButtonTap }
            .subscribe(with: self) { (self, _) in
                print("노트 공유하러 가기 클릭")
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
