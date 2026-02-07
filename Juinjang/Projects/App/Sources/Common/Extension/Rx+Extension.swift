//
//  Rx+Extension.swift
//  juinjang
//
//  Created by KimDongWoo on 3/22/25.
//

import RxSwift
import RxCocoa
import UIKit
import ReactorKit

extension Reactive where Base: UIButton {
    var throttleTap: Observable<ControlEvent<()>.Element> {
        return self.controlEvent(.touchUpInside)
            .throttle(.milliseconds(1500),
                      latest: false,
                      scheduler: MainScheduler.instance)
    }
    
    func throttleTap(milliseconds: Int) -> Observable<ControlEvent<()>.Element> {
        return self.controlEvent(.touchUpInside)
            .throttle(.milliseconds(milliseconds),
                      latest: false,
                      scheduler: MainScheduler.instance)
    }
}

extension Reactive where Base: UIScreen {
    var isRecording: Observable<Bool> {
        return Observable.create { observer in
            observer.onNext(UIScreen.main.isCaptured)

            let token = NotificationCenter.default.addObserver(
                forName: UIScreen.capturedDidChangeNotification,
                object: nil,
                queue: .main
            ) { _ in
                observer.onNext(UIScreen.main.isCaptured)
            }

            return Disposables.create {
                NotificationCenter.default.removeObserver(token)
            }
        }
    }
}

extension Reactive where Base: UIApplication {
    var didCapture: Observable<Void> {
        return NotificationCenter.default.rx
            .notification(UIApplication.userDidTakeScreenshotNotification)
            .map { _ in }
    }
}

extension Observable where Element == Void {
    func withHaptic(style: UIImpactFeedbackGenerator.FeedbackStyle = .medium) -> Observable<Void> {
        return self.do(onNext: {
            let generator = UIImpactFeedbackGenerator(style: style)
            generator.prepare()
            generator.impactOccurred()
        })
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
            UIView.performWithoutAnimation {
                dataSource.apply(snapshot, animatingDifferences: false)
            }
        }
    }
    
    func isCellAboveCenter(at indexPath: IndexPath) -> Observable<Bool> {
        return contentOffset
            .map { [weak base] offset -> Bool in
                guard
                    let base = base,
                    let attr = base.layoutAttributesForItem(at: indexPath)
                else { return false }
                
                let cellTop = attr.frame.minY - offset.y
                let centerY = base.bounds.height / 2
                return cellTop < centerY
            }
            .distinctUntilChanged()
    }
}
