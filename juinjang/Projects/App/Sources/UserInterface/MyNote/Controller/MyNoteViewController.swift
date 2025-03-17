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

final class MyNoteViewController: UIViewController, View {
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
            $0.bind(to: self.pageContainerCollectionView)
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
            $0.isPagingEnabled = true
            $0.showsHorizontalScrollIndicator = false
            $0.register(MyNotePageCell.self)
        }
    }()
    
    private lazy var pageDataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<Void, MyNotePageModel>>(
        configureCell: { [weak self] _, collectionView, indexPath, item in
            guard let self = self else { return UICollectionViewCell() }
            guard let cell = collectionView.dequeueReusableCell(MyNotePageCell.self, indexPath) else {
                return UICollectionViewCell()
            }
            
            cell.bind(sections: item.sections, title: item.category.toText)
            return cell
        }
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        makeConstraints()
        reactor?.action.onNext(.viewDidLoad)
    }
    
    func bind(reactor: MyNoteViewReactor) {
        reactor.state
            .compactMap { $0.categoryState }
            .asDriver(onErrorDriveWith: .just(.share))
            .drive(with: self, onNext: { owner, state in
                switch state {
                case .share:
                    print("공유한 노트 클릭")
                case .own:
                    print("소장 노트 클릭")
                case .like:
                    print("좋아요 누른 노트 클릭")
                }
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { state -> [SectionModel<Void, MyNotePageModel>] in
                return [SectionModel(model: (), items: state.pages)]
            }
            .bind(to: pageContainerCollectionView.rx.items(dataSource: pageDataSource))
            .disposed(by: disposeBag)
        
        self.navigationView
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
        
        self.segmentedView
            .buttonTapRelay
            .withUnretained(self)
            .subscribe { (self, index) in
                self.pageContainerCollectionView.scrollToItem(
                    at: IndexPath(item: index, section: 0),
                    at: .centeredHorizontally,
                    animated: true
                )
            }
            .disposed(by: disposeBag)
        
        self.pageContainerCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    private func setupView() {
        self.view.backgroundColor = .white
        self.view.add(
            self.navigationView,
            self.segmentedView,
            self.pageContainerCollectionView
        )
    }
    
    private func makeConstraints() {
        self.navigationView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
        }
        
        self.segmentedView.snp.makeConstraints {
            $0.top.equalTo(self.navigationView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
        }
        
        self.pageContainerCollectionView.snp.makeConstraints {
            $0.top.equalTo(self.segmentedView.snp.bottom)
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

//@available(iOS 17.0, *)
//#Preview {
//    MyNoteViewController().then {
//        $0.reactor = MyNoteViewReactor(
//            dependency: .init(myNoteRepository: MyNoteRepository())
//        )
//    }
//}
