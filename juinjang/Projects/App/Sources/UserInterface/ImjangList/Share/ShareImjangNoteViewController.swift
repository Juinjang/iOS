//
//  ShareImjangNoteViewController.swift
//  juinjang
//
//  Created by 강동영 on 3/7/25.
//

import UIKit
import ReactorKit
import RxCocoa

final class ShareImjangNoteViewController: BaseViewController, View {
 
    private let emptyBackgroundView: UIView = {
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
    
    private let newPageButton: UIButton = {
        let button: UIButton = .init()
        button.design(
            title: "나의 임장노트 가기",
            font: .pretendard(size: 16, weight: .semiBold),
            backgroundColor: .gray500,
            cornerRadius: 10
        )
        return button
    }()
    
    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: ShareImjangNoteViewController.createCollectionViewLayout())
        collectionView.contentInset.bottom = 24
        return collectionView
    }()
    
    private let nextButtonBackgroundView: UIView = .init()
    private let nextButton: FilledButton = {
        let button: FilledButton = .init(title: "다음으로")
        
        return button
    }()
    
    var disposeBag: DisposeBag = .init()
    private var sectionList: [Section] = [.banner, .list]
    private let imjangListRelay: BehaviorRelay<[ListDto]> = .init(value: [])
    private var imjangList: [ListDto] = []
    var selectedItem: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        bind()
        
        configureHierarchy()
        configureLayout()
        configureView()
        configureCollectionView()
        reactor?.action.onNext(.viewDidLoad)
    }
    
    private func configureNavigationBar() {
        navigationItem.title = "\(UserDefaultManager.shared.nickname)님의 임장노트 나누기"
        navigationController?.navigationBar.tintColor = .black
        navigationItem.hidesBackButton = true
        let backButton = UIBarButtonItem.init(image: UIImage.arrowLeft)
        navigationItem.leftBarButtonItem = backButton
    }
    
    private func configureHierarchy() {
        view.addSubview(collectionView)
        view.addSubview(emptyBackgroundView)
        view.addSubview(nextButtonBackgroundView)
        nextButtonBackgroundView.addSubview(nextButton)
        [emptyLogoImageView, emptyMessageLabel, newPageButton].forEach {
            emptyBackgroundView.addSubview($0)
        }
    }

    private func configureLayout() {
        emptyBackgroundView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
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
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
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
    
    private func configureView() {
        view.backgroundColor = .mainWhite
    }
    
    private func configureCollectionView() {
        collectionView.register(
            DivideGuideBannerCell.self,
            forCellWithReuseIdentifier: DivideGuideBannerCell.identifier
        )
        collectionView.register(
            ImjangNoteCollectionViewCell.self,
            forCellWithReuseIdentifier: ImjangNoteCollectionViewCell.identifier
        )
        
        collectionView.register(
            DivideGuideHeaderCell.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: DivideGuideHeaderCell.identifier
        )
        
        collectionView.register(
            MoreButtonReusableCell.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: MoreButtonReusableCell.identifier
        )
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func bind() {
        navigationItem.leftBarButtonItem?.rx
            .tap
            .compactMap { Reactor.Action.tapPrevious }
            .bind(to: reactor!.action)
            .disposed(by: disposeBag)
    }
    
    func bind(reactor: ShareImjangNoteReactor) {
        // MARK: User Action
        newPageButton.rx.tap
            .map { Reactor.Action.tapNavigateImjangNoteList }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state
            .compactMap { $0.items }
            .subscribe(with: self, onNext: { owner, items in
                owner.imjangListRelay.accept(items)
            })
            .disposed(by: disposeBag)
        
        imjangListRelay
            .asDriver()
            .drive(with: self, onNext: { owner, items in
                owner.imjangList = items
                owner.collectionView.reloadData()
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .compactMap { $0.isEmptyViewVisible }
            .asDriver(onErrorJustReturn: true)
            .drive(emptyBackgroundView.rx.isHidden)
            .disposed(by: disposeBag)
        
        reactor.state
            .compactMap { $0.isEnabledNextButton }
            .asDriver(onErrorJustReturn: false)
            .drive(nextButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.selectedItem }
            .asDriver(onErrorJustReturn: nil)
            .drive(with: self, onNext: { owner, _ in
                owner.collectionView.reloadData()
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .compactMap { $0.navigation }
            .subscribe(with: self, onNext: { owner, navigation in
                switch navigation {
                case .previous, .imjangNote:
                    owner.navigationController?.popViewController(animated: true)
                    
                case .next:
                    // FIXME: Next 생긴 후 교체 예정
                    owner.navigationController?.popViewController(animated: true)
                    
                }
            })
            .disposed(by: disposeBag)
    }
    
}

extension ShareImjangNoteViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        sectionList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let section = Section(rawValue: section) else { return 0 }
        switch section {
        case .banner:
            return 1
        case .list:
            return imjangList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let section = Section(rawValue: indexPath.section) else { fatalError() }
        switch section {
        case .banner:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DivideGuideBannerCell.identifier, for: indexPath) as? DivideGuideBannerCell else { return UICollectionViewCell() }
            
            return cell
        case .list:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImjangNoteCollectionViewCell.identifier, for: indexPath) as? ImjangNoteCollectionViewCell else { return UICollectionViewCell() }
            
            let item = imjangList[indexPath.item]
            cell.bookMarkButton.tag = indexPath.row
            cell.configureCell(imjangNote: item, isSelected: selectedItem == indexPath.item)
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if selectedItem == indexPath.item {
            selectedItem = nil
        } else {
            selectedItem = indexPath.item
        }
        
        guard let item = selectedItem else {
            reactor?.action.onNext(.selectCell(nil))
            return
        }
        reactor?.action.onNext(.selectCell(imjangList[item]))
        
        
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: DivideGuideHeaderCell.identifier, for: indexPath) as! DivideGuideHeaderCell
            let itemCount = self.collectionView(collectionView, numberOfItemsInSection: indexPath.section)
            header.isHidden = itemCount == 0
            return header
        }
        
        if kind == UICollectionView.elementKindSectionFooter {
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: MoreButtonReusableCell.identifier, for: indexPath) as! MoreButtonReusableCell
            footer.rx.moreButtonTap
                .map { ShareImjangNoteReactor.Action.tapNext }
                .bind(to: reactor!.action)
                .disposed(by: disposeBag)
            
            return footer
        }
        return UICollectionReusableView()
    }
}

