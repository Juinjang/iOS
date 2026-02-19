//
//  MyNotePageCell.swift
//  juinjang
//
//  Created by KimDongWoo on 3/14/25.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa
import RxDataSources

enum MyNotePageEventType: Equatable {
    case noticeCloseButtonTap
    case filterItemTap(TransactionTypeAction?, SaleTypeAction?)
    case shareButtonTap
    case stopShareButtonTap
    case cellEvent(MyNoteCellEventType)
}

extension MyNotePageEventType {
    var isCellTap: Bool {
        if case .cellEvent(.cellTap) = self {
            return true
        }
        return false
    }
    
    var cellTapId: Int? {
        if case let .cellEvent(.cellTap(id, _)) = self {
            return id
        }
        return nil
    }
}

final class MyNotePageCell: UICollectionViewCell {
    private var disposeBag = DisposeBag()
    private let noticeView = MyNoteNoticeView()
    private let filterView = MyNoteDropDownView()
    private let stopShareButton = UIButton().then {
        $0.setImage(.trash, for: .normal)
        $0.isHidden = true
    }
    private let emptyView = MyNoteEmptyView().then {
        $0.isHidden = true
    }
    private lazy var innerCollectionView: UICollectionView = {
        return UICollectionView(frame: .zero,
                                collectionViewLayout: createCompositionalLayout()).then {
            $0.register(MyNoteCell.self)
            $0.showsVerticalScrollIndicator = false
        }
    }()
    
    private let cellEventRelay = PublishRelay<MyNoteCellEventType>()
    private let closeButtonRelay = PublishRelay<Void>()
                
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupLayout()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
        noticeView.alpha = 1.0
        noticeView.isHidden = false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        [filterView, stopShareButton].forEach {
            contentView.bringSubviewToFront($0)
        }
    }
    
    private func setupUI() {
        contentView.add([
            noticeView,
            filterView,
            stopShareButton,
            innerCollectionView,
            emptyView
        ])
    }
    
    private func setupLayout() {
        noticeView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(48)
        }
        
        filterView.snp.makeConstraints {
            $0.top.equalTo(noticeView.snp.bottom)
            $0.left.equalToSuperview().offset(24)
            $0.height.equalTo(51)
        }
        
        stopShareButton.snp.makeConstraints {
            $0.size.equalTo(22)
            $0.centerY.equalTo(filterView.snp.centerY)
            $0.right.equalToSuperview().inset(24)
        }
        
        innerCollectionView.snp.makeConstraints {
            $0.top.equalTo(filterView.snp.bottom)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
        
        emptyView.snp.makeConstraints {
            $0.height.equalTo(269)
            $0.width.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-42)
        }
    }
    
    func bind(page: MyNotePageModel,
              relay: PublishRelay<MyNotePageEventType>) {
        disposeBag = DisposeBag()
        noticeView.configure(page.category, relay: closeButtonRelay)
        filterView.configure(page.transactionType, page.saleType)
        stopShareButton.isHidden = page.items.isEmpty || page.category != .share
        emptyView.configure(text: createEmptyViewText(category: page.category),
                            isShowButton: page.category == .share,
                            buttonTitle: "노트 공유하러 가기")
        configureNoticeLayout(isShowing: page.isShowingNotice)
        configureCellLayout(isEmpty: page.items.isEmpty, isFirstShowing: page.isFirstShowing)

        Observable.just([page])
            .bind(
                to: innerCollectionView.rx.items(
                    dataSource: createDataSource(relay: cellEventRelay)
                )
            )
            .disposed(by: disposeBag)
        
        cellEventRelay
            .map { MyNotePageEventType.cellEvent($0) }
            .bind(to: relay)
            .disposed(by: disposeBag)
        
        closeButtonRelay
            .subscribe(with: self) { (self, _) in
                self.animateNoticeClose(relay: relay)
            }
            .disposed(by: disposeBag)
        
        filterView.transactionTypeActionRelay
            .subscribe(with: self) { (self, action) in
                relay.accept(.filterItemTap(action, nil))
            }
            .disposed(by: disposeBag)
        
        filterView.saleTypeActionRelay
            .subscribe(with: self) { (self, action) in
                relay.accept(.filterItemTap(nil, action))
            }
            .disposed(by: disposeBag)
        
        stopShareButton.rx.throttleTap
            .map { MyNotePageEventType.stopShareButtonTap }
            .bind(to: relay)
            .disposed(by: disposeBag)
        
        emptyView.filledButtonRelay
            .subscribe(with: self) { (self, action) in
                relay.accept(.shareButtonTap)
            }
            .disposed(by: disposeBag)
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if let hitView = super.hitTest(point, with: event) {
            return hitView
        }
        
        let convertedPoint = filterView.convert(point, from: self)
        if let hitView = filterView.hitTest(convertedPoint, with: event) {
            return hitView
        }
        
        return nil
    }
    
    private func createEmptyViewText(category: MyNoteCategoryType) -> String {
        switch category {
        case .share:
            return "공유한 노트가 없어요"
        case .own:
            return "소장한 노트가 없어요"
        case .like:
            return "좋아한 노트가 없어요"
        }
    }
}

