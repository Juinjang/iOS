//
//  MyNoteView.swift
//  juinjang
//
//  Created by KimDongWoo on 3/29/25.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxRelay
import RxDataSources

final class MyNoteView: BaseView {
    private let disposeBag = DisposeBag()
    
    private let navigationView = DefaultNavigationView().then {
        $0.title = "마이노트"
        $0.leftItem = [.pop]
        $0.rightItem = [.search]
    }
    
    lazy var segmentedView: UnderLineSegmentedView = {
        return UnderLineSegmentedView(
            titles: MyNoteCategoryType.allCases.map { $0.toText },
            horizontalInset: 46.5
        ).then {
            $0.bind(to: pageContainerCollectionView)
        }
    }()
    
    lazy var pageContainerCollectionView: UICollectionView = {
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
    
    let pageCellEventRelay = PublishRelay<MyNotePageEventType>()
    let navigationEventRelay = PublishRelay<NavigationAction>()
    
    override func configureView() {
        super.configureView()
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        add(
            navigationView,
            segmentedView,
            pageContainerCollectionView
        )
    }
    
    override func configureLayout() {
        super.configureLayout()
        
        navigationView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
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
