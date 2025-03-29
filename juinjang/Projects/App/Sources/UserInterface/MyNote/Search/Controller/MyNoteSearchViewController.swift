//
//  MyNoteSearchViewController.swift
//  juinjang
//
//  Created by KimDongWoo on 3/29/25.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxRelay
import RxCocoa
import RxDataSources
import ReactorKit

final class MyNoteSearchViewController: BaseViewController, View {
    var disposeBag = DisposeBag()
    
    private let navigationView = SearchNavigationView().then {
        $0.searchPlaceHolder = "건물명이나 주소를 검색해 보세요."
        $0.leftItem = [.pop]
    }
    
    private lazy var searchCollectionView: UICollectionView = {
        return UICollectionView(frame: .zero, collectionViewLayout: createCompositionalLayout()).then {
            $0.register(MyNoteCell.self)
            $0.contentInset = .init(top: 4, left: 0, bottom: 0, right: 0)
            $0.showsVerticalScrollIndicator = false
        }
    }()
    
    private let emptyView = MyNoteEmptyView().then {
        $0.configure(text: "일치하는 임장노트가 없어요")
    }
    
    private let cellEventRelay = PublishRelay<MyNoteCellEventType>()
    
    init(reactor: MyNoteSearchViewReactor) {
        super.init()
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureHierarchy()
        configureLayout()
    }
    
    func bind(reactor: MyNoteSearchViewReactor) {
        reactor.state
            .map { [MyNoteSearchSectionModel(items: $0.list)] }
            .bind(to: searchCollectionView.rx.items(dataSource: createDataSource()))
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.isEmpty }
            .bind(to: searchCollectionView.rx.isHidden)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { !$0.isEmpty }
            .bind(to: emptyView.rx.isHidden )
            .disposed(by: disposeBag)
        
        navigationView
            .itemActionRelay
            .subscribe(with: self) { (self, action) in
                switch action {
                case .popButtonTap:
                    self.navigationController?.popViewController(animated: true)
                case .searchSummit(let keyword):
                    reactor.action.onNext(.searchSummitButtonTapped(keyword: keyword))
                default: break
                }
            }
            .disposed(by: disposeBag)
        
        cellEventRelay
            .subscribe(with: self) { (self, event) in
                
            }
            .disposed(by: disposeBag)
    }
    
    private func configureView() {
        view.backgroundColor = .mainWhite
    }
    
    private func configureHierarchy() {
        view.add(
            navigationView,
            searchCollectionView,
            emptyView
        )
    }
    
    private func configureLayout() {
        navigationView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(44)
            $0.horizontalEdges.equalToSuperview()
        }
        
        searchCollectionView.snp.makeConstraints {
            $0.top.equalTo(navigationView.snp.bottom)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
        
        emptyView.snp.makeConstraints {
            $0.height.equalTo(269)
            $0.width.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
    }
}


// MARK: - CollectionView Layout
extension MyNoteSearchViewController {
    private func createDataSource() -> RxCollectionViewSectionedReloadDataSource<MyNoteSearchSectionModel> {
        return .init(
            configureCell: { [weak self] _, collectionView, indexPath, item in
                guard let self = self else { return UICollectionViewCell() }
                return collectionView.dequeueReusableCell(
                    MyNoteCell.self,
                    for: indexPath
                ).then {
                    $0.bind(item, relay: self.cellEventRelay)
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
