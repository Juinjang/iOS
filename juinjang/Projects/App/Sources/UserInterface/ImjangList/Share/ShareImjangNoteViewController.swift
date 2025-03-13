//
//  ShareImjangNoteViewController.swift
//  juinjang
//
//  Created by 강동영 on 3/7/25.
//

import UIKit
import ReactorKit
import RxCocoa
import RxDataSources

final class ShareImjangNoteViewController: BaseViewController {
    private var rootView: ShareImjangNoteView
    
    init(rootView: ShareImjangNoteView) {
        self.rootView = rootView
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = rootView
    }
    
    var disposeBag: DisposeBag = .init()
    private var selectedItem: Int?
    
    private lazy var dataSource = RxCollectionViewSectionedReloadDataSource<SectionOfShareList>(
        configureCell: { [weak self] (dataSource, collectionView, indexPath, item) in
            guard let self = self else { return UICollectionViewCell() }
            guard let section = Section(rawValue: indexPath.section) else { fatalError() }
            switch section {
            case .banner:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShareGuideBannerCell.identifier, for: indexPath) as? ShareGuideBannerCell else { return UICollectionViewCell() }
                
                return cell
                
            case .list:
                guard
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImjangNoteCollectionViewCell.identifier, for: indexPath) as? ImjangNoteCollectionViewCell,
                    let item = item as? ListDto
                else { return UICollectionViewCell() }
                
                cell.bookMarkButton.tag = indexPath.row
                cell.configureCell(imjangNote: item, isSelected: selectedItem == indexPath.item)
                return cell
            }
        }, configureSupplementaryView: { [weak self] dataSource, collectionView, kind, indexPath in
            guard let self = self else { return UICollectionReusableView() }
            if kind == UICollectionView.elementKindSectionHeader {
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ShareGuideHeaderCell.identifier, for: indexPath) as! ShareGuideHeaderCell
                
                let itemCount = dataSource.collectionView(collectionView, numberOfItemsInSection: indexPath.section)
                header.isHidden = itemCount == 0
                return header
            }
            
            if kind == UICollectionView.elementKindSectionFooter {
                let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: MoreButtonReusableCell.identifier, for: indexPath) as! MoreButtonReusableCell
                footer.rx.moreButtonTap
                    .map { ShareImjangNoteReactor.Action.tapLoadMore }
                    .bind(to: reactor!.action)
                    .disposed(by: disposeBag)
                
                return footer
            }
            return UICollectionReusableView()
        })
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        bind()
        
        reactor?.action.onNext(.viewDidLoad)
    }
    
    private func configureNavigationBar() {
        navigationItem.title = "\(UserDefaultManager.shared.nickname)님의 임장노트 나누기"
        navigationController?.navigationBar.tintColor = .black
        navigationItem.hidesBackButton = true
        let backButton = UIBarButtonItem.init(image: UIImage.arrowLeft)
        navigationItem.leftBarButtonItem = backButton
    }
    
    func bind() {
        navigationItem.leftBarButtonItem?.rx
            .tap
            .compactMap { Reactor.Action.tapPrevious }
            .bind(to: reactor!.action)
            .disposed(by: disposeBag)
    }
}

// MARK: ReactorKit bind Method
extension ShareImjangNoteViewController: View {
    func bind(reactor: ShareImjangNoteReactor) {
        reactor.state.map { state in
            [
                SectionOfShareList(header: "Banner", items: [1]),
                SectionOfShareList(header: "List", items: state.items)
            ]
        }
        .bind(to: rootView.rx.items(dataSource: dataSource))
        .disposed(by: disposeBag)
        
        // MARK: User Action
        
        rootView.rx.itemSelected
            .map { ShareImjangNoteReactor.Action.selectCell($0.item) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
            
        rootView.rx.newPageButtonTap
            .map { Reactor.Action.tapNavigateImjangNoteList }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        rootView.rx.nextButtonTap
            .map { Reactor.Action.tapNext }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // MARK: - State
        reactor.state
            .compactMap { $0.isEmptyViewVisible }
            .asDriver(onErrorJustReturn: true)
            .drive(rootView.rx.isEmptyBackgroundViewHidden)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.selectedIndex }
            .asDriver(onErrorJustReturn: nil)
            .drive(with: self, onNext: { owner, index in
                owner.selectedItem = index
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .compactMap { $0.isEnabledNextButton }
            .asDriver(onErrorJustReturn: false)
            .drive(rootView.rx.isNextButtonEnabled)
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

// MARK: - RxDataSources
extension ShareImjangNoteViewController {
    enum Section: Int {
        case banner
        case list
    }
    
    struct SectionOfShareList {
        var header: String?
        var items: [Item]
    }
}

extension ShareImjangNoteViewController.SectionOfShareList: SectionModelType {
    typealias Item = Any
    init(original: ShareImjangNoteViewController.SectionOfShareList, items: [Item]) {
        self = original
        self.items = items
    }
}

