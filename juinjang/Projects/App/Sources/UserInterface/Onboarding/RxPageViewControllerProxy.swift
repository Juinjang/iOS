//
//  RxPageViewControllerProxy.swift
//  juinjang
//
//  Created by 강동영 on 3/11/25.
//

import UIKit
import RxSwift
import RxCocoa

final class RxPageViewControllerProxy: DelegateProxy<UIPageViewController, UIPageViewControllerDelegate>, DelegateProxyType, UIPageViewControllerDelegate {
    static func registerKnownImplementations() {
        self.register { pageViewController -> RxPageViewControllerProxy in
            RxPageViewControllerProxy(parentObject: pageViewController, delegateProxy: self)
        }
    }
    
    static func currentDelegate(for object: UIPageViewController) -> (any UIPageViewControllerDelegate)? {
        object.delegate
    }
    
    static func setCurrentDelegate(_ delegate: (any UIPageViewControllerDelegate)?, to object: UIPageViewController) {
        object.delegate = delegate
    }
}