// MARK: - CollectionView Layout
extension MyNotePageCell {
    private func createDataSource(relay: PublishRelay<MyNoteCellEventType>) -> RxCollectionViewSectionedReloadDataSource<MyNotePageModel> {
        return .init(
            configureCell: { _, collectionView, indexPath, item in
                return collectionView.dequeueReusableCell(
                    MyNoteCell.self,
                    for: indexPath
                ).then {
                    $0.bind(item, relay: relay)
                }
            }
        )
    }
    
    private func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(136)
            )
            
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = itemSize
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: groupSize,
                subitems: [item]
            )
            
            let section = NSCollectionLayoutSection(group: group).then {
                $0.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
                $0.interGroupSpacing = 0
            }
            
            return section
        }
        
        return layout
    }
}

// MARK: - Notice Layout Update
extension MyNotePageCell {
    private func animateNoticeClose(relay: PublishRelay<MyNotePageEventType>) {
        UIView.animateKeyframes(withDuration: 0.5, delay: 0, options: []) { [weak self] in
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.5) {
                self?.noticeView.alpha = 0.0
            }
            UIView.addKeyframe(withRelativeStartTime: 0.3, relativeDuration: 0.7) {
                self?.noticeView.snp.updateConstraints {
                    $0.top.equalToSuperview().offset(0)
                    $0.height.equalTo(0)
                }
                self?.filterView.snp.remakeConstraints {
                    $0.top.equalToSuperview()
                    $0.horizontalEdges.equalToSuperview().inset(24)
                    $0.height.equalTo(51)
                }
                self?.contentView.layoutIfNeeded()
            }
        } completion: { [weak self] _ in
            self?.noticeView.isHidden = true
            relay.accept(.noticeCloseButtonTap)
        }
    }
    
    private func configureNoticeLayout(isShowing: Bool) {
        noticeView.isHidden = !isShowing
        noticeView.alpha = isShowing ? 1.0 : 0.0
        
        noticeView.snp.remakeConstraints {
            $0.top.equalToSuperview().offset(isShowing ? 16 : 0)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(isShowing ? 48 : 0)
        }
        
        filterView.snp.remakeConstraints {
            $0.top.equalTo(isShowing ? noticeView.snp.bottom : self.contentView.snp.top)
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.height.equalTo(51)
        }
        
        contentView.layoutIfNeeded()
    }
}

// MARK: - Cell Layout Update
extension MyNotePageCell {
    private func configureCellLayout(isEmpty: Bool,
                                     isFirstShowing: Bool) {
        innerCollectionView.isHidden = isEmpty
        emptyView.isHidden = isFirstShowing ? true : !isEmpty
    }
}
