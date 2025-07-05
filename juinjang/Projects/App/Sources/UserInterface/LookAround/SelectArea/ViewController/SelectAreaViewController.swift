//
//  SelectAreaViewController.swift
//  juinjang
//
//  Created by 조유진 on 3/20/25.
//

import UIKit
import ReactorKit

final class SelectAreaViewController: BaseViewController, View {
    typealias SidoDataSource = UICollectionViewDiffableDataSource<SelectAreaSection, SidoCellItem>
    private var sidoDataSource: SidoDataSource!
    
    typealias SigunguDataSource = UICollectionViewDiffableDataSource<SelectAreaSection, SigunguCellItem>
    private var sigunguDataSource: SigunguDataSource!
    
    var disposeBag = DisposeBag()
    
    private let mainView = SelectAreaView()
    
    init(reactor: SelectAreaReactor) {
        super.init()
        configureSidoDataSource()
        configureSigunguDataSource()
        self.reactor = reactor
        bindEvent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reactor?.action.onNext(.viewDidLoad)
    }

    override func loadView() {
        view = mainView
    }
    
    func bind(reactor: SelectAreaReactor) {
        reactor.state
            .map { $0.sidoList }
            .observe(on: MainScheduler.asyncInstance)
            .distinctUntilChanged()
            .subscribe(with: self) { owner, sidoSectionModel in
                owner.applySidoList(sections: sidoSectionModel)
            }
            .disposed(by: disposeBag)

        
        reactor.state.map { $0.sigunguList }
            .subscribe(with: self) { owner, sigunguSectionModel in
                owner.applySigunguList(sections: sigunguSectionModel)
            }
            .disposed(by: disposeBag)
    }
    
    func bindEvent() {
        mainView.navigationView.itemActionRelay
            .subscribe(with: self) { owner, action in
                switch action {
                case .popButtonTap:
                    owner.popViewController()
                default: break
                }
            }
            .disposed(by: disposeBag)
        
        mainView.sidoCollectionView.rx.itemSelected
            .subscribe(with: self) { owner, indexPath in
                owner.reactor?.action.onNext(.sidoSelected(indexPath.item))
            }
            .disposed(by: disposeBag)
    }
    
    private func applySidoList(sections: [SidoSectionModel]) {
        print(#function)
        var snapshot = NSDiffableDataSourceSnapshot<SelectAreaSection, SidoCellItem>()

        for section in sections {
            snapshot.appendSections([section.section])
            snapshot.appendItems(section.sidoItemList, toSection: section.section)
        }
        sidoDataSource.apply(snapshot, animatingDifferences: false)
    }
    
    private func applySigunguList(sections: [SigunguSectionModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<SelectAreaSection, SigunguCellItem>()
        print(sections.count)
        for section in sections {
            snapshot.appendSections([section.section])
            snapshot.appendItems(section.sigunguItemList, toSection: section.section)
        }
        sigunguDataSource.apply(snapshot, animatingDifferences: false)
    }
    
    private func popViewController() {
        navigationController?.popViewController(animated: true)
    }
}

extension SelectAreaViewController {
    private func configureSidoDataSource() {
        sidoDataSource = SidoDataSource(
            collectionView: mainView.sidoCollectionView
        ) { collectionView, indexPath, item in
            let cell = collectionView.dequeueReusableCell(SidoCell.self, for: indexPath)
            cell.configureCell(item: item)
            return cell
        }
    }
    
    private func configureSigunguDataSource() {
        sigunguDataSource = SigunguDataSource(
            collectionView: mainView.sigunguCollectionView
        ) { collectionView, indexPath, item in
            let cell = collectionView.dequeueReusableCell(SigunguCell.self, for: indexPath)
            cell.configureCell(item: item)
            return cell
        }
    }
}
