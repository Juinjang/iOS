//
//  ShareWriteViewController.swift
//  juinjang
//
//  Created by KimDongWoo on 5/3/25.
//

import UIKit
import SnapKit
import Then
import ReactorKit
import RxSwift
import RxRelay

final class ShareWriteViewController: BaseViewController, View {
    var disposeBag: DisposeBag = DisposeBag()
    typealias DataSource = UICollectionViewDiffableDataSource<ShareWriteSection, ShareWriteBaseCellItem>
    private var dataSource: DataSource!
    private let mainView = ShareWriteView()
    
    private let buildingNameTextRelay = PublishRelay<String>()
    private let isPhotoPublicRelay = PublishRelay<Bool>()
    private let timeCellClickRelay = PublishRelay<Void>()
    private let reviewTextRelay = PublishRelay<String>()
    
    init(reactor: ShareWriteViewReactor) {
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
        self.reactor?.action.onNext(.viewDidLoad)
    }
    
    func bind(reactor: ShareWriteViewReactor) {
        reactor.state
            .map(\.nickname)
            .distinctUntilChanged()
            .bind(to: mainView.rx.navigationTitle)
            .disposed(by: disposeBag)
        
        reactor.state
            .map(\.popViewTrigger)
            .compactMap { $0 }
            .observe(on: MainScheduler.instance)
            .subscribe(with: self) { (self, action) in
                self.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map(\.isActivatedUploadButton)
            .distinctUntilChanged()
            .bind(to: mainView.rx.isActivatedUploadButton)
            .disposed(by: disposeBag)
        
        reactor.state
            .map(\.sectionItems)
            .distinctUntilChanged()
            .bind(to: mainView.writeCollectionView.rx.bindSectionItems(
                to: dataSource,
                orderedBy: [
                    .notice,
                    .share,
                    .building,
                    .photo,
                    .period,
                    .review
                ]
            ))
            .disposed(by: disposeBag)
        
        reactor.state
            .map(\.sectionItems)
            .distinctUntilChanged()
            .bind(to: mainView.rx.configureVisibleSections)
            .disposed(by: disposeBag)
        
        reactor.state
            .map(\.isShowCompletedView)
            .compactMap { $0 }
            .observe(on: MainScheduler.instance)
            .subscribe(with: self) { (self,_) in
                self.present(
                    self.createShareCompletedView(),
                    animated: true
                )
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map(\.isShowErrorAlertView)
            .compactMap { $0 }
            .subscribe(with: self) { (self, text) in
                self.showAlert(title: "에러", message: text, actionHandler: nil)
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map(\.isShowSafetyAlertView)
            .compactMap { $0 }
            .subscribe(with: self) { (self, _) in
                self.present(ShareSafetyAlertView(), animated: true)
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map(\.isShowLoadingView)
            .compactMap { $0 }
            .subscribe(with: self) { (self, bool) in
                bool ? self.showLoading() : self.hideLoading()
            }
            .disposed(by: disposeBag)
    }
    
    private func bindEvent() {
        guard let reactor = self.reactor else { return }
        
        mainView.navigationView
            .itemActionRelay
            .map { Reactor.Action.didTapNavigationButton($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        mainView.uploadButton
            .rx.throttleTap(milliseconds: 1000) // 중복 클릭 방지
            .map { Reactor.Action.uploadButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        isPhotoPublicRelay
            .map { Reactor.Action.didTapSelectPulbicButton($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        timeCellClickRelay
            .subscribe(with: self) { (self, _) in
                self.present(
                    ImjangPeriodPickerView(
                        selectPeriod: self.reactor?.currentState.selectImjangPeriod
                    ).then {
                        $0.selectPeriodRelay
                            .map { Reactor.Action.selectedImjangPeriod($0) }
                            .bind(to: reactor.action)
                            .disposed(by: self.disposeBag)
                    },
                    animated: true
                )
            }
            .disposed(by: disposeBag)
        
        buildingNameTextRelay
            .map { Reactor.Action.editingBuildingName($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reviewTextRelay
            .map { Reactor.Action.editingReviewContent($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
    }
    
    private func createShareCompletedView() -> UIViewController {
        guard let reactor = self.reactor else { return UIViewController() }
        
        return ShareCompletedView().then {
            $0.eventRelay
                .subscribe(with: self) { (self, event) in
                    switch event {
                    case .cancel:
                        self.changeLookAroundVC()
                    case .confirm:
                        let selectedModel = reactor.getShareSelectModel()
                        
                        self.changeImjangDetailVCFromLookAround(
                            SharedNoteID: reactor.currentState.sharedNoteId ?? 0,
                            title: selectedModel.name
                        )
                    default: break
                    }
                }
                .disposed(by: self.disposeBag)
        }
    }
}

// MARK: - Setup DataSource
extension ShareWriteViewController {
    private func configureDataSource() {
        dataSource = DataSource(collectionView: mainView.writeCollectionView) { collectionView, indexPath, item in
            switch item {
            case .notice(let item):
                let cell = collectionView.dequeueReusableCell(ShareWriteNoticeCell.self, for: indexPath)
                cell.bind(item: item.model)
                return cell
                
            case .share(let item):
                let cell = collectionView.dequeueReusableCell(ShareWriteShareCell.self, for: indexPath)
                cell.bind(item: item.model)
                return cell
                
            case .building:
                let cell = collectionView.dequeueReusableCell(ShareWriteBuildingCell.self, for: indexPath)
                cell.bind(relay: self.buildingNameTextRelay)
                return cell
                
            case .photo(let item):
                let cell = collectionView.dequeueReusableCell(ShareWritePhotoCell.self, for: indexPath)
                cell.bind(item: item.isPublic, relay: self.isPhotoPublicRelay)
                return cell
                
            case .period(let item):
                let cell = collectionView.dequeueReusableCell(ShareWritePeriodCell.self, for: indexPath)
                cell.bind(model: item, relay: self.timeCellClickRelay)
                return cell
                
            case .review:
                let cell = collectionView.dequeueReusableCell(ShareWriteReviewCell.self, for: indexPath)
                cell.bind(relay: self.reviewTextRelay)
                return cell
            }
        }
    }
}
