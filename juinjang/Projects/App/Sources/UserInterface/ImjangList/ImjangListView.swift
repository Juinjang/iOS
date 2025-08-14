//
//  ImjangListView.swift
//  juinjang
//
//  Created by 조유진 on 11/17/24.
//

import UIKit
import SkeletonView
import SnapKit
import Then

enum Section: Int, CaseIterable {
    case scrap
    case list
}

final class ImjangListView: UIView {
    let navigationView = DefaultNavigationView().then {
        $0.leftItem = [.pop]
        $0.rightItem = [.search, .add]
        $0.title = "\(UserDefaultManager.shared.nickname)님의 임장노트"
    }
    
    // 임장 노트가 존재하지 않을 때의 뷰
    let emptyBackgroundView = UIView()
    let emptyLogoImageView = UIImageView()
    let emptyMessageLabel = UILabel()
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
        add(
            navigationView,
            emptyBackgroundView,
            collectionView
        )
        
        emptyBackgroundView.add(
            emptyLogoImageView,
            emptyMessageLabel,
            newPageButton
        )
    }
    
    private func configureLayout() {
        navigationView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
        }
        
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
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(navigationView.snp.bottom)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
        
        bringSubviewToFront(navigationView)
    }
    
    private func configureView() {
        backgroundColor = .mainWhite
        emptyBackgroundView.isHidden = true     // 일단 숨겨놓기
        emptyLogoImageView.isHidden = true
        emptyMessageLabel.isHidden = true
        newPageButton.isHidden = true
        collectionView.isHidden = true
        
        collectionView.backgroundColor = .mainWhite
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
    
    func hasResults(_ hasResults: Bool) {
        emptyBackgroundView.isHidden = hasResults
        emptyLogoImageView.isHidden = hasResults
        emptyMessageLabel.isHidden = hasResults
        newPageButton.isHidden = hasResults
        collectionView.isHidden = !hasResults
    }
    
    func setupEmptyView(isEmpty: Bool) {
        emptyBackgroundView.isHidden = !isEmpty
        
        guard isEmpty else { return }
        // 비었을 때 로고 이미지뷰
        emptyLogoImageView.design(image: UIImage.Main.nomaemull,
                                  contentMode: .scaleAspectFit)
        // 비었을 때 추가 권유 메시지 레이블
        emptyMessageLabel.design(text: "아직 등록된 집이 없어요\n지금 바로 부동산을 추가해 볼까요?",
                                 textColor: .gray400,
                                 font: .pretendard(size: 16, weight: .semiBold),
                                 textAlignment: .center,
                                 numberOfLines: 0)
        emptyMessageLabel.setLineSpacing(spacing: 4)
        emptyMessageLabel.textAlignment = .center
        
        // 새 페이지 펼치기 버튼
        newPageButton.design(title: "새 페이지 펼치기",
                             font: .pretendard(size: 16, weight: .semiBold),
                             backgroundColor: .gray500,
                             cornerRadius: 10)
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
        configuration.interSectionSpacing = 12
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
        
        group.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 0, bottom: 12, trailing: 0)
        
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
            heightDimension: .estimated(126)
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
            heightDimension: .absolute(136))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 22, bottom: 0, trailing: 22)
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(49)),
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        sectionHeader.pinToVisibleBounds = false
        sectionHeader.zIndex = 2
        section.boundarySupplementaryItems = [sectionHeader]
        
        return section
    }
}
