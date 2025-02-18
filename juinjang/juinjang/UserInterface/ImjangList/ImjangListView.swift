//
//  ImjangListView.swift
//  juinjang
//
//  Created by 조유진 on 11/17/24.
//

import UIKit
import SkeletonView

enum Section: Int, CaseIterable {
    case scrap
    case list
}

final class ImjangListView: UIView {
    // 임장 노트가 존재하지 않을 때의 뷰
    let emptyBackgroundView = UIView()
    private let emptyLogoImageView = UIImageView()
    private let emptyMessageLabel = UILabel()
    let newPageButton = UIButton()
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCollectionViewLayout(isScrapEmpty: true))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureLayout()
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureHierarchy() {
        addSubview(emptyBackgroundView)
        [emptyLogoImageView, emptyMessageLabel, newPageButton].forEach {
            emptyBackgroundView.addSubview($0)
        }
        addSubview(collectionView)
    }
    
    private func configureLayout() {
        emptyBackgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        emptyLogoImageView.snp.makeConstraints {
            $0.centerX.equalTo(emptyBackgroundView)
            $0.size.equalTo(UIScreen.main.bounds.width * 0.29)
            $0.top.equalTo(emptyBackgroundView).offset(UIScreen.main.bounds.height * 0.30)
        }
        
        emptyMessageLabel.snp.makeConstraints {
            $0.horizontalEdges.equalTo(emptyBackgroundView).inset(36)
            $0.top.equalTo(emptyLogoImageView.snp.bottom).offset(36)
            $0.centerX.equalTo(emptyBackgroundView)
            $0.height.equalTo(46)
        }
        
        newPageButton.snp.makeConstraints {
            $0.width.equalTo(164)
            $0.height.equalTo(52)
            $0.centerX.equalTo(emptyBackgroundView)
            $0.top.equalTo(emptyMessageLabel.snp.bottom).offset(36)
        }
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
    }
    
    private func configureView() {
        backgroundColor = .white
        emptyBackgroundView.isHidden = true     // 일단 숨겨놓기
        
        // 비었을 때 로고 이미지뷰
        emptyLogoImageView.design(image: UIImage(named: "nomaemull")!,
                         contentMode: .scaleAspectFit)
        // 비었을 때 추가 권유 메시지 레이블
        emptyMessageLabel.design(text: "아직 등록된 집이 없어요\n지금 바로 부동산을 추가해 볼까요?",
                                 textColor: ColorStyle.textGray,
                                 font: .pretendard(size: 16, weight: .semiBold),
                                 textAlignment: .center,
                                 numberOfLines: 0)
        emptyMessageLabel.setLineSpacing(spacing: 4)
        emptyMessageLabel.textAlignment = .center


        // 새 페이지 펼치기 버튼
        newPageButton.design(title: "새 페이지 펼치기",
                             font: .pretendard(size: 16, weight: .semiBold),
                             backgroundColor: ColorStyle.textBlack,
                             cornerRadius: 10)
        
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.register(
            ImjangNoteCollectionViewCell.self,
            forCellWithReuseIdentifier: ImjangNoteCollectionViewCell.identifier
        )
        collectionView.register(
            ScrapCollectionViewCell.self,
            forCellWithReuseIdentifier: ScrapCollectionViewCell.identifier
        )
        collectionView.register(
            ImjangListHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: ImjangListHeader.identifier
        )
        collectionView.register(
            ScrapCellEmptyBackground.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: ScrapCellEmptyBackground.identifier
        )
        
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isSkeletonable = true
    }
}

extension ImjangListView {
    
    func createCollectionViewLayout(isScrapEmpty: Bool) -> UICollectionViewCompositionalLayout {
        print(#function, isScrapEmpty)
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, environment -> NSCollectionLayoutSection? in
            guard let self else { return nil }
            if let imjangSection = Section(rawValue: sectionIndex) {
                let section: NSCollectionLayoutSection
                
                switch imjangSection {
                case .scrap:
                    section = isScrapEmpty ? scrapEmptyLayout() : scrapLayout()
                case .list:
                    section = listLayout()
                }
        
                return section
            } else {
                return nil
            }
        }
        layout.register(ScrapCellBackground.self,
                        forDecorationViewOfKind: ScrapCellBackground.identifier)
        
        // 레이아웃 설정
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        configuration.interSectionSpacing = 16
        layout.configuration = configuration
        
        return layout
    }
    
    private func scrapLayout() -> NSCollectionLayoutSection {
        print(#function)
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(UIScreen.main.bounds.width - 88),
            heightDimension: .absolute(220))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(UIScreen.main.bounds.width - 88),
            heightDimension: .absolute(252))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        group.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 0, bottom: 16, trailing: 0)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8
        section.orthogonalScrollingBehavior = .groupPagingCentered
        
        section.visibleItemsInvalidationHandler = { visibleItems, offset, environment in
            visibleItems
                .filter { $0.representedElementCategory == .cell } // 셀만 필터링
                .forEach { item in
                    let intersectedRect = item.frame.intersection(CGRect(x: offset.x, y: offset.y, width: environment.container.contentSize.width, height: item.frame.height))
                    let percentVisible = intersectedRect.width / item.frame.width
                    let scale = 0.85 + (0.15 * percentVisible)
                    item.transform = CGAffineTransform(scaleX: 0.98, y: scale)
                }
        }
        
        let sectionBackgroundDecoration = NSCollectionLayoutDecorationItem.background(elementKind: ScrapCellBackground.identifier)
        section.decorationItems = [sectionBackgroundDecoration]
        section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 0, bottom: 0, trailing: 0)
    
        return section
    }
    
    private func scrapEmptyLayout() -> NSCollectionLayoutSection {
        print(#function)
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(1))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(114)
        )
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        section.boundarySupplementaryItems = [header]
    
        return section
    }
    
    private func listLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(106))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 24, bottom: 0, trailing: 24)
        
        let section = NSCollectionLayoutSection(group: group)
        
        section.interGroupSpacing = 8
        
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                       heightDimension: .absolute(49)),
                    elementKind: UICollectionView.elementKindSectionHeader,
                    alignment: .top
                )
        sectionHeader.pinToVisibleBounds = true
        sectionHeader.zIndex = 2
        section.boundarySupplementaryItems = [sectionHeader]
        
        return section
    }
}
