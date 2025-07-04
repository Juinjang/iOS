//
//  LookAroundViewController.swift
//  juinjang
//
//  Created by 조유진 on 2/27/25.
//

import UIKit
import ReactorKit
import RxDataSources
import RxRelay

enum LookAroundEventType: Equatable {
    case cellContentTap(content: LookAroundContent)
    case filterItemTap(SortAction?, TransactionTypeAction?, SaleTypeAction?)
    case heartButtonTap(sharedNoteId: Int)
    case noteTap(sharedNoteId: Int, buildingName: String)
}

extension LookAroundEventType {
    var tappedContent: LookAroundContent? {
        if case let .cellContentTap(content) = self {
            return content
        }
        return nil
    }
    
    var tappedFilterItem: (sort: SortAction?, transactionType: TransactionTypeAction?, saleType: SaleTypeAction?)? {
        if case let .filterItemTap(sort, transaction, saleType) = self {
            return (sort, transaction, saleType)
        }
        return nil
    }
    
    var tappedHeartButton: Int? {
        if case let .heartButtonTap(sharedNoteId) = self {
            return sharedNoteId
        }
        return nil
    }
    
    var tappedNote: (sharedNoteid: Int, buildingName: String)? {
        if case let .noteTap(sharedNoteId, buildingName) = self {
            return (sharedNoteId, buildingName)
        } else {
            return nil
        }
    }
}

final class LookAroundViewController: BaseViewController, View {
    var disposeBag = DisposeBag()
    
    private let mainView = LookAroundView()
    private lazy var dataSource: RxCollectionViewSectionedReloadDataSource<SectionOfExploreNote> = {
        let dataSource = configureCollectionViewDataSource()
        return dataSource
    }()
    
    private let cellEventRelay = PublishRelay<LookAroundEventType>()
    private let moreButtonTapRelay = PublishRelay<Void>()
    
    init(reactor: LookAroundReactor) {
        super.init()
        self.reactor = reactor
        bindEvent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        reactor?.action.onNext(.retrieveExploreNotes)
    }

    override func loadView() {
        view = mainView
    }
    
    func bind(reactor: LookAroundReactor) {
        mainView.navigationView.itemActionRelay
            .bind(with: self, onNext: { owner, action in
                switch action {
                case .popButtonTap: owner.popVewController()
                case .searchButtonTap: owner.showSearchLookAroundImjangVC()
                default: break
                }
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .compactMap { $0.sectionOfExploreNotes }
            .distinctUntilChanged()
            .map { [weak self] sections in
                if let notes = sections[3].items as? [ExploreNoteModel] {
                    self?.mainView.collectionView.collectionViewLayout = self?.mainView.createCollectionViewLayout(isListEmpty: notes.isEmpty) ?? UICollectionViewLayout()
                }
                return sections
            }
            .bind(to: mainView.collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        reactor.state
            .map(\.isLastPage)
            .distinctUntilChanged()
            .compactMap { $0 }
            .bind(to: mainView.rx.isLastPage)
            .disposed(by: disposeBag)
    }
    
    private func bindEvent() {
        guard let reactor = self.reactor else { return }
        
        moreButtonTapRelay
            .map { Reactor.Action.moreButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        cellEventRelay
            .compactMap { $0.tappedContent }
            .bind(with: self) { owner, content in
                owner.handleContentTapped(content: content)
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
        
        cellEventRelay
            .compactMap { $0.tappedHeartButton }
            .bind(with: self) { owner, sharedNoteId in
                owner.reactor?.action.onNext(.heartButtonDidTap(sharedNoteId: sharedNoteId))
            }
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
                    sharedNoteRepository: SharedNoteRepository(),
                    pencilShopRepository: PencilShopRepository()
                )
            )
        )
        navigationController?.pushViewController(lookAroundDetailVC, animated: true)
    }
    
    private func handleContentTapped(content: LookAroundContent) {
        switch content {
        case .pencilShop: showPencilShopVC()
        case .myNote: showMyNoteVC()
        }
    }
    
    private func showPencilShopVC() {
        let pencilShopVC = PencilShopViewController(
            reactor: PencilShopReactor(
                dependency: PencilShopReactor.Dependency(
                    inAppPurchaseService: InAppPurchaseService(pencilShopRepository: PencilShopRepository()),
                    pencilShopRepository: PencilShopRepository(),
                    userRepository: UserRepository()
                )
            )
        )
        navigationController?.pushViewController(pencilShopVC, animated: true)
    }

    private func showMyNoteVC() {
        let myNoteVC = MyNoteViewController(
            reactor: MyNoteViewReactor(
                dependency: MyNoteViewReactor.Dependency(
                    noteRepository: SharedNoteRepository()
                )
            )
        )
        navigationController?.pushViewController(myNoteVC, animated: true)
    }
    
    private func popVewController() {
        navigationController?.popViewController(animated: true)
    }
    
    private func showSearchLookAroundImjangVC() {
        let searchLookAroundVC = LookAroundSearchViewController(
            reactor: LookAroundSearchReactor(
                dependency: LookAroundSearchReactor.Dependency(
                    sharedNoteRepository: SharedNoteRepository()
                )
            )
        )
        navigationController?.pushViewController(searchLookAroundVC, animated: true)
    }
}

extension LookAroundViewController {
    private func configureCollectionViewDataSource() -> RxCollectionViewSectionedReloadDataSource<SectionOfExploreNote> {
        return RxCollectionViewSectionedReloadDataSource<SectionOfExploreNote>(configureCell: { [weak self] dataSource, collectionView, indexPath, lookAroundImjangData in
            guard let self = self else { return UICollectionViewCell() }
            switch dataSource[indexPath] {
            case .contentsSection(let content):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LookAroundContentCell.identifier, for: indexPath) as? LookAroundContentCell else { return UICollectionViewCell() }
                cell.configureCell(content: content, relay: self.cellEventRelay)
                return cell
                
            case .selectAreaSection(let selectArea):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SelectAreaCell.identifier, for: indexPath) as? SelectAreaCell else { return UICollectionViewCell() }
                
                cell.configureCell(area: selectArea)
                
                return cell
                
            case .imjangCountSection(let imjangCount):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LookAroundImjangCountCell.identifier, for: indexPath) as? LookAroundImjangCountCell else { return UICollectionViewCell() }
                cell.configureCell(imjangCount: imjangCount)
                return cell
                
            case .exploreNoteSection(let exploreNote):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LookAroundImjangCell.identifier, for: indexPath) as? LookAroundImjangCell else { return UICollectionViewCell() }
                cell.configureCell(exploreNote, relay: self.cellEventRelay)
                return cell
            }
        }, configureSupplementaryView: { [weak self] dataSource, collectionView, kind, indexPath in
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
