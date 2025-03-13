//
//  ShareImjangNoteView.swift
//  juinjang
//
//  Created by 강동영 on 3/13/25.
//

import UIKit
import RxSwift
import RxCocoa

final class ShareImjangNoteView: BaseView {
    fileprivate let emptyBackgroundView: UIView = {
        let view: UIView = .init()
        view.isHidden = true
        return view
    }()
    
    private let emptyLogoImageView: UIImageView = {
        let emptyView: UIImageView = .init()
        emptyView.isHidden = true
        emptyView.design(
            image: UIImage.DivideImjangNote.empty,
            contentMode: .scaleAspectFit
        )
        return emptyView
    }()
    
    private let emptyMessageLabel: UILabel = {
        let emptyLabel: UILabel = .init()
        emptyLabel.textAlignment = .center
        emptyLabel.design(
            text: "임장노트 공유조건을 충족한 임장노트가 없어요\n조건을 채우러 가볼까요?",
            textColor: .gray400,
            font: .pretendard(size: 16, weight: .semiBold),
            textAlignment: .center,
            numberOfLines: 0
        )
        return emptyLabel
    }()
    
    fileprivate let newPageButton: UIButton = {
        let button: UIButton = .init()
        button.design(
            title: "나의 임장노트 가기",
            font: .pretendard(size: 16, weight: .semiBold),
            backgroundColor: .gray500,
            cornerRadius: 10
        )
        return button
    }()
    
    fileprivate let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: ShareImjangNoteView.createCollectionViewLayout())
        collectionView.contentInset.bottom = 24
        return collectionView
    }()
    
    private let nextButtonBackgroundView: UIView = .init()
    fileprivate let nextButton: FilledButton = {
        let button: FilledButton = .init(title: "다음으로")
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func configureHierarchy() {
        addSubview(collectionView)
        addSubview(emptyBackgroundView)
        addSubview(nextButtonBackgroundView)
        nextButtonBackgroundView.addSubview(nextButton)
        [emptyLogoImageView, emptyMessageLabel, newPageButton].forEach {
            emptyBackgroundView.addSubview($0)
        }
    }

    override func configureLayout() {
        emptyBackgroundView.snp.makeConstraints {
            $0.edges.equalTo(safeAreaLayoutGuide)
        }
        
        emptyLogoImageView.snp.makeConstraints {
            $0.centerX.equalTo(emptyBackgroundView)
            $0.size.equalTo(UIScreen.main.bounds.width * 0.55)
            $0.top.equalTo(emptyBackgroundView).offset(UIScreen.main.bounds.height * 0.30)
        }
        
        emptyMessageLabel.snp.makeConstraints {
            $0.horizontalEdges.equalTo(emptyBackgroundView).inset(36)
            $0.top.equalTo(emptyLogoImageView.snp.bottom).offset(8)
            $0.centerX.equalTo(emptyBackgroundView)
            $0.height.equalTo(46)
        }
        
        newPageButton.snp.makeConstraints {
            $0.width.equalTo(164)
            $0.height.equalTo(52)
            $0.centerX.equalTo(emptyBackgroundView)
            $0.top.equalTo(emptyMessageLabel.snp.bottom).offset(24)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(safeAreaLayoutGuide)
        }
        
        nextButtonBackgroundView.snp.makeConstraints {
            $0.top.equalTo(collectionView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        nextButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().inset(24)
        }
    }
    
    private func configureCollectionView() {
        collectionView.register(
            ShareGuideBannerCell.self,
            forCellWithReuseIdentifier: ShareGuideBannerCell.identifier
        )
        collectionView.register(
            ImjangNoteCollectionViewCell.self,
            forCellWithReuseIdentifier: ImjangNoteCollectionViewCell.identifier
        )
        
        collectionView.register(
            ShareGuideHeaderCell.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: ShareGuideHeaderCell.identifier
        )
        
        collectionView.register(
            MoreButtonReusableCell.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: MoreButtonReusableCell.identifier
        )
    }
}

// MARK: CompositionalLayout Methods
extension ShareImjangNoteView {
    enum Section: Int {
        case banner
        case list
    }
    
    private static func createCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { [self] sectionIndex, environment -> NSCollectionLayoutSection? in
            guard let imjangSection = Section(rawValue: sectionIndex) else { return nil }
            let section: NSCollectionLayoutSection
            
            switch imjangSection {
            case .banner:
                section = bannerLayout()
            case .list:
                section = listLayout()
            }
    
            return section
        }
        layout.register(ScrapCellBackground.self,
                        forDecorationViewOfKind: ScrapCellBackground.identifier)
        
        // 레이아웃 설정
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        configuration.interSectionSpacing = 16
        layout.configuration = configuration
        
        return layout
    }
    
    private static func bannerLayout() -> NSCollectionLayoutSection {
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
        
        return section
    }
    
    private static func listLayout() -> NSCollectionLayoutSection {
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
        section.contentInsets.bottom = 24
        
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(163)),
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        
        let sectionFooter = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(100)),
            elementKind: UICollectionView.elementKindSectionFooter,
            alignment: .bottom
        )
        sectionFooter.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 24,
            bottom: 0,
            trailing: 24
        )

        section.boundarySupplementaryItems = [sectionHeader, sectionFooter]
        
        return section
    }
}

// MARK: Reactive + ShareImjangNoteView
extension Reactive where Base: ShareImjangNoteView {
    func items<
            DataSource: RxCollectionViewDataSourceType & UICollectionViewDataSource,
            Source: ObservableType>
        (dataSource: DataSource)
        -> (_ source: Source)
    -> Disposable where DataSource.Element == Source.Element {
        base.collectionView.rx.items(dataSource: dataSource)
    }
    
    var itemSelected: ControlEvent<IndexPath> {
        let source = base.collectionView.rx.itemSelected
        return ControlEvent(events: source)
    }
    
    var isEmptyBackgroundViewHidden: Binder<Bool> {
        
        return base.emptyBackgroundView.rx.isHidden
    }
    
    var isNextButtonEnabled: Binder<Bool> {
        return base.nextButton.rx.isEnabled
    }
    
    var newPageButtonTap: ControlEvent<Void> {
        let source = base.newPageButton.rx.tap
        return ControlEvent(events: source)
    }
    
    var nextButtonTap: ControlEvent<Void> {
        let source = base.nextButton.rx.tap
        return ControlEvent(events: source)
    }
}
