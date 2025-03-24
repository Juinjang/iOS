//
//  MyNoteViewController.swift
//  juinjang
//
//  Created by KimDongWoo on 3/11/25.
//

import UIKit
import ReactorKit
import RxCocoa
import Then
import SnapKit
import RxDataSources

final class MyNoteViewController: BaseViewController, View {
    var disposeBag = DisposeBag()
    
    private let navigationView = DefaultNavigationView().then {
        $0.title = "마이노트"
        $0.leftItem = [.pop]
        $0.rightItem = [.search]
    }
    
    private lazy var segmentedView: UnderLineSegmentedView = {
        return UnderLineSegmentedView(
            titles: MyNoteCategoryType.allCases.map { $0.toText },
            horizontalInset: 46.5
        ).then {
            $0.bind(to: pageContainerCollectionView)
        }
    }()
    
    private lazy var pageContainerCollectionView: UICollectionView = {
        return UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout().then {
                $0.scrollDirection = .horizontal
                $0.minimumLineSpacing = 0
                $0.minimumInteritemSpacing = 0
                $0.sectionInset = .zero
            }
        ).then {
            $0.bounces = false
            $0.isPagingEnabled = true
            $0.showsHorizontalScrollIndicator = false
            $0.register(MyNotePageCell.self)
        }
    }()
    
    private let pageCellEventRelay = PublishRelay<MyNotePageEventType>()
    
    private lazy var pageDataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<Void, MyNotePageModel>>(
        configureCell: { [weak self] _, collectionView, indexPath, item in
            guard let self = self else { return UICollectionViewCell() }
            
            return collectionView.dequeueReusableCell(
                MyNotePageCell.self,
                for: indexPath
            ).then {
                $0.bind(
                    page: item,
                    relay: self.pageCellEventRelay
                )
            }
        }
    )
    
    init(reactor: MyNoteViewReactor) {
        super.init()
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        makeConstraints()
        reactor?.action.onNext(.viewDidLoad)
    }
    
    func bind(reactor: MyNoteViewReactor) {
        reactor.state
            .map { state -> [SectionModel<Void, MyNotePageModel>] in
                return [SectionModel(model: (), items: state.pages)]
            }
            .bind(to: pageContainerCollectionView.rx.items(dataSource: pageDataSource))
            .disposed(by: disposeBag)
                
        navigationView
            .itemActionRelay
            .withUnretained(self)
            .subscribe { (self, action) in
                switch action {
                case .popButtonTap:
                    self.navigationController?.popViewController(animated: true)
                case .searchButtonTap:
                    print("push MyNoteSearchViewController")
                default:
                    break
                }
            }
            .disposed(by: disposeBag)
        
        segmentedView
            .scrollSelectedRelay
            .map { Reactor.Action.categoryButtonDidTap($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        segmentedView
            .buttonTapSelectedRelay
            .withUnretained(self)
            .subscribe { (self, index) in
                self.pageContainerCollectionView.scrollToItem(
                    at: IndexPath(item: index, section: 0),
                    at: .centeredHorizontally,
                    animated: true
                )
                self.reactor?.action.onNext(.categoryButtonDidTap(index))
            }
            .disposed(by: disposeBag)
        
        pageContainerCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        pageCellEventRelay
            .map { Reactor.Action.pageCellEventOccurred(event: $0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func setupView() {
        view.backgroundColor = .white
        view.add(
            navigationView,
            segmentedView,
            pageContainerCollectionView
        )
    }
    
    private func makeConstraints() {
        navigationView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
        }
        
        segmentedView.snp.makeConstraints {
            $0.top.equalTo(navigationView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
        }
        
        pageContainerCollectionView.snp.makeConstraints {
            $0.top.equalTo(segmentedView.snp.bottom)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
    }
}

extension MyNoteViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width,
                      height: collectionView.bounds.height)
    }
}
