//
//  MyNoteStopShareView.swift
//  juinjang
//
//  Created by KimDongWoo on 3/29/25.
//

import UIKit
import SnapKit
import Then
import RxSwift

final class MyNoteStopShareView: BaseView {
    let navigationView = DefaultNavigationView().then {
        $0.titleColor = .gray400
        $0.title = "공유를 중단할 노트를 선택해 주세요"
        $0.leftItem = [.pop]
    }
    
    let selectedCountLabel = UILabel().then {
        $0.font = .pretendard(size: 14, weight: .medium)
        $0.textColor = .gray400
        $0.text = "0개 선택됨"
    }
    
    lazy var stopShareCollectionView: UICollectionView = {
        return UICollectionView(
            frame: .zero,
            collectionViewLayout: createCompositionalLayout()
        ).then {
            $0.register(MyNoteCell.self)
            $0.showsVerticalScrollIndicator = false
        }
    }()
    
    let removeButton = UIButton().then {
        $0.setTitle("삭제하기", for: .normal)
        $0.titleLabel?.font = .pretendard(size: 16, weight: .semiBold)
        $0.titleLabel?.textColor = .mainWhite
        $0.roundCorners(cornerRadius: 10, corner: .all)
        $0.backgroundColor = .main
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        add(
            navigationView,
            selectedCountLabel,
            stopShareCollectionView,
            removeButton
        )
    }
    
    override func configureLayout() {
        super.configureLayout()
        
        navigationView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(44)
        }
        
        selectedCountLabel.snp.makeConstraints {
            $0.top.equalTo(navigationView.snp.bottom).offset(6)
            $0.height.equalTo(43)
            $0.horizontalEdges.equalToSuperview().inset(24)
        }
        
        stopShareCollectionView.snp.makeConstraints {
            $0.top.equalTo(selectedCountLabel.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(removeButton.snp.top).offset(-12)
        }
        
        removeButton.snp.makeConstraints {
            $0.height.equalTo(52)
            $0.bottom.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview().inset(24)
        }
    }
}

// MARK: - CollectionView Layout
extension MyNoteStopShareView {
    private func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(148)
            )
            
            let item = NSCollectionLayoutItem(layoutSize: itemSize).then {
                $0.contentInsets = NSDirectionalEdgeInsets(top: 6, leading: 24, bottom: 6, trailing: 24)
            }
            
            let groupSize = itemSize
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: groupSize,
                subitems: [item]
            )
            
            let section = NSCollectionLayoutSection(group: group).then {
                $0.contentInsets = NSDirectionalEdgeInsets(top: 6, leading: 0, bottom: 0, trailing: 0)
                $0.interGroupSpacing = 0
            }
            
            return section
        }
        
        return layout
    }
}

extension Reactive where Base: MyNoteStopShareView {
    var selectedCount: Binder<Int> {
        return Binder(base) { view, count in
            view.selectedCountLabel.text = "\(count)개 선택됨"
            view.selectedCountLabel.textColor = count > 0 ? .main : .gray400
            view.removeButton.backgroundColor = count == 0 ? .null : .main
            view.removeButton.isEnabled = count == 0 ? false : true
        }
    }
}
