//
//  ImjangDetailView.swift
//  juinjang
//
//  Created by KimDongWoo on 4/9/25.
//

import UIKit
import Then
import SnapKit
import RxSwift

final class ImjangDetailView: BaseView {
    fileprivate let navigationView = DefaultNavigationView().then {
        $0.leftItem = [.pop]
    }
    
    fileprivate var infoCellHeight: CGFloat = 0
    fileprivate var reviewCellHeight: CGFloat = 0
    
    lazy var detailCollectionView: UICollectionView = {
        return UICollectionView(frame: .zero, collectionViewLayout: createLayout()).then {
            $0.register(
                ImjangDetailInfoCell.self,
                ImjangDetailReportCell.self,
                ImjangDetailCheckListCell.self,
                ImjangDetailReviewCell.self
            )
        }
    }()
    
    override func configureView() {
        super.configureView()
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        
        add(navigationView, detailCollectionView)
    }
    
    override func configureLayout() {
        super.configureLayout()
        
        navigationView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
        }
        
        detailCollectionView.snp.makeConstraints {
            $0.top.equalTo(navigationView.snp.bottom)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
    }
}

// MARK: - Setup Layout
extension ImjangDetailView {
    private func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, _ in
            guard let section = ImjangDetailSection(rawValue: sectionIndex) else { return nil }
            
            switch section {
            case .info:
                return self.singleItemSection(height: self.infoCellHeight)
            case .report:
                return self.singleItemSection(height: 590)
            case .checkList:
                return self.singleItemSection(height: 455)
            case .review:
                return self.singleItemSection(height: self.reviewCellHeight)
            }
        }
    }
    
    private func singleItemSection(height: CGFloat) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(height))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        return section
    }
}

extension Reactive where Base: ImjangDetailView {
    var navigationTitle: Binder<String> {
        return Binder(base) { view, title in
            view.navigationView.title = title
        }
    }
    
    var updateLayoutBasedOnInfoSection: Binder<[ImjangDetailSection: [BaseCellItem]]> {
        return Binder(base) { view, sectionItems in
            guard let infoItem = sectionItems[.info]?.first as? ImjangDetailInfoCellItem else { return }
            view.infoCellHeight = infoItem.model.isBuyer ? CGFloat(646) : CGFloat(688)
            view.reviewCellHeight = infoItem.model.isBuyer ? CGFloat(603) : CGFloat(223)
        }
    }
}
