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

final class MyNotePageCell: UICollectionViewCell {
    
    private var disposeBag = DisposeBag()
    
    private let mainTitle: UILabel = {
        UILabel().then {
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
        }
    }()
    
    private lazy var dataSource = RxCollectionViewSectionedReloadDataSource<MyNoteSectionModel>(
        configureCell: { _, collectionView, indexPath, item in
            switch item {
            case let .notice(category):
                guard let cell = collectionView.dequeueReusableCell(MyNoteNoticeCell.self, indexPath) else {
                    return UICollectionViewCell()
                }
                cell.bind(category: category)
                return cell
                
            case let .note(note):
                guard let cell = collectionView.dequeueReusableCell(MyNoteCell.self, indexPath) else {
                    return UICollectionViewCell()
                }
                
                return cell
            }
        }
    )
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(innerCollectionView)
        contentView.addSubview(mainTitle)
    }
    
    private func setupLayout() {
        innerCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        mainTitle.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    func bind(sections: [MyNoteSectionModel], title: String) {
        disposeBag = DisposeBag()
        
        Observable.just(sections)
            .bind(to: innerCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        mainTitle.text = title
    }
    
    private func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            
            let itemHeight: CGFloat
            
            switch sectionIndex {
            case 0:
                itemHeight = 56 // 공지 셀 (MyNoteNoticeCell)
            default:
                itemHeight = 150 // 일반 노트 셀 (MyNoteCell)
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
                $0.interGroupSpacing = 10
            }
            
            return section
        }
        
        return layout
    }
}
