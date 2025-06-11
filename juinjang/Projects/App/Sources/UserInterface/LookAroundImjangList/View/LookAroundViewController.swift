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

final class LookAroundViewController: BaseViewController, View {
    var disposeBag = DisposeBag()
    
    private let mainView = LookAroundView()
    private lazy var dataSource: RxCollectionViewSectionedReloadDataSource<SectionOfLookAroundImjangData> = {
        let dataSource = configureCollectionViewDataSource()
        return dataSource
    }()
    
    private let cellEventRelay = PublishRelay<LookAroundCellEventType>()
    
    init(reactor: LookAroundReactor) {
        super.init()
        self.reactor = reactor
        bindCellEvent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        reactor?.action.onNext(.viewDidLoad)
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
            .compactMap { $0.sectionOfLookAroundImjangData }
            .bind(to: mainView.collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    private func bindCellEvent() {
        cellEventRelay
            .compactMap { $0.tappedContent }
            .bind(with: self) { owner, content in
                owner.handleContentTapped(content: content)
            }
            .disposed(by: disposeBag)
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
                    inAppPurchaseService: InAppPurchaseService(buyPencilRepository: MockVerifyTransactionRepository()),
                    pencilShopRepository: PencilShopRepository()
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
                    lookAroundRepository: MockLookAroundRepository()
                )
            )
        )
        navigationController?.pushViewController(searchLookAroundVC, animated: true)
    }
}

extension LookAroundViewController {
    private func configureCollectionViewDataSource() -> RxCollectionViewSectionedReloadDataSource<SectionOfLookAroundImjangData> {
        return RxCollectionViewSectionedReloadDataSource<SectionOfLookAroundImjangData>(configureCell: { [weak self] dataSource, collectionView, indexPath, lookAroundImjangData in
            guard let self else { return UICollectionViewCell() }
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
                
            case .imjangListSection(let lookAroundImjang):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LookAroundImjangCell.identifier, for: indexPath) as? LookAroundImjangCell else { return UICollectionViewCell() }
                cell.configureCell(lookAroundImjang)
                return cell
            }
        }, configureSupplementaryView: { dataSource, collectionView, string, indexPath in
            let section = dataSource.sectionModels[indexPath.section]
            switch section {
            case .imjangListSection(_, _):
                guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: LookAroundFilterHeader.identifier, for: indexPath) as? LookAroundFilterHeader else {
                    return UICollectionReusableView()
                }
                
                return headerView
           
            default: return UICollectionReusableView()
            }
        })
    }
}