extension ShareImjangNoteViewController {
    enum Section: Int, CaseIterable {
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

fileprivate class DivideGuideBannerCell: UICollectionViewCell {
    private let bannerImageView: UIImageView = {
        let bannerView: UIImageView = .init(image: .DivideImjangNote.guideBanner)
        bannerView.contentMode = .scaleAspectFit
        return bannerView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        contentView.addSubview(bannerImageView)
        bannerImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

fileprivate class DivideGuideHeaderCell: UICollectionReusableView {
    private let descriptionLabel1: UILabel = {
        let emptyLabel: UILabel = .init()
        emptyLabel.design(
            text: "임장노트 한 개를 선택해주세요!",
            textColor: .gray600,
            font: .pretendard(size: 20, weight: .semiBold),
            textAlignment: .left,
            numberOfLines: 0
        )
        return emptyLabel
    }()
    
    private let descriptionLabel2: UILabel = {
        let label: UILabel = .init()
        label.textAlignment = .left
        label.design(
            text: "임장노트는 \"임장 둘러보기\"를 통해\n다른 임장러에게 공유돼요.",
            textColor: .gray400,
            font: .pretendard(size: 14, weight: .semiBold),
            textAlignment: .left,
            numberOfLines: 0
        )
        return label
    }()
    
    private let pencilContentView: UIView = {
        let view: UIView = .init()
        view.backgroundColor = .gray100
        return view
    }()
    
    private let pencilImageView: UIImageView = {
        let emptyView: UIImageView = .init()
        emptyView.design(
            image: UIImage.DivideImjangNote.pencilCircle,
            contentMode: .scaleAspectFit
        )
        return emptyView
    }()
    
    private let pencilDescriptionLabel: UILabel = {
        let emptyLabel: UILabel = .init()
        emptyLabel.textAlignment = .center
        emptyLabel.design(
            text: "임장노트를 공유하면 받을 수 있는 연필",
            textColor: .gray500,
            font: .pretendard(size: 14, weight: .semiBold),
            textAlignment: .left,
            numberOfLines: 0
        )
        return emptyLabel
    }()
    
    private let pencilCountLabel: UILabel = {
        let emptyLabel: UILabel = .init()
        emptyLabel.textAlignment = .right
        emptyLabel.design(
            text: "0개",
            textColor: .main,
            font: .pretendard(size: 16, weight: .semiBold),
            textAlignment: .center,
            numberOfLines: 0
        )
        return emptyLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        backgroundColor = .white
        addSubview(descriptionLabel1)
        addSubview(descriptionLabel2)
        addSubview(pencilContentView)
        [pencilImageView, pencilDescriptionLabel, pencilCountLabel].forEach {
            pencilContentView.addSubview($0)
        }
        
        descriptionLabel1.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(24)
        }
        descriptionLabel2.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel1.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        
        pencilContentView.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel2.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview()
        }
        
        pencilImageView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(10)
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(16)
            $0.size.equalTo(28)
        }
        
        pencilDescriptionLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(pencilImageView.snp.trailing).offset(16)
        }
        
        pencilCountLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.greaterThanOrEqualTo(pencilDescriptionLabel.snp.trailing).offset(40)
            $0.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview()
        }
    }
}





fileprivate class MoreButtonReusableCell: UICollectionReusableView {
    fileprivate let moreButton: PaddingButton = {
        let button: PaddingButton = .init(
            padding: UIEdgeInsets(top: 12.0, left: 0.0, bottom: 12.0, right: 0.0)
        )
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = .gray100
        configuration.title = "더보기"
        configuration.baseForegroundColor = .gray450
        configuration.image = .ImjangList.arrowDown
        configuration.imagePlacement = .trailing
        button.configuration = configuration
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        backgroundColor = .gray100
        layer.cornerRadius = 10
        addSubview(moreButton)
        
        
        moreButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

extension Reactive where Base: MoreButtonReusableCell {
    var moreButtonTap: ControlEvent<Void> {
        let source = base.moreButton.rx.tap
        return ControlEvent(events: source)
    }
}

@available(iOS 17.0, *)
#Preview {
    let vc = ShareImjangNoteViewController()
    vc.reactor = ShareImjangNoteReactor(repository: MockShareImjangNoteRepository())
    return vc
}
