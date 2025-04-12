//
//  Rx+Extension.swift
//  juinjang
//
//  Created by KimDongWoo on 3/22/25.
//

import RxSwift
import RxCocoa
import UIKit

extension Reactive where Base: UIButton {
    var throttleTap: Observable<ControlEvent<()>.Element> {
        return self.controlEvent(.touchUpInside)
            .throttle(.milliseconds(500),
                      latest: false,
                      scheduler: MainScheduler.instance)
    }
}

extension Reactive where Base: UICollectionView {
    func bindSectionItems<S: Hashable, I: Hashable>(
        to dataSource: UICollectionViewDiffableDataSource<S, I>,
        orderedBy preferredOrder: [S]
    ) -> Binder<[S: [I]]> {
        return Binder(base) { collectionView, sectionItems in
            var snapshot = NSDiffableDataSourceSnapshot<S, I>()
            let sections = preferredOrder.filter { sectionItems.keys.contains($0) }
            snapshot.appendSections(sections)
            for section in sections {
                snapshot.appendItems(sectionItems[section] ?? [], toSection: section)
            }
            dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
}
