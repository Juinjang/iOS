//
//  ShareSelectViewController.swift
//  juinjang
//
//  Created by KimDongWoo on 4/26/25.
//

import UIKit
import Then
import SnapKit
import ReactorKit
import RxSwift
import RxRelay

final class ShareSelectViewController: BaseViewController, View {
    typealias DataSource = UICollectionViewDiffableDataSource<ShareSelectSection, ShareSelectBaseCellItem>
    var disposeBag: DisposeBag = DisposeBag()
    private let mainView = ShareSelectView()
    private let selectCellRelay = PublishRelay<String>()
    private let moreButtonTapRelay = PublishRelay<Void>()
    private var dataSource: DataSource!

    init(reactor: ShareSelectViewReactor) {
        super.init()
        configureDataSource()
        self.reactor = reactor
        bindEvent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reactor?.action.onNext(.viewDidLoad)
    }
    
    func bind(reactor: ShareSelectViewReactor) {
        reactor.state
            .map(\.nickname)
            .distinctUntilChanged()
            .bind(to: mainView.rx.navigationTitle)
            .disposed(by: disposeBag)
        
        reactor.state
            .map(\.isActivatedNextButton)
            .distinctUntilChanged()
            .bind(to: mainView.rx.isActivatedNextButton)
            .disposed(by: disposeBag)
        
        reactor.state
            .map(\.sectionItems)
            .distinctUntilChanged()
            .bind(to: mainView.shareCollectionView.rx.bindSectionItems(
                to: dataSource,
                orderedBy: [.guide, .notice, .select]
            ))
            .disposed(by: disposeBag)
        
        reactor.state
            .map(\.isShowEmptyView)
            .distinctUntilChanged()
            .skip(1)
            .compactMap { $0 }
            .bind(to: mainView.rx.isShowEmptyView)
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
        
        moreButtonTapRelay
            .map { Reactor.Action.moreButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        selectCellRelay
            .map { Reactor.Action.cellDidTap(id: $0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        mainView
            .navigationView
            .itemActionRelay
            .subscribe(with: self) { (self, event) in
                switch event {
                case .popButtonTap:
                    self.navigationController?.navigationBar.isHidden = false
                    self.navigationController?.popViewController(animated: true)
                default: break
                }
            }
            .disposed(by: disposeBag)
        
        mainView
            .nextButton.rx.throttleTap
            .subscribe(with: self) { (self, _) in
                if let selectedCellItem = self.reactor?.currentState.selectItem {
                    let viewController = ShareWriteViewController(
                        reactor: .init(
                            dependecy: .init(
                                selectedModel: selectedCellItem.model,
                                noteRepository: NoteRepository(),
                                userRepository: UserRepository(),
                                sharedNoteRepository: SharedNoteRepository()
                            )
                        )
                    )
                    
                    self.navigationController?.pushViewController(
                        viewController,
                        animated: true
                    )
                }
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - Setup DataSource
extension ShareSelectViewController {
    private func configureDataSource() {
        dataSource = DataSource(collectionView: mainView.shareCollectionView) { collectionView, indexPath, item in
            switch item {
            case .guide:
                let cell = collectionView.dequeueReusableCell(ShareSelectGuideCell.self, for: indexPath)
                return cell
            case .notice:
                let cell = collectionView.dequeueReusableCell(ShareSelectNoticeCell.self, for: indexPath)
                return cell
            case .select(let item):
                let cell = collectionView.dequeueReusableCell(ShareSelectCell.self, for: indexPath)
                cell.bind(item: item, relay: self.selectCellRelay)
                return cell
            }
        }
        
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            let section = ShareSelectSection(rawValue: indexPath.section)
            
            if kind == UICollectionView.elementKindSectionFooter {
                switch section {
                case .select:
                    return collectionView.dequeueReusableSupplementaryView(
                        ShareMoreView.self,
                        ofKind: kind,
                        for: indexPath
                    ).then {
                        $0.bind(
                            relay: self.moreButtonTapRelay,
                            isHidden: self.reactor?.currentState.isMoreButtonHidden ?? true
                        )
                    }
                default:
                    return nil
                }
            }
            
            return nil
        }
    }
}
