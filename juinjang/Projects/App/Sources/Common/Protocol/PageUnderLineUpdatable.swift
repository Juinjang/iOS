//
//  PageIndicatorUpdatable.swift
//  juinjang
//
//  Created by KimDongWoo on 3/14/25.
//

import UIKit
import RxSwift
import RxCocoa

protocol PageUnderLineUpdatable: AnyObject {
    var buttons: [UIButton] { get }
    var underLineView: UIView { get }
    var previousIndex: Int { get set }
    var disposeBag: DisposeBag { get set }
    var scrollSelectedRelay: PublishRelay<Int> { get }

    func updateSelectedButtonState(index: Int)
    func bind(to scrollView: UIScrollView)
}

extension PageUnderLineUpdatable where Self: UIView {
    private var _isSegmentTapTriggeredKey: UnsafeRawPointer {
        UnsafeRawPointer(bitPattern: "isSegmentTapTriggered".hashValue)!
    }
    
    var isSegmentTapTriggered: Bool {
        get {
            objc_getAssociatedObject(self, _isSegmentTapTriggeredKey) as? Bool ?? false
        }
        set {
            objc_setAssociatedObject(self, _isSegmentTapTriggeredKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func bind(to scrollView: UIScrollView) {
        scrollView.rx.contentOffset
            .filter { _ in scrollView.bounds.width > 0 }
            .map { $0.x / scrollView.bounds.width }
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .bind { (self, progress) in
                if !self.isSegmentTapTriggered {
                    self.moveUnderline(by: progress)
                }
            }
            .disposed(by: disposeBag)
        
        Observable.merge(
            scrollView.rx.didEndDecelerating.map { _ in },
            scrollView.rx.didEndScrollingAnimation.map { _ in }
        )
        .observe(on: MainScheduler.instance)
        .withUnretained(self)
        .bind { (self, _) in
            self.isSegmentTapTriggered = false
        }
        .disposed(by: disposeBag)
    }
    
    func updateSelectedButtonState(index: Int) {
        buttons.enumerated().forEach { idx, button in
            button.isSelected = (idx == index)
        }
    }
    
    func moveUnderline(by progress: CGFloat) {
        guard buttons.count > 1 else { return }

        let currentIndex = Int(floor(progress))
        let nextIndex = min(currentIndex + 1, buttons.count - 1)

        guard currentIndex >= 0, nextIndex < buttons.count else {
            return
        }
        
        let (interpolatedCenterX, interpolatedWidth) = interpolatedUnderlinePosition(
            from: currentIndex,
            to: nextIndex,
            progress: progress - CGFloat(currentIndex)
        )
        
        updateUnderLine(centerX: interpolatedCenterX, width: interpolatedWidth)
        checkAndUpdateSelectedIndex()
    }
    
    private func updateUnderLine(centerX: CGFloat, width: CGFloat) {
        underLineView.bounds.size.width = width
        underLineView.center.x = centerX
    }

    private func interpolatedUnderlinePosition(from currentIndex: Int,
                                               to nextIndex: Int,
                                               progress: CGFloat) -> (centerX: CGFloat, width: CGFloat) {
        guard let currentLabel = buttons[safe: currentIndex]?.titleLabel,
              let nextLabel = buttons[safe: nextIndex]?.titleLabel else {
            return (centerX: 0, width: 0)
        }

        let currentFrame = currentLabel.convert(currentLabel.bounds, to: self)
        let nextFrame = nextLabel.convert(nextLabel.bounds, to: self)

        let interpolatedCenterX = interpolate(from: currentFrame.midX,
                                              to: nextFrame.midX,
                                              progress: progress)

        let interpolatedWidth = interpolate(from: currentFrame.width,
                                            to: nextFrame.width,
                                            progress: progress)

        return (centerX: interpolatedCenterX, width: interpolatedWidth)
    }

    private func interpolate(from start: CGFloat,
                             to end: CGFloat,
                             progress: CGFloat) -> CGFloat {
        return start + ((end - start) * progress)
    }

    func checkAndUpdateSelectedIndex() {
        guard let nearestIndex = nearestIndexToUnderlineCenter() else { return }
        
        if nearestIndex != previousIndex {
            updateSelectedButtonState(index: nearestIndex)
            previousIndex = nearestIndex
            scrollSelectedRelay.accept(nearestIndex)
        }
    }

    private func nearestIndexToUnderlineCenter() -> Int? {
        guard buttons.count > 0 else { return nil }
        
        let underlineCenterX = underLineView.center.x
        
        var closestIndex = 0
        var smallestDistance = CGFloat.greatestFiniteMagnitude
        
        for (index, button) in buttons.enumerated() {
            guard let titleLabel = button.titleLabel else { continue }
            
            titleLabel.layoutIfNeeded()
            
            let titleFrame = titleLabel.convert(titleLabel.bounds, to: self)
            let titleCenterX = titleFrame.midX
            
            let distance = abs(underlineCenterX - titleCenterX)
            
            if distance < smallestDistance {
                smallestDistance = distance
                closestIndex = index
            }
        }
        
        return closestIndex
    }
}


fileprivate extension Array {
    subscript(safe index: Int) -> Element? {
        return (0..<count).contains(index) ? self[index] : nil
    }
}
