//
//  MyNoteStopShareViewController.swift
//  juinjang
//
//  Created by KimDongWoo on 3/29/25.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxRelay
import RxDataSources
import ReactorKit

final class MyNoteStopShareViewController: BaseViewController, View {
    typealias StopShareSection = SectionModel<Void, MyNoteCellModel>
    var disposeBag = DisposeBag()
    
    private let mainView = MyNoteStopShareView()
    private let cellEventRelay = PublishRelay<MyNoteCellEventType>()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewEvent()
        bindCellEvent()
        reactor?.action.onNext(.viewDidLoad)
    }
    
    init(reactor: MyNoteStopShareViewReactor) {
        super.init()
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(reactor: MyNoteStopShareViewReactor) {
        reactor.state
            .map { [StopShareSection(model: (), items: $0.list)] }
            .bind(to: mainView.stopShareCollectionView.rx.items(dataSource: createDataSource()))
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.selectedList.count }
            .distinctUntilChanged()
            .bind(to: mainView.rx.selectedCount)
            .disposed(by: disposeBag)
    }
    
    private func bindViewEvent() {
        mainView
            .navigationView
            .itemActionRelay
            .subscribe(with: self) { (self, action) in
                switch action {
                case .popButtonTap:
                    self.navigationController?.popViewController(animated: true)
                default: break
                }
            }
            .disposed(by: disposeBag)
        
        mainView
            .removeButton.rx.throttleTap
            .subscribe(with: self) { (self, _) in
                self.reactor?.action.onNext(.removeButtonDidTap)
            }
            .disposed(by: disposeBag)
    }
    
    private func bindCellEvent() {
        cellEventRelay
            .subscribe(with: self) { (self, event) in
                self.reactor?.action.onNext(.cellEventOccurred(event: event))
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - Stop Share DataSource
extension MyNoteStopShareViewController {
    private func createDataSource() -> RxCollectionViewSectionedReloadDataSource<StopShareSection> {
        return .init(configureCell: { [weak self] _, collectionView, indexPath, item in
            guard let self = self else { return UICollectionViewCell() }
            return collectionView.dequeueReusableCell(
                MyNoteCell.self,
                for: indexPath
            ).then {
                $0.bind(item, relay: self.cellEventRelay)
            }
        })
    }
}
