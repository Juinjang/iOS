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
            $0.register(
                ImjangDetailCheckListHeaderView.self,
                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader
            )
            $0.register(
                WhiteSpacerFooterView.self,
                forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter
            )
        }
    }()
    
    let topFloatingButton = TopFloatingButton()
    
    override func configureView() {
        super.configureView()
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        
        add(navigationView, detailCollectionView, topFloatingButton)
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
        
        topFloatingButton.snp.makeConstraints {
            $0.size.equalTo(48)
            $0.right.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().inset(36)
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
                return self.singleItemSection(height: self.heightDifferenceFromOriginal())
            case .report:
                return self.singleItemSection(height: 590)
            case .checkList:
                return self.checkListSection(cellHeight: 98, headerHeight: 129)
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
    
    private func checkListSection(cellHeight: CGFloat,
                                  headerHeight: CGFloat) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .absolute(cellHeight))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .estimated(cellHeight))
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)

        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .absolute(headerHeight))
        
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        
        let footer = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(32)),
            elementKind: UICollectionView.elementKindSectionFooter,
            alignment: .bottom
        )
        
        section.boundarySupplementaryItems = [header, footer]
        return section
    }
}

extension ImjangDetailView {
    private func heightDifferenceFromOriginal() -> CGFloat {
        let newWidth = UIScreen.main.bounds.width
        let originalWidth: CGFloat = 389
        let originalHeight: CGFloat = 171
        let scaledHeight = newWidth * (originalHeight / originalWidth)
        
        return self.infoCellHeight-(originalHeight - scaledHeight)
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
            view.infoCellHeight = infoItem.model.buyerCount < 10 ? CGFloat(612) : CGFloat(654)
            view.reviewCellHeight = infoItem.model.isBuyer ? CGFloat(615) : CGFloat(223)
        }
    }
    
    var isTopButtonVisible: Binder<Bool> {
        return Binder(base) { view, visible in
            if visible {
                view.topFloatingButton.isHidden = false
                view.topFloatingButton.alpha = 0
                UIView.animate(withDuration: 0.25) {
                    view.topFloatingButton.alpha = 1
                }
            } else {
                UIView.animate(withDuration: 0.25, animations: {
                    view.topFloatingButton.alpha = 0
                }) { _ in
                    view.topFloatingButton.isHidden = true
                }
            }
        }
    }
    
    var scrollToTop: Binder<Void> {
        return Binder(base) { view, _ in
            view.detailCollectionView.setContentOffset(.zero, animated: true)
        }
    }
}


