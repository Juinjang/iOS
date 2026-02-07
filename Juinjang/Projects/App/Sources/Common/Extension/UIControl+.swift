//
//  UIControl+.swift
//  App
//
//  Created by 조유진 on 1/31/26.
//

import UIKit
import ObjectiveC

private var lastEventTimeKey: UInt8 = 0

extension UIControl {
    func shouldAcceptEvent(throttleInterval: TimeInterval = 2.0) -> Bool {
        let now = CACurrentMediaTime()
        let lastTime = (objc_getAssociatedObject(self, &lastEventTimeKey) as? TimeInterval) ?? 0

        guard now - lastTime >= throttleInterval else { return false }
        objc_setAssociatedObject(self, &lastEventTimeKey, now, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return true
    }
}
