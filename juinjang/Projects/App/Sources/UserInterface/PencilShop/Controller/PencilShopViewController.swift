//
//  PencilShopViewController.swift
//  juinjang
//
//  Created by 조유진 on 4/1/25.
//

import UIKit
import ReactorKit

final class PencilShopViewController: BaseViewController, View {
    private let mainView = PencilShopView()
    
    typealias AcquiredDataSource = UICollectionViewDiffableDataSource<AcquiredPencilSection, AcquiredPencilDTO>
    private var acquiredDataSource: AcquiredDataSource!
    
    typealias PurchasedDataSource = UICollectionViewDiffableDataSource<PurchasedPencilSection, PurchasedPencilDTO>
    private var purchasedDataSource: PurchasedDataSource!
    
    typealias UsedDataSource =
    UICollectionViewDiffableDataSource<UsedPencilSection, UsedPencilDTO>
    private var usedDataSource: UsedDataSource!
    
    var disposeBag = DisposeBag()
    
    init(reactor: PencilShopReactor) {
        super.init()
        configureObtainedDataSource()
        configurePurchasedDataSource()
        configureUsedDataSource()
        self.reactor = reactor
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewEvent()
        reactor?.action.onNext(.viewDidLoad)
    }
    
    func bind(reactor: PencilShopReactor) {
        reactor.state
            .compactMap { $0.pencilTotalBalance }
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, pencilBalanceDTO in
                owner.mainView.buyingView.setPencilCount(count: pencilBalanceDTO.totalBalance)
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .compactMap { $0.isTotalRead }
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, isTotalRead in
                !isTotalRead ?
                owner.mainView.segmentedView.showNewDotView() :
                owner.mainView.segmentedView.hideNewDotView()
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .compactMap { $0.products }
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, products in
                owner.mainView.setProductList(products)
            }
            .disposed(by: disposeBag)

