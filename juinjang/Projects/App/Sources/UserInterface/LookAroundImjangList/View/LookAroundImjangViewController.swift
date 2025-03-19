//
//  LookAroundImjangViewController.swift
//  juinjang
//
//  Created by 조유진 on 2/27/25.
//

import UIKit
import ReactorKit
import RxDataSources

final class LookAroundImjangViewController: BaseViewController, View {
    var disposeBag = DisposeBag()
    
    private let mainView = LookAroundImjangView()
    private lazy var dataSource: RxCollectionViewSectionedReloadDataSource<SectionOfLookAroundImjangData> = {
        let dataSource = configureCollectionViewDataSource()
        return dataSource
    }()
    
    init(reactor: LookAroundImjangReactor) {
        super.init()
        self.reactor = reactor
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
    
    func bind(reactor: LookAroundImjangReactor) {
        
        mainView.navigationView.itemActionRelay
            .bind(with: self, onNext: { owner, action in
                switch action {
                case .popButtonTap: owner.popVewController()
                case .searchButtonTap: owner.showSearchLookAroundImjangVC()
                default: break
                }
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.sectionOfLookAroundImjangData }
            .compactMap { $0 }
            .bind(to: mainView.collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    private func popVewController() {
        print(#function)
        navigationController?.popViewController(animated: true)
    }
    
    private func showSearchLookAroundImjangVC() {
        print(#function)
        // TODO: show SearchLookAroundImjangVC
    }
}

extension LookAroundImjangViewController {
    private func configureCollectionViewDataSource() -> RxCollectionViewSectionedReloadDataSource<SectionOfLookAroundImjangData> {
        return RxCollectionViewSectionedReloadDataSource<SectionOfLookAroundImjangData>(configureCell: { dataSource, collectionView, indexPath, lookAroundImjangData in
            switch dataSource[indexPath] {
            case .contentsSection(let content):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LookAroundContentCell.identifier, for: indexPath) as? LookAroundContentCell else { return UICollectionViewCell() }
                cell.configureCell(content: content)
                return cell
                
            case .selectAreaSection(let selectArea):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SelectAreaCell.identifier, for: indexPath) as? SelectAreaCell else { return UICollectionViewCell() }
                
                cell.configureCell(area: selectArea)
                
                return cell
                
            case .imjangCountSection(let imjangCount):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LookAroundImjangCountCell.identifier, for: indexPath) as? LookAroundImjangCountCell else { return UICollectionViewCell() }
                cell.configureCell(imjangCount: imjangCount)
                return cell
                
            case .imjangListSection(let lookAroundImjang):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LookAroundImjangCell.identifier, for: indexPath) as? LookAroundImjangCell else { return UICollectionViewCell() }
                cell.configureCell(lookAroundImjang)
                return cell
            }
        }, configureSupplementaryView: { dataSource, collectionView, string, indexPath in
            let section = dataSource.sectionModels[indexPath.section]
            switch section {
            case .imjangListSection(_, _):
                guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: LookAroundFilterHeader.identifier, for: indexPath) as? LookAroundFilterHeader else {
                    return UICollectionReusableView()
                }
                
                return headerView
           
            default: return UICollectionReusableView()
            }
        })
    }
}
