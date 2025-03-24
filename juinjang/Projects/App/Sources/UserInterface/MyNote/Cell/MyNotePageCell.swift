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
    case noticeCloseButtonTap(Int)
    case likeButtonTap(Int)
    case myNoteCellTap(Int)
    case filterItemTap(Int, TransactionTypeAction?, SaleTypeAction?)
}

final class MyNotePageCell: UICollectionViewCell {
    private var disposeBag = DisposeBag()
    
    private lazy var innerCollectionView: UICollectionView = {
        return UICollectionView(frame: .zero,
                                collectionViewLayout: createCompositionalLayout(isExpanded: true)).then {
            $0.register(MyNoteCell.self)
            $0.showsVerticalScrollIndicator = false
        }
    }()
    
    private let filterHeaderView = MyNoteFilterHeader()
                
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
        filterHeaderView.prepareForReuse()
    }
    
    private func setupUI() {
        contentView.add([
            filterHeaderView,
            innerCollectionView
        ])
        contentView.bringSubviewToFront(filterHeaderView)
    }
    
    private func setupLayout() {
        filterHeaderView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
        }
        
        innerCollectionView.snp.makeConstraints {
            $0.top.equalTo(filterHeaderView.snp.bottom)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
    }
    
    func bind(page: MyNotePageModel,
              relay: PublishRelay<MyNotePageEventType>) {
        disposeBag = DisposeBag()
        
        filterHeaderView.configure(pageModel: page,
                                   relay: relay)
        
        Observable.just([page])
            .bind(
                to: innerCollectionView.rx.items(
                    dataSource: createDataSource(relay: relay)
                )
            )
            .disposed(by: disposeBag)
    }
    
    private func createDataSource(relay: PublishRelay<MyNotePageEventType>) -> RxCollectionViewSectionedReloadDataSource<MyNotePageModel> {
        return .init(
            configureCell: { _, collectionView, indexPath, item in
                return collectionView.dequeueReusableCell(
                    MyNoteCell.self,
                    for: indexPath
                ).then {
                    $0.bind(item)
                }
            }
        )
    }
    
    private func createCompositionalLayout(isExpanded: Bool) -> UICollectionViewLayout {
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
