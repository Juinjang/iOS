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
    typealias DataSource = UICollectionViewDiffableDataSource<ImjangDetailSection, ImjangDetailBaseCellItem>
    var disposeBag: DisposeBag = DisposeBag()
    private var dataSource: DataSource!
    private let mainView = ImjangDetailView()
    private let selectedCategoryRelay = PublishRelay<Int>()
    private let infoCellEventRelay = PublishRelay<ImjangDetailInfoCellEvent>()
    
    init(reactor: ImjangDetailViewReactor) {
        super.init()
        configureDataSource()
        self.reactor = reactor
        bindView()
        bindViewEvent()
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reactor?.action.onNext(.viewWillAppear)
    }
    
    func bind(reactor: ImjangDetailViewReactor) {
        reactor.state
            .map(\.title)
            .bind(to: mainView.rx.navigationTitle)
            .disposed(by: disposeBag)
        
        reactor.state
            .map(\.sectionItems)
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
            .map { $0.sectionItems.infoItem() }
            .compactMap { $0 }
            .distinctUntilChanged()
            .subscribe { model in
                CheckListNoteOpenView.modelRelay.accept(model.model)
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map(\.isBuyer)
            .distinctUntilChanged()
            .skip(1)
            .bind(to: mainView.rx.isBuyer)
            .disposed(by: disposeBag)
        
        reactor.state
            .map(\.isShowPencilAlert)
            .compactMap { $0 }
            .observe(on: MainScheduler.instance)
            .subscribe(with: self) { (self, bool) in
                guard let reactor = self.reactor else {
                    return
                }
                
                let alertView = PencilAlertView(
                    title: reactor.dependency.title,
                    pencilCount: reactor.currentState.balancePencilCount,
                    needPencilCount: reactor.currentState.requiredPencilCount
                ).then {
                    $0.eventRelay
                        .subscribe(with: self) { (self, event) in
                            switch event {
                            case .confirm:
                                self.navigationController?.pushViewController(
                                    NoteEnterPencilShopViewController(
                                        reactor: .init(
                                            dependency: .init(
                                                inAppPurchaseService: InAppPurchaseService(
                                                    pencilShopRepository: .init()
                                                ),
                                                pencilShopRepository: PencilShopRepository(),
                                                needPencilCount: reactor.currentState.requiredPencilCount,
                                                buildingName: reactor.currentState.buildingName,
                                                totalRate: reactor.currentState.totalRate
                                            )
                                        )
                                    ),
                                    animated: true
                                )
                                
                            case .custom:
                                reactor.action.onNext(.purchaseButtonDidTap)
                                
                            default: break
                            }
                        }
                        .disposed(by: self.disposeBag)
                }
                
                self.present(
                    alertView,
                    animated: true
                )
                
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map(\.isShowNotBuyerAlert)
            .observe(on: MainScheduler.instance)
            .distinctUntilChanged()
            .skip(1)
            .subscribe(with: self) { (self, _) in
                self.showAlert(
                    title: "주인장",
                    message: "구매하지 않은 임장노트에요.",
                    actionHandler: nil
                )
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map(\.isShowCaptureAlert)
            .observe(on: MainScheduler.instance)
            .distinctUntilChanged()
            .compactMap { $0 }
            .subscribe(with: self) { (self, _) in
                self.showCaptureAlert()
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map(\.isShowReportCompletedView)
            .observe(on: MainScheduler.instance)
            .compactMap { $0 }
            .subscribe(with: self) { (self, _) in
                self.present(ReportCompletedAlertView(), animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    private func bindView() {
        guard let reactor = self.reactor else { return }
        
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
        
        mainView.navigationView
            .itemActionRelay
            .subscribe(with: self) { (self, action) in
                switch action {
                case .popButtonTap:
                    self.navigationController?.popViewController(animated: true)
                case .reportButtonTap:
                    self.present(ReportSelectAlertView().then { view in
                        view.reportEventRelay
                            .subscribe(with: self) { (self, event) in
                                switch event {
                                case .updateSelectType(let reason):
                                    self.reactor?.action.onNext(.reportReasonDidSelected(reason))
                                case .reportButtonTap:
                                    view.dismiss(animated: true) {
                                        self.reactor?.action.onNext(.reportButtonDidTap)
                                    }
                                }
                            }
                            .disposed(by: self.disposeBag)
                    }, animated: true)
                default: break
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func bindViewEvent() {
        guard let reactor = self.reactor else { return }
        
        selectedCategoryRelay
            .map { Reactor.Action.checkListCategoryDidTap(index: $0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        infoCellEventRelay
            .subscribe(with: self) { (self, event) in
                switch event {
                case .addressTap(address: let text):
                    UIPasteboard.general.string = text
                    self.showAlert(title: "주인장", message: "전체 복사 완료!", actionHandler: nil)
                case .expandImageButtonTap(index: let index):
                    reactor.action.onNext(.expandImageButtonDidTap(index: index))
                case .likeButtonTap:
                    reactor.action.onNext(.likeButtonDidTap)
                }
            }
            .disposed(by: disposeBag)
        
        UIApplication.shared.rx.didCapture
            .observe(on: MainScheduler.instance)
            .subscribe(with: self) { (self, _) in
                self.showCaptureAlert()
            }
            .disposed(by: disposeBag)
        
        UIScreen.main.rx.isRecording
            .observe(on: MainScheduler.instance)
            .map { Reactor.Action.screenRecordingChanged(isRecording: $0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func showCaptureAlert() {
        self.showAlert(title: "캡쳐 시 주의사항",
                       message: "구매한 콘텐츠를 캡쳐한 스크린샷을 온/오프라인에 유포/공유할 경우 법적인 제재를 받을 수 있습니다.",
                       actionHandler: nil)
    }
}

// MARK: - Setup DataSource
extension ImjangDetailViewController: UICollectionViewDelegate {
    private func configureDataSource() {
        dataSource = DataSource(collectionView: mainView.detailCollectionView) { collectionView, indexPath, item in
            switch item {
            case .info(let item):
                let cell = collectionView.dequeueReusableCell(ImjangDetailInfoCell.self, for: indexPath)
                cell.bind(item.model, relay: self.infoCellEventRelay)
                return cell
            case .report(let item):
                let cell = collectionView.dequeueReusableCell(ImjangDetailReportCell.self, for: indexPath)
                cell.bind(item.model)
                return cell
            case .checkList(let item):
                guard let isOneRoom = self.reactor?.currentState.isOneRoom else { return UICollectionViewCell() }
                let cell = collectionView.dequeueReusableCell(ImjangDetailCheckListCell.self, for: indexPath)
                cell.bind(item.model, isOneRoom: isOneRoom)
                return cell
            case .review(let item):
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