        reactor.state
            .map { $0.acquiredSections }
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, sections in
                owner.applyAcquiredSnapshot(sections: sections)
                if let section = sections.first {
                    owner.mainView.obtainedView.setListEmpty(empty: section.acquiredPencils.isEmpty)
                }
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.purchasedSections }
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, sections in
                owner.applyPurchasedSnapshot(sections: sections)
                if let section = sections.first {
                    owner.mainView.purchasedView.setListEmpty(empty: section.purchasedPencils.isEmpty)
                }
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.usedSections }
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, sections in
                owner.applyUsedSnapshot(sections: sections)
                if let section = sections.first {
                    owner.mainView.usedView.setListEmpty(empty: section.usedPencils.isEmpty)
                }
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.purchaseResult }
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, purchasePencilDTO in
                guard let purchasePencilDTO else { return }
                owner.showPurchasedPopupView(response: purchasePencilDTO)
                owner.mainView.buyingView.setPencilCount(count: purchasePencilDTO.remainQuantity)
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.isLoading }
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, bool in
                self.setLoading(isShow: bool)
            }
            .disposed(by: disposeBag)
    }
    
    func bindViewEvent() {
        mainView
            .navigationView
            .itemActionRelay
            .withUnretained(self)
            .subscribe { (self, action) in
                switch action {
                case .popButtonTap:
                    self.navigationController?.popViewController(animated: true)
                default: break
                }
            }
            .disposed(by: disposeBag)
        
        mainView
            .segmentedView
            .buttonTapSelectedRelay
            .withUnretained(self)
            .subscribe { (self, index) in
                self.mainView.scrollToPage(categoryType: PencilShopCategoryType(rawValue: index) ?? .buying)
                self.reactor?.action.onNext(.categoryButtonDidTap(index))
            }
            .disposed(by: disposeBag)
        
        
        mainView.buyingView.priceTappedRelay
            .map {
                return Reactor.Action.priceButtonDidTap($0)
            }
            .bind(to: reactor!.action)
            .disposed(by: disposeBag)
        
        mainView.obtainedView.collectionView.rx.itemSelected
            .subscribe(with: self) { owner, indexPath in
                owner.reactor?.action.onNext(.acquiredPencilSelected(indexPath.item))
                owner.showNoteDetialVC(index: indexPath.item)
            }
            .disposed(by: disposeBag)
        
        mainView.obtainedView.goMyNoteButtonTapRelay
            .subscribe(with: self) { owner, _ in
                owner.goMyNoteVC()
            }
            .disposed(by: disposeBag)
    }

    override func loadView() {
        view = mainView
    }
    
    private func showNoteDetialVC(index: Int) {
        guard let reactor = reactor else { return }
        guard let section = reactor.currentState.acquiredSections.first else { return }
        let acquiredPencil = section.acquiredPencils[index]
        
        let noteDetailVC = ImjangDetailViewController(reactor: ImjangDetailViewReactor(
            dependency: .init(
                id: acquiredPencil.sharedNoteId,
                title: acquiredPencil.buildingName,
                sharedNoteRepository: SharedNoteRepository(),
                pencilShopRepository: PencilShopRepository(),
                likeEventRelay: nil)
            )
        )
        navigationController?.pushViewController(noteDetailVC, animated: true)
    }
    
    private func goMyNoteVC() {
        if let navigationController = self.navigationController {
            navigationController.popToRootViewController(animated: false)
            navigationController.pushViewController(
                ImjangListViewController(
                    dependency: .init(noteRepository: NoteRepository())
                ),
                animated: true
            )
        }
    }
    
    private func showPurchasedPopupView(response: PurchasePencilDTO) {
        self.present(
            PurchasePopupViewController(
                purchasedPencilCount: response.purchaseQuantity,
                currentPencilCount: response.remainQuantity
            ),
            animated: true
        )
    }
    
    private func applyAcquiredSnapshot(sections: [AcquiredSectionModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<AcquiredPencilSection, AcquiredPencilDTO>()
        
        for section in sections {
            snapshot.appendSections([section.section])
            snapshot.appendItems(section.acquiredPencils, toSection: section.section)
        }
        
        acquiredDataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func configureObtainedDataSource() {
        self.acquiredDataSource =  UICollectionViewDiffableDataSource<AcquiredPencilSection, AcquiredPencilDTO>(
            collectionView: mainView.obtainedView.collectionView
        ) { collectionView, indexPath, item in
            let cell = collectionView.dequeueReusableCell(ObtainedPencilCell.self, for: indexPath)
            cell.configureCell(obtainedPencil: item)
            return cell
        }
    }
    
    private func applyPurchasedSnapshot(sections: [PurchasedSectionModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<PurchasedPencilSection, PurchasedPencilDTO>()
        
        for section in sections {
            snapshot.appendSections([section.section])
            snapshot.appendItems(section.purchasedPencils, toSection: section.section)
        }
        
        purchasedDataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func configurePurchasedDataSource() {
        self.purchasedDataSource =  UICollectionViewDiffableDataSource<PurchasedPencilSection, PurchasedPencilDTO>(
            collectionView: mainView.purchasedView.collectionView
        ) { collectionView, indexPath, item in
            let cell = collectionView.dequeueReusableCell(PurchasedPencilCell.self, for: indexPath)
            cell.configureCell(purchasedPencil: item)
            return cell
        }
        
        purchasedDataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            if kind == UICollectionView.elementKindSectionHeader {
                return collectionView.dequeueReusableSupplementaryView(
                    PencilGuideHeader.self,
                    ofKind: kind,
                    for: indexPath
                ).then {
                    $0.configureHeader(guideMessage: "구매한 연필은 취소할 수 없어요.")
                }
            }

            return nil
        }
    }
    
    private func applyUsedSnapshot(sections: [UsedSectionModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<UsedPencilSection, UsedPencilDTO>()
        
        for section in sections {
            snapshot.appendSections([section.section])
            snapshot.appendItems(section.usedPencils, toSection: section.section)
        }
        
        usedDataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func configureUsedDataSource() {
        self.usedDataSource =  UICollectionViewDiffableDataSource<UsedPencilSection, UsedPencilDTO>(
            collectionView: mainView.usedView.collectionView
        ) { collectionView, indexPath, item in
            let cell = collectionView.dequeueReusableCell(UsedPencilCell.self, for: indexPath)
            cell.configureCell(usedPencil: item)
            return cell
        }
        
        usedDataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            if kind == UICollectionView.elementKindSectionHeader {
                return collectionView.dequeueReusableSupplementaryView(
                    PencilGuideHeader.self,
                    ofKind: kind,
                    for: indexPath
                ).then {
                    $0.configureHeader(guideMessage: "사용한 연필은 취소할 수 없어요.")
                }
            }

            return nil
        }
    }
}
