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

enum MyNotePageEventType {
    case closeButtonTap(Int)
    case likeButtonTap(Int)
    case myNoteCellTap(Int)
    case filterItemTap(Int)
    case reachBottom(Int)
}

final class MyNotePageCell: UICollectionViewCell {
    
    private var disposeBag = DisposeBag()
    
    private let mainTitle: UILabel = {
        return UILabel().then {
            $0.textColor = .black
            $0.font = .systemFont(ofSize: 16, weight: .bold)
        }
    }()
    
    private lazy var innerCollectionView: UICollectionView = {
        return UICollectionView(frame: .zero,
                                collectionViewLayout: createCompositionalLayout()).then {
            $0.backgroundColor = .clear
            $0.register(MyNoteNoticeCell.self)
            $0.register(MyNoteCell.self)
            $0.contentInset = .init(top: 8, left: 0, bottom: 0, right: 0)
            $0.showsVerticalScrollIndicator = false
        }
    }()
            
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupLayout()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.add([
            innerCollectionView,
            mainTitle
        ])
    }
    
    private func setupLayout() {
        innerCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        mainTitle.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    func bind(sections: [MyNoteSectionModel],
              relay: PublishRelay<MyNotePageEventType>) {
        disposeBag = DisposeBag()
        
        Observable.just(sections)
            .bind(
                to: innerCollectionView.rx.items(
                    dataSource: createDataSource(relay: relay)
                )
            )
            .disposed(by: disposeBag)
        
        innerCollectionView.rx.didScroll
            .withUnretained(self)
            .subscribe { (self, _) in
                let offsetY = self.innerCollectionView.contentOffset.y
                let contentHeight = self.innerCollectionView.contentSize.height
                let frameHeight = self.innerCollectionView.frame.size.height
                
                let distanceFromBottom = contentHeight - (offsetY + frameHeight)
                
                if distanceFromBottom <= 0 {
                    print("✅ 마지막 셀 근처에 도달했다!")
                    // 여기에 pageEventRelay 같은 거 전달해주면 됨!
                    relay.accept(.reachBottom(0))
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func createDataSource(relay: PublishRelay<MyNotePageEventType>) -> RxCollectionViewSectionedReloadDataSource<MyNoteSectionModel> {
        return .init(configureCell: { _, collectionView, indexPath, item in
            switch item {
            case let .notice(category):
                guard let cell = collectionView.dequeueReusableCell(MyNoteNoticeCell.self, indexPath) else {
                    return UICollectionViewCell()
                }
                cell.bind(category: category, relay: relay)
                return cell
                
            case let .note(note):
                guard let cell = collectionView.dequeueReusableCell(MyNoteCell.self, indexPath) else {
                    return UICollectionViewCell()
                }
                cell.bind(note)
                return cell
            }
        })
    }
    
    private func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            
            let itemHeight: CGFloat
            
            switch sectionIndex {
            case 0:
                itemHeight = 56
            case 1:
                itemHeight = 136
            default:
                itemHeight = 0
            }
            
            // 셀 크기: 전체 가로 너비, 높이 150
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(itemHeight)
            )
            
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            // 그룹: 단일 아이템 그룹 (리스트 형태)
            let groupSize = itemSize
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: groupSize,
                subitems: [item]
            )
            
            // 섹션 생성
            let section = NSCollectionLayoutSection(group: group).then {
                $0.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
                $0.interGroupSpacing = 0
            }
            
            return section
        }
        
        return layout
    }
}
