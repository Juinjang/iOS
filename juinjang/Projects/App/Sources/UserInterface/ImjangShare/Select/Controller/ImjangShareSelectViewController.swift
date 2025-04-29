//
//  ImjangShareSelectViewController.swift
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

final class ImjangShareSelectViewController: BaseViewController, View {
    typealias DataSource = UICollectionViewDiffableDataSource<ImjangShareSelectSection, ImjangShareSelectBaseCellItem>
    var disposeBag: DisposeBag = DisposeBag()
    private let mainView = ImjangShareSelectView()
    private let selectCellRelay = PublishRelay<String>()
    private let moreButtonTapRelay = PublishRelay<Void>()
    private var dataSource: DataSource!

    init(reactor: ImjangShareSelectViewReactor) {
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
    
    func bind(reactor: ImjangShareSelectViewReactor) {
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
            .bind(to: mainView.imjangShareCollectionView.rx.bindSectionItems(
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
    }
}

// MARK: - Setup DataSource
extension ImjangShareSelectViewController {
    private func configureDataSource() {
        dataSource = DataSource(collectionView: mainView.imjangShareCollectionView) { collectionView, indexPath, item in
            switch item {
            case .guide:
                let cell = collectionView.dequeueReusableCell(ImjangShareSelectGuideCell.self, for: indexPath)
                return cell
            case .notice:
                let cell = collectionView.dequeueReusableCell(ImjangShareSelectNoticeCell.self, for: indexPath)
                return cell
            case .select(let item):
                let cell = collectionView.dequeueReusableCell(ImjangShareSelectCell.self, for: indexPath)
                cell.bind(item: item, relay: self.selectCellRelay)
                return cell
            }
        }
        
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            let section = ImjangShareSelectSection(rawValue: indexPath.section)
            
            if kind == UICollectionView.elementKindSectionFooter {
                switch section {
                case .select:
                    return collectionView.dequeueReusableSupplementaryView(
                        ImjangShareMoreView.self,
                        ofKind: kind,
                        for: indexPath
                    ).then {
                        $0.bind(relay: self.moreButtonTapRelay)
                    }
                default:
                    return nil
                }
            }
            
            return nil
        }
    }
}
