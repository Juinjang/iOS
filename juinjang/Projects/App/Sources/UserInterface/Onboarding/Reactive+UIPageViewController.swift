//
//  Reactive+UIPageViewController.swift
//  juinjang
//
//  Created by 강동영 on 3/11/25.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UIPageViewController {
    private var delegate: DelegateProxy<UIPageViewController, UIPageViewControllerDelegate> {
        RxPageViewControllerProxy.proxy(for: self.base)
    }
    var didFinishAnimating: Observable<(UIPageViewController, [UIViewController])> {
        return delegate.methodInvoked(#selector(UIPageViewControllerDelegate.pageViewController(_:didFinishAnimating:previousViewControllers:transitionCompleted:)))
            .map { parameters in
                let pageViewController = try castOrThrow(UIPageViewController.self, parameters[0])
                let previousViewControllers = try castOrThrow([UIViewController].self, parameters[2])
                return (pageViewController, previousViewControllers)
            }
    }
    
    var currentPageVC: Observable<UIViewController> {
        return didFinishAnimating
            .compactMap { (pageViewController, vc) in
                return pageViewController.viewControllers?.first
            }
    }
    
    private func castOrThrow<T>(_ resultType: T.Type, _ object: Any) throws -> T {
        guard let returnValue = object as? T else {
            throw RxCocoaError.castingError(object: object, targetType: resultType)
        }
        
        return returnValue
    }
}
