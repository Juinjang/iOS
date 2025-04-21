//
//  ImjangDetailViewController.swift
//  juinjang
//
//  Created by KimDongWoo on 4/9/25.
//

import UIKit
import ReactorKit
import Then
import RxSwift
import RxCocoa
import RxRelay

final class ImjangDetailViewController: BaseViewController, View {
    typealias DataSource = UICollectionViewDiffableDataSource<ImjangDetailSection, BaseCellItem>
    var disposeBag: DisposeBag = DisposeBag()
    private var dataSource: DataSource!
    private let mainView = ImjangDetailView()
    private let selectedCategoryRelay = PublishRelay<Int>()
    
    init(reactor: ImjangDetailViewReactor) {
        super.init()
        configureDataSource()
        mainView.detailCollectionView.delegate = self
        self.reactor = reactor
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
    
    func bind(reactor: ImjangDetailViewReactor) {
        reactor.state
            .map(\.title)
            .bind(to: mainView.rx.navigationTitle)
            .disposed(by: disposeBag)
        
        reactor.state
            .map(\.sectionItems)
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .withUnretained(mainView)
            .do(onNext: { view, sectionItems in
                view.rx.updateLayoutBasedOnInfoSection.onNext(sectionItems)
            })
            .map { $0.1 }
            .bind(to: mainView.detailCollectionView.rx.bindSectionItems(
                to: dataSource,
                orderedBy: [.info, .report, .checkList, .review]
            ))
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.sectionItems[.info]?.first as? ImjangDetailInfoCellItem }
            .compactMap { $0 }
            .distinctUntilChanged { $0.id == $1.id }
            .subscribe { model in
                CheckListNoteOpenView.modelRelay.accept(model.model)
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map(\.isBuyer)
            .bind(to: mainView.rx.isBuyer)
            .disposed(by: disposeBag)
        
        reactor.state
            .map(\.isShowPencilAlert)
            .observe(on: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(with: self) { (self, bool) in
                if bool {
                    self.present(
                        PencilAlertView(
                            title: "판교푸르지오월드마크",
                            pencilCount: 0,
                            needPencilCount: 3
                        ),
                        animated: true
                    )
                }
            }
            .disposed(by: disposeBag)
        
        selectedCategoryRelay
            .map { Reactor.Action.checkListCategoryDidTap(index: $0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        mainView.detailCollectionView.rx.isCellAboveCenter(
            at: IndexPath(item: 0, section: ImjangDetailSection.report.rawValue)
        )
        .bind(to: mainView.rx.isTopButtonVisible)
        .disposed(by: disposeBag)
        
        mainView.topFloatingButton.rx.throttleTap
            .bind(to: mainView.rx.scrollToTop)
            .disposed(by: disposeBag)
        
        CheckListNoteOpenView.tapRelay
            .map { Reactor.Action.noteOpenButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
}

// MARK: - Setup DataSource
extension ImjangDetailViewController: UICollectionViewDelegate {
    private func configureDataSource() {
        dataSource = DataSource(collectionView: mainView.detailCollectionView) { collectionView, indexPath, item in
            guard let sectionItem = item as? ImjangDetailSectionProvidable else { return UICollectionViewCell() }
            switch sectionItem.sectionType {
            case .info:
                guard let item = item as? ImjangDetailInfoCellItem else { return UICollectionViewCell() }
                let cell = collectionView.dequeueReusableCell(ImjangDetailInfoCell.self, for: indexPath)
                cell.bind(item.model)
                return cell
            case .report:
                guard let item = item as? ImjangDetailReportCellItem else { return UICollectionViewCell() }
                let cell = collectionView.dequeueReusableCell(ImjangDetailReportCell.self, for: indexPath)
                cell.bind(item.model)
                return cell
            case .checkList:
                guard let item = item as? ImjangDetailCheckListCellItem,
                      let isBuyer = self.reactor?.currentState.isBuyer,
                      let isOneRoom = self.reactor?.currentState.isOneRoom else { return UICollectionViewCell() }
                let cell = collectionView.dequeueReusableCell(ImjangDetailCheckListCell.self, for: indexPath)
                cell.bind(item.model, isOneRoom: isOneRoom, isBuyer: isBuyer)
                return cell
            case .review:
                guard let item = item as? ImjangDetailReviewCellItem else { return UICollectionViewCell() }
                let cell = collectionView.dequeueReusableCell(ImjangDetailReviewCell.self, for: indexPath)
                cell.bind(item.model)
                return cell
            }
        }
        
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            
            let section = ImjangDetailSection(rawValue: indexPath.section)
            
            if kind == UICollectionView.elementKindSectionHeader {
                switch section {
                case .checkList:
                    guard let isOneRoom = self.reactor?.currentState.isOneRoom,
                          let isBuyer = self.reactor?.currentState.isBuyer else {
                        return UICollectionReusableView()
                    }
                    return collectionView.dequeueReusableSupplementaryView(
                        ImjangDetailCheckListHeaderView.self,
                        ofKind: kind,
                        for: indexPath
                    ).then {
                        $0.bind(for: self.selectedCategoryRelay,
                                isOneRoom: isOneRoom,
                                isBuyer: isBuyer)
                    }
                default:
                    return nil
                }
            }
            
            if kind == UICollectionView.elementKindSectionFooter {
                switch section {
                case .checkList:
                    return collectionView.dequeueReusableSupplementaryView(
                        WhiteSpacerFooterView.self,
                        ofKind: kind,
                        for: indexPath
                    )
                default:
                    return nil
                }
            }
            
            return nil
        }
    }
}
