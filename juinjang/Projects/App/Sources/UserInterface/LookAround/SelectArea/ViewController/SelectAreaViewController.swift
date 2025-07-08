//
//  SelectAreaViewController.swift
//  juinjang
//
//  Created by 조유진 on 3/20/25.
//

import UIKit
import ReactorKit

protocol SendSelectedAreasDelegate: AnyObject {
    func sendSelectedAreas(list: [DongCellItem])
    func setDefaultLookAround()
}

final class SelectAreaViewController: BaseViewController, View {
    typealias SidoDataSource = UICollectionViewDiffableDataSource<SelectAreaSection, SidoCellItem>
    private var sidoDataSource: SidoDataSource!
    
    typealias SigunguDataSource = UICollectionViewDiffableDataSource<SelectAreaSection, SigunguCellItem>
    private var sigunguDataSource: SigunguDataSource!
    
    typealias DongDataSource = UICollectionViewDiffableDataSource<SelectAreaSection, DongCellItem>
    private var dongDataSource: DongDataSource!
    
    var disposeBag = DisposeBag()
    
    private let mainView = SelectAreaView()
    
    weak var sendSelectedAreasDelegate: SendSelectedAreasDelegate?
    
    init(reactor: SelectAreaReactor) {
        super.init()
        configureSidoDataSource()
        configureSigunguDataSource()
        configureDongDataSource()
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
        
        reactor.state.map { $0.dongList }
            .subscribe(with: self) { owner, dongSectionModel in
                owner.applyDongList(sections: dongSectionModel)
            }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.selectedAreaList }
            .subscribe(with: self) { owner, selectedAreaList in
                owner.mainView.selectedAreaView.isHidden = selectedAreaList.isEmpty
                owner.mainView.setCollectionViewContentInset(isShowSelectedAreaView: !selectedAreaList.isEmpty)
                owner.mainView.selectedAreaView.configureSelectedList(itemList: selectedAreaList)
            }
            .disposed(by: disposeBag)
        
        reactor.state.compactMap { $0.errorMessage }
            .subscribe(with: self) { owner, errorMessage in
                owner.showAlert(title: nil, message: errorMessage, actionHandler: nil)
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
        
        mainView.sigunguCollectionView.rx.itemSelected
            .subscribe(with: self) { owner, indexPath in
                owner.reactor?.action.onNext(.sigunguSelected(indexPath.item))
            }
            .disposed(by: disposeBag)
        
        mainView.dongCollectionView.rx.itemSelected
            .subscribe(with: self) { owner, indexPath in
                owner.reactor?.action.onNext(.dongSelected(indexPath.item))
            }
            .disposed(by: disposeBag)
        
        mainView.selectedAreaView.resetTapRelay
            .subscribe(with: self) { owner, _ in
                owner.mainView.selectedAreaView.isHidden = true
                owner.mainView.selectedAreaView.configureSelectedList(itemList: [])
                owner.reactor?.action.onNext(.resetButtonTapped)
            }
            .disposed(by: disposeBag)
        
        mainView.bottomButtonView.cancelButtonTapRelay
            .subscribe(with: self) { owner, _ in
                owner.popViewController()
            }
            .disposed(by: disposeBag)
        
        mainView.bottomButtonView.confirmButtonTapRelay
            .subscribe(with: self) { owner, _ in
                guard let reactor = owner.reactor else { return }
                owner.confirmSelectedAreaList()
            }
            .disposed(by: disposeBag)
    }
    
    private func applySidoList(sections: [SidoSectionModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<SelectAreaSection, SidoCellItem>()

        for section in sections {
            snapshot.appendSections([section.section])
            snapshot.appendItems(section.sidoItemList, toSection: section.section)
        }
        sidoDataSource.apply(snapshot, animatingDifferences: false)
    }
    
    private func applySigunguList(sections: [SigunguSectionModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<SelectAreaSection, SigunguCellItem>()

        for section in sections {
            snapshot.appendSections([section.section])
            snapshot.appendItems(section.sigunguItemList, toSection: section.section)
        }
        sigunguDataSource.apply(snapshot, animatingDifferences: false)
    }
    
    private func applyDongList(sections: [DongSectionModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<SelectAreaSection, DongCellItem>()
   
        for section in sections {
            snapshot.appendSections([section.section])
            snapshot.appendItems(section.dongItemList, toSection: section.section)
        }
        dongDataSource.apply(snapshot, animatingDifferences: false)
    }
    
    private func popViewController() {
        navigationController?.popViewController(animated: true)
    }
    
    private func confirmSelectedAreaList() {
        guard let reactor = reactor else { return }
        guard !reactor.currentState.selectedAreaList.isEmpty else {
            sendSelectedAreasDelegate?.setDefaultLookAround()
            popViewController()
            return
        }
        sendSelectedAreasDelegate?.sendSelectedAreas(list: reactor.currentState.selectedAreaList)
        popViewController()
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
    
    private func configureDongDataSource() {
        dongDataSource = DongDataSource(
            collectionView: mainView.dongCollectionView
        ) { collectionView, indexPath, item in
            let cell = collectionView.dequeueReusableCell(DongCell.self, for: indexPath)
            cell.configureCell(item: item)
            return cell
        }
    }
}
